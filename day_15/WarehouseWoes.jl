#!/usr/bin/env julia#.#.O..#

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

function move(pos::CartesianIndex{2}, dir::CartesianIndex{2})::Bool
  if !checkbounds(Bool, warehouse, pos)
    return false
  elseif warehouse[pos] == '#'
    return false
  elseif warehouse[pos] == '.'
    return true
  end

  new_pos = pos + dir
  can_move = move(new_pos, dir)
  if can_move
    warehouse[new_pos], warehouse[pos] = warehouse[pos], warehouse[new_pos]
  end
  return can_move
end

#println("Initial warehouse:")
#printwarehouse(warehouse)

for m in moves
  global robot_pos
  #@show m
  dir = dirs[m]
  if move(robot_pos, dir)
    robot_pos += dir
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
