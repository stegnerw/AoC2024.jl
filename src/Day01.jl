#!/usr/bin/env julia
"https://adventofcode.com/2024/day/1"
module Day01

function parseinput(input::String)::Tuple{Vector{Int}, Vector{Int}}
  lists = [parse.(Int, x) for x in split.(split(input, '\n'), "   ")]
  list1 = [x[1] for x in lists]
  list2 = [x[2] for x in lists]
  return list1, list2
end

function part1(input::String)::Int
  list1, list2 = parseinput(input)
  return sum(abs.(sort(list1) - sort(list2)))
end

function part2(input::String)::Int
  similarity = 0
  list1, list2 = parseinput(input)
  for x in list1
    similarity += x * count(y->y==x, list2)
  end
  return similarity
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1: ", part1(getinput(1, testing)))
  println("Part 2: ", part2(getinput(1, testing)))
end

end # module Day01
