#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

# Split input
split_point = findfirst(x->x=="", input)
warehouse = stack(input[1:split_point-1])
moves = join(input[split_point+1:end])
robot_pos = findfirst(x->x=='@', warehouse)

# Offset to tile entity is facing
# First coordinate is distance from left boundary
# Second coordinate is distance from top boundary
dirs = Dict('^' => CartesianIndex{2}(0, -1), # up
            '>' => CartesianIndex{2}(1, 0),  # right
            'v' => CartesianIndex{2}(0, 1),  # down
            '<' => CartesianIndex{2}(-1, 0)) # left

##########
# Part 1 #
##########

function printwarehouse(warehouse::Matrix{Char})
  for c in eachcol(warehouse)
    for r in c
      print(r=='.' ? ' ' : r)
    end
    println()
  end
end

function move(wh::Matrix{Char}, pos::CartesianIndex{2},
              dir::Char)::Bool
  if !checkbounds(Bool, wh, pos)
    return false
  elseif wh[pos] == '#'
    return false
  elseif wh[pos] == '.'
    return true
  end

  new_pos = pos + dirs[dir]
  can_move = move(wh, new_pos, dir)
  if can_move
    wh[new_pos], wh[pos] = wh[pos], wh[new_pos]
  end
  return can_move
end

#println("Initial warehouse:")
#printwarehouse(warehouse)

for m in moves
  global robot_pos
  #@show m
  if move(warehouse, robot_pos, m)
    robot_pos += dirs[m]
  end
end

#println("Final warehouse:")
#printwarehouse(warehouse)

box_coords = findall(x->x=='O', warehouse)
gps_coords = [100 * (x[2]-1) + (x[1] - 1) for x in box_coords]
println("Sum of GPS coordinates: $(sum(gps_coords))")

##########
# Part 2 #
##########

function getbigwarehouse(warehouse::Matrix{Char})
  new_warehouse = Matrix{Char}(undef, size(warehouse)[1]*2, size(warehouse)[2])
  for idx in eachindex(warehouse)
    scaled_idx = 2*(idx-1) + 1
    if warehouse[idx] == '@'
      new_warehouse[scaled_idx] = warehouse[idx]
      new_warehouse[scaled_idx+1] = '.'
    elseif warehouse[idx] == 'O'
      new_warehouse[scaled_idx] = '['
      new_warehouse[scaled_idx+1] = ']'
    else
      new_warehouse[scaled_idx] = warehouse[idx]
      new_warehouse[scaled_idx+1] = warehouse[idx]
    end
  end
  return new_warehouse
end

function big_canmove(wh::Matrix{Char}, pos::CartesianIndex{2},
                     dir::Char)::Bool
  if !checkbounds(Bool, wh, pos)
    return false
  elseif wh[pos] == '#'
    return false
  elseif wh[pos] == '.'
    return true
  end

  pos2::Union{Nothing, CartesianIndex{2}} = nothing
  if wh[pos] == ']'
    pos2 = pos + dirs['<']
  elseif wh[pos] == '['
    pos2 = pos + dirs['>']
  end

  return big_canmove(wh, pos+dirs[dir], dir) &&
         (isnothing(pos2) || big_canmove(wh, pos2+dirs[dir], dir))
end

function big_move(wh::Matrix{Char}, pos::CartesianIndex{2},
                  dir::Char)::Bool
  if wh[pos] == '.' return true end

  pos2::Union{Nothing, CartesianIndex{2}} = nothing
  if wh[pos] == ']'
    pos2 = pos + dirs['<']
  elseif wh[pos] == '['
    pos2 = pos + dirs['>']
  end

  big_move(wh, pos+dirs[dir], dir)
  wh[pos+dirs[dir]], wh[pos] = wh[pos], wh[pos+dirs[dir]]
  if !isnothing(pos2)
    big_move(wh, pos2+dirs[dir], dir)
    wh[pos2+dirs[dir]], wh[pos2] = wh[pos2], wh[pos2+dirs[dir]]
  end
  return true
end

bigwarehouse = getbigwarehouse(stack(input[1:split_point-1]))

#println("Initial big warehouse:")
#printwarehouse(bigwarehouse)

robot_pos = findfirst(x->x=='@', bigwarehouse)

for m in moves
  global robot_pos
  #@show m
  if m == '<' || m == '>'
    if move(bigwarehouse, robot_pos, m)
      robot_pos += dirs[m]
    end
  else
    if big_canmove(bigwarehouse, robot_pos, m)
      big_move(bigwarehouse, robot_pos, m)
      robot_pos += dirs[m]
    end
  end
end

#println("Final big warehouse:")
#printwarehouse(bigwarehouse)

big_box_coords = findall(x->x=='[', bigwarehouse)
big_gps_coords = [100 * (x[2]-1) + (x[1] - 1) for x in big_box_coords]
println("Sum of GPS coordinates: $(sum(big_gps_coords))")

