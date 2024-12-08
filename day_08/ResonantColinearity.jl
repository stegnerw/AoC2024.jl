#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  stack(eachline(f))
end

# Mark the location of each antenna by type
antennas = findall(x->x!='.', input)
antennas_map = Dict{Char, Vector{CartesianIndex{2}}}()
for antenna in antennas
  type = input[antenna]
  if !haskey(antennas_map, type)
    antennas_map[type] = Vector{CartesianIndex{2}}()
  end
  push!(antennas_map[type], antenna)
end

##########
# Part 1 #
##########

antinodes = zeros(Bool, size(input))

function markAntinode(pos::CartesianIndex{2}, map::Matrix{Bool})::Bool
  global antinodes
  if checkbounds(Bool, antinodes, pos)
    map[pos] = true
    return true
  else
    return false
  end
end

for (type, locations) in antennas_map
  for i in eachindex(locations), j in eachindex(locations[i+1:end])
    diff = locations[i] - locations[i+j]
    markAntinode(locations[i] + diff, antinodes)
    markAntinode(locations[i+j] - diff, antinodes)
  end
end

println("Antinodes: $(sum(antinodes))")

##########
# Part 2 #
##########

resonant_antinodes = zeros(Bool, size(input))

for (type, locations) in antennas_map
  for i in eachindex(locations), j in eachindex(locations[i+1:end])
    diff = locations[i] - locations[i+j]
    # We never actually need to scale but I thought this was a nifty operation
    # Efficiency be damned!!
    scale = gcd(diff[1], diff[2])
    scl_diff = CartesianIndex(div.(diff.I, scale))
    distance = 0
    while markAntinode(locations[i] + distance * scl_diff, resonant_antinodes)
      distance += 1
    end
    distance = 0
    while markAntinode(locations[i] + distance * scl_diff, resonant_antinodes)
      distance -= 1
    end
  end
end

println("Resonant antinodes: $(sum(resonant_antinodes))")
