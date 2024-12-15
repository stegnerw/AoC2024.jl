#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

##########
# Part 1 #
##########

function printfacility(f::Matrix{Int})
  # Flip rows/cols to match problem description for easier visual comparison
  for c in eachcol(facility)
    for r in c
      print(r>0 ? r : '.')
    end
    println()
  end
end

function wrappos(pos::Vector{Int}, size::Vector{Int})::Vector{Int}
  # Position is zero-indexed when given but we need 1-indexed for display
  # purposes
  return (pos .% size + size) .% size + [1,1]
end

# Test Facility
#const facility_size = [11, 7]
# Real Facility
const facility_size = [101, 103]
facility = zeros(Int, Tuple(facility_size))
quadrants = zeros(Int, (2,2))
quadrant_bounds = ceil.(Int,facility_size / 2)
const max_sim_time = 100

pos_regex = r"p=(-?\d+),(-?\d+)"
vel_regex = r"v=(-?\d+),(-?\d+)"

for robot in input
  init_pos = parse.(Int, match(pos_regex, robot).captures)
  vel = parse.(Int, match(vel_regex, robot).captures)
  final_pos = init_pos + max_sim_time*vel
  final_pos = wrappos(final_pos, facility_size)
  if sum(final_pos .== quadrant_bounds) > 0
    continue
  end
  quadrant = div.(final_pos, quadrant_bounds)
  quadrants[CartesianIndex(Tuple(quadrant+[1,1]))] += 1
  # Tracking the facility is for debug display only
  facility[CartesianIndex(Tuple(final_pos))] += 1
end

#printfacility(facility)

safety_factor = 1
for quadrant in quadrants
  global safety_factor *= quadrant
end

println("Safety factor: $(safety_factor)")

##########
# Part 2 #
##########
