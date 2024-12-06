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
pos = [1, 1, 1]
for (i,row) in enumerate(input)
  y = findfirst(x->x=='^', row)
  if !isnothing(y)
    pos[1] = i
    pos[2] = y
    break
  end
end

##########
# Part 1 #
##########

visited = reshape(repeat([false], map_dims[1] * map_dims[2]),
                  map_dims[1], map_dims[2])
visited[pos[1],pos[2]] = true

function getFacingPos(p::Vector{Int})::Vector{Int}
  return p[1:2] + dirs[p[3]]
end

function facingEdge(p::Vector{Int})::Bool
  facing = getFacingPos(p)
  return facing[1] == 0 || facing[1] == map_dims[1]+1 ||
         facing[2] == 0 || facing[2] == map_dims[2]+1
end

function move(p::Vector{Int})
  facing = getFacingPos(p)
  if input[facing[1]][facing[2]] == '#'
    # turn right
    p[3] %= 4
    p[3] += 1
  else
    # Walk forward
    p[1] = facing[1]
    p[2] = facing[2]
    visited[p[1],p[2]] = true
  end
end

while !facingEdge(pos)
  move(pos)
end

println("Tiles visited: $(sum(visited))")

##########
# Part 2 #
##########


