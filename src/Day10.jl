#!/usr/bin/env julia
"https://adventofcode.com/2024/day/10"
module Day10

function parseinput(input::String)::Matrix{Int}
  return parse.(Int, stack(split(input, '\n')))
end

# Offset to tile entity is facing
dirs = [CartesianIndex{2}(-1, 0), # up
        CartesianIndex{2}(0, 1),  # right
        CartesianIndex{2}(1, 0),  # down
        CartesianIndex{2}(0, -1)] # left

"""
Return a vector of all possible next positions from pos.
"""
function getnextmoves(pos::CartesianIndex{2},
                      map::Matrix{Int})::Vector{CartesianIndex{2}}
  next_move_vec = Vector{CartesianIndex{2}}()
  elevation = map[pos]
  for dir in dirs
    next_move = pos + dir
    if checkbounds(Bool, map, next_move) && map[next_move] - elevation == 1
      push!(next_move_vec, next_move)
    end
  end
  return next_move_vec
end

"""
Walk the trailhead starting at pos and return a vector of peaks (value 9 spots)
it reaches. This can include redundant peaks for part 2.
"""
function walktrailhead(pos::CartesianIndex{2},
                       map::Matrix{Int})::Vector{CartesianIndex{2}}
  if map[pos] == 9
    return [pos]
  end
  peaks = Vector{CartesianIndex{2}}()
  for next_move in getnextmoves(pos, map)
    for peak in walktrailhead(next_move, map)
      push!(peaks, peak)
    end
  end
  return peaks
end

function part1(input::String)::Int
  map = parseinput(input)
  scores = Vector{Int}()
  trailheads = findall(x->x==0, map)
  for trailhead in trailheads
    peaks = walktrailhead(trailhead, map)
    push!(scores, length(Set(peaks)))
  end
  return sum(scores)
end

function part2(input::String)::Int
  map = parseinput(input)
  scores = Vector{Int}()
  trailheads = findall(x->x==0, map)
  for trailhead in trailheads
    peaks = walktrailhead(trailhead, map)
    push!(scores, length(peaks))
  end
  return sum(scores)
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1: ", part1(getinput(10, testing)))
  println("Part 2: ", part2(getinput(10, testing)))
end

end # module Day10
