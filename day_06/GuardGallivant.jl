#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

# (row, col)
map_dims = (length(input), length(input[1]))
# Offset to tile entity is facing
dirs = [[-1,0], # up
        [0,1],  # right
        [1,0],  # down
        [0,-1]] # left
# (row, col, dir) - dir - 1 = up, 2 = right, etc.
init_pos = [1, 1, 1]
for (i,row) in enumerate(input)
  y = findfirst(x->x=='^', row)
  if !isnothing(y)
    init_pos[1] = i
    init_pos[2] = y
    break
  end
end

##########
# Part 1 #
##########

pos = copy(init_pos)
visited = zeros(Bool, (map_dims[1], map_dims[2]))
visited[pos[1],pos[2]] = true

function getFacingPos(p::Vector{Int})::Vector{Int}
  return p[1:2] + dirs[p[3]]
end

function getTurnDir(p::Vector{Int})::Int
  return (p[3] % 4) + 1
end

function facingEdge(p::Vector{Int})::Bool
  facing = getFacingPos(p)
  return facing[1] == 0 || facing[1] == map_dims[1]+1 ||
         facing[2] == 0 || facing[2] == map_dims[2]+1
end

function move(p::Vector{Int}, add_ob::Array{Int}=[0,0])
  facing = getFacingPos(p)
  if input[facing[1]][facing[2]] == '#' || facing == add_ob
    # turn right
    p[3] = getTurnDir(p)
  else
    # Walk forward
    p[1] = facing[1]
    p[2] = facing[2]
  end
end

while !facingEdge(pos)
  move(pos)
  visited[pos[1],pos[2]] = true
end

println("Tiles visited: $(sum(visited))")

# Draw the path we took
#for r in 1:map_dims[1]
#  for c in 1:map_dims[2]
#    if r == init_pos[1] && c == init_pos[2]
#      print('^')
#    else
#      print(visited[r,c] ? '+' : ' ')
#    end
#  end
#  println()
#end

##########
# Part 2 #
##########

loop_options = 0

for row in 1:map_dims[1], col in 1:map_dims[2]
  if !visited[row,col] || (row == init_pos[1] && col == init_pos[2])
    continue
  end

  # Instead of just tracking where we were, track which directions we were
  # facing. Using a Set{Int} instead of Int because we can technically have
  # faced multiple directions and then the tracking could get messy.
  visited_dirs = Array{Set{Int}}(undef, map_dims[1], map_dims[2])
  for i in 1:length(visited_dirs)
    visited_dirs[i] = Set{Int}()
  end
  local pos = copy(init_pos)

  while !facingEdge(pos) && !in(pos[3], visited_dirs[pos[1],pos[2]])
    push!(visited_dirs[pos[1],pos[2]], pos[3])
    move(pos,[row,col])
  end

  global loop_options += !facingEdge(pos)
end

# Answer is 1951 but this is really slow
println("Loop options: $(loop_options)")
