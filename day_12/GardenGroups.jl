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

visited1 = zeros(Bool, size(input))

function getfences(pos::CartesianIndex{2}, m::Matrix{Char})::Int
  return count(dir->!checkbounds(Bool, m, pos+dir) ||
               m[pos] != m[pos+dir], dirs)
end

function getareafences(pos::CartesianIndex{2}, m::Matrix{Char},
                       v::Matrix{Bool}, fence_func::Function)::Vector{Int}
  if v[pos] return [0,0] end
  v[pos] = true
  area_fences = [1, fence_func(pos, m)]
  for dir in dirs
    next_pos = pos + dir
    if !checkbounds(Bool, m, next_pos) || m[pos] != m[next_pos]
      continue
    end
    area_fences += getareafences(next_pos, m, v, fence_func)
  end
  return area_fences
end

function getcost(area_fences::Vector{Int})::Int
  return area_fences[1] * area_fences[2]
end

cost = sum(map(x->getcost(getareafences(x, input, visited1, getfences)),
               CartesianIndices(size(input))))
println("Cost: $(cost)")

##########
# Part 2 #
##########

visited2 = zeros(Bool, size(input))
long_fences = Dict{Char,Array{Bool}}()#char => zeros(Bool, (size(input)..., 4))

function mark_longfences(pos::CartesianIndex{2}, d::Int, m::Matrix{Char})
  for dir in [dirs[(d%4)+1], dirs[d==1 ? 4 : d-1]]
    offset = 0
    next_pos = pos + dir*offset
    # This is the worst conditional I have ever written in my life
    # ... But it works
    while checkbounds(Bool, m, next_pos) &&
      m[pos] == m[next_pos] &&
      (!checkbounds(Bool, m, pos+dir*offset+dirs[d]) ||
       m[pos] != m[pos+dir*offset+dirs[d]])
      long_fences[m[pos]][next_pos[1], next_pos[2], d] = true
      offset += 1
      next_pos = pos + dir*offset
    end
  end
end

function getfences_discount(pos::CartesianIndex{2}, m::Matrix{Char})::Int
  fences = 0
  if !haskey(long_fences, m[pos])
    long_fences[m[pos]] = zeros(Bool, (size(input)..., 4))
  end
  for (d,dir) in enumerate(dirs)
    next_pos = pos + dir
    if long_fences[m[pos]][pos[1], pos[2], d] continue end
    if checkbounds(Bool, m, next_pos) && m[pos] == m[next_pos] continue end
    mark_longfences(pos, d, m)
    fences += 1
  end
  return fences
end

cost_discount = sum(map(x->getcost(getareafences(x, input, visited2,
                                                 getfences_discount)),
               CartesianIndices(size(input))))
println("Discount cost: $(cost_discount)")
