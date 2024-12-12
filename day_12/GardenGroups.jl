#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  stack(eachline(f))
end

##########
# Part 1 #
##########

# Offset to tile entity is facing
dirs = [CartesianIndex(-1, 0),  # north
        CartesianIndex(0, 1),   # east
        CartesianIndex(1, 0),   # south
        CartesianIndex(0, -1)]  # west

visited = zeros(Bool, size(input))

function getfences(pos::CartesianIndex{2}, m::Matrix{Char})::Int
  return count(dir->!checkbounds(Bool, m, pos+dir) ||
               m[pos] != m[pos+dir], dirs)
end

function getareafences(pos::CartesianIndex{2}, m::Matrix{Char},
                       v::Matrix{Bool})::Vector{Int}
  if v[pos] return [0,0] end
  v[pos] = true
  area_fences = [1, getfences(pos, m)]
  for dir in dirs
    next_pos = pos + dir
    if !checkbounds(Bool, m, next_pos) || m[pos] != m[next_pos]
      continue
    end
    area_fences += getareafences(next_pos, m, v)
  end
  return area_fences
end

function getcost(area_fences::Vector{Int})::Int
  return area_fences[1] * area_fences[2]
end

cost = sum(map(x->getcost(getareafences(x, input, visited)),
               CartesianIndices(size(input))))
println("Cost: $(cost)")

##########
# Part 2 #
##########
