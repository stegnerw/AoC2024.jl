#!/usr/bin/env julia
"https://adventofcode.com/2024/day/14"
module Day14
using Statistics

struct Robot
  pos::Vector{Int}
  vel::Vector{Int}
end

function parseline(l::AbstractString)
  pos = parse.(Int, match(r"p=(-?\d+),(-?\d+)", l).captures)
  vel = parse.(Int, match(r"v=(-?\d+),(-?\d+)", l).captures)
  return Robot(pos, vel)
end

function parseinput(input::String)::Vector{Robot}
  return map(parseline, split(input, "\n"))
end

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


function simtotime(time::Int, robots::Vector{Robot},
                   facility_size::Vector{Int},
                   anomaly_threshold::Float64=0.0)::Int
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

function part1(input::String, testing::Bool=false)::Int
  if testing
    facility_size = [11, 7]
  else
    facility_size = [101, 103]
  end
  robots = parseinput(input)
  return simtotime(100, robots, facility_size)
end

function part2(input::String, testing::Bool=false)::Int
  if testing
    facility_size = [11, 7]
  else
    facility_size = [101, 103]
  end
  robots = parseinput(input)
  safety_factors = map(t->simtotime(t, robots, facility_size), 1:10000)
  tree_time = argmin(safety_factors)
  #simtotime(tree_time, robots, facility_size, Inf)
  return tree_time
end

#using Plots

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

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1: ", part1(getinput(14, testing), testing))
  println("Part 2: ", part2(getinput(14, testing), testing))
end

end # module Day14
