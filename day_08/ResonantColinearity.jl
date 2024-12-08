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

function markAntinode(pos::CartesianIndex{2})
  global antinodes
  if checkbounds(Bool, antinodes, pos)
    antinodes[pos] = true
  end
end

for (type, locations) in antennas_map
  for i in eachindex(locations), j in eachindex(locations[i+1:end])
    diff = locations[i] - locations[i+j]
    markAntinode(locations[i] + diff)
    markAntinode(locations[i+j] - diff)
  end
end

println("Antinodes: $(sum(antinodes))")

##########
# Part 2 #
##########
