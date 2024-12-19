#!/usr/bin/env julia
"https://adventofcode.com/2024/day/8"
module Day08

function parseinput(input::String)::Matrix{Char}
  return stack(split(input, '\n'))
end

function getantennas(map::Matrix{Char})::Dict{Char, Vector{CartesianIndex{2}}}
  antennas = findall(x->x!='.', map)
  antennas_map = Dict{Char, Vector{CartesianIndex{2}}}()
  for antenna in antennas
    type = map[antenna]
    if !haskey(antennas_map, type)
      antennas_map[type] = Vector{CartesianIndex{2}}()
    end
    push!(antennas_map[type], antenna)
  end
  return antennas_map
end

function markAntinode(pos::CartesianIndex{2}, map::Matrix{Bool})::Bool
  if checkbounds(Bool, map, pos)
    map[pos] = true
    return true
  else
    return false
  end
end

function part1(input::String)::Int
  map = parseinput(input)
  antennas_map = getantennas(map)
  antinodes = zeros(Bool, size(map))

  for (type, locations) in antennas_map
    for i in eachindex(locations), j in eachindex(locations[i+1:end])
      diff = locations[i] - locations[i+j]
      markAntinode(locations[i] + diff, antinodes)
      markAntinode(locations[i+j] - diff, antinodes)
    end
  end

  return sum(antinodes)
end

function part2(input::String)::Int
  map = parseinput(input)
  antennas_map = getantennas(map)
  antinodes = zeros(Bool, size(map))

  for (type, locations) in antennas_map
    for i in eachindex(locations), j in eachindex(locations[i+1:end])
      diff = locations[i] - locations[i+j]
      # We never actually need to scale but I thought this was a nifty operation
      # Efficiency be damned!!
      scale = gcd(diff[1], diff[2])
      scl_diff = CartesianIndex(div.(diff.I, scale))
      distance = 0
      while markAntinode(locations[i] + distance * scl_diff, antinodes)
        distance += 1
      end
      distance = 0
      while markAntinode(locations[i] + distance * scl_diff, antinodes)
        distance -= 1
      end
    end
  end

  return sum(antinodes)
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(8, testing)))
  println("Part 2:", part2(getinput(8, testing)))
end

end # module Day08
