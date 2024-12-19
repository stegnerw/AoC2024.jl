#!/usr/bin/env julia
"https://adventofcode.com/2024/day/12"
module Day12

function parseinput(input::String)::Matrix{Char}
  return stack(split(input, '\n'))
end

# Offset to tile entity is facing
dirs = [CartesianIndex(-1, 0),  # north
        CartesianIndex(0, 1),   # east
        CartesianIndex(1, 0),   # south
        CartesianIndex(0, -1)]  # west

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

function part1(input::String)::Int
  garden = parseinput(input)
  visited = zeros(Bool, size(garden))
  cost = sum(map(x->getcost(getareafences(x, garden, visited, getfences)),
                 CartesianIndices(size(garden))))
  return cost
end

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
    long_fences[m[pos]] = zeros(Bool, (size(m)..., 4))
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

function part2(input::String)::Int
  garden = parseinput(input)
  visited = zeros(Bool, size(garden))
  cost_discount = sum(map(x->getcost(getareafences(x, garden, visited,
                                                   getfences_discount)),
                          CartesianIndices(size(garden))))
  return cost_discount
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(12, testing)))
  println("Part 2:", part2(getinput(12, testing)))
end

end # module Day12
