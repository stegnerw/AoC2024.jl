#!/usr/bin/env julia

####################
# Input Processing #
####################

struct Robot
  pos::Vector{Int}
  vel::Vector{Int}
end

function parseline(l::AbstractString)
  pos = parse.(Int, match(r"p=(-?\d+),(-?\d+)", l).captures)
  vel = parse.(Int, match(r"v=(-?\d+),(-?\d+)", l).captures)
  return Robot(pos, vel)
end

input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

global robots::Vector{Robot} = map(parseline, input)

##########
# Part 1 #
##########

function printfacility(f::Matrix{Int})
  # Flip rows/cols to match problem description for easier visual comparison
  for c in eachcol(f)
    for r in c
      print(r>0 ? r : ' ')
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
const max_sim_time = 100

function simtotime(time::Int, anomaly_threshold::Float64=0.0)::Int
  global robots
  facility = zeros(Int, Tuple(facility_size))
  quadrants = zeros(Int, (2,2))
  quadrant_bounds = ceil.(Int,facility_size / 2)
  for robot in robots
    final_pos = robot.pos + time*robot.vel
    final_pos = wrappos(final_pos, facility_size)
    # Tracking the facility is for debug display only
    facility[CartesianIndex(Tuple(final_pos))] += 1
    if sum(final_pos .== quadrant_bounds) > 0
      continue
    end
    quadrant = div.(final_pos, quadrant_bounds)
    quadrants[CartesianIndex(Tuple(quadrant+[1,1]))] += 1
  end
  safety_factor = 1
  for quadrant in quadrants
    safety_factor *= quadrant
  end
  # Only print anomalous entries
  if safety_factor < anomaly_threshold
    printfacility(facility)
  end
  return safety_factor
end

println("Safety factor: $(simtotime(max_sim_time))")

##########
# Part 2 #
##########

#using Plots
using Statistics

safety_factors = map(simtotime, 1:10000)
tree_time = argmin(safety_factors)
# Setting anomaly_threshold to Inf makes it always print
#simtotime(tree_time, Inf)
println("Tree at: $(tree_time)")

# I did some work to look at how the safety factor changes over time and noticed
# some anomalous entries. I manually iterated all of the anomalous entries for a
# while, but it was taking too long. So I just guessed it was less than 10k
# seconds and would be the absolute lowest safety factor, and that happened to
# be right.
# I manually iterated over all anomalous entries and verified that the tree is
# the lowest safety factor. This automated solution gets it.
#
#plot(safety_factors, show=true)
#anomaly_threshold = mean(safety_factors) - 3*std(safety_factors)
