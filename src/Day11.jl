#!/usr/bin/env julia
"https://adventofcode.com/2024/day/11"
module Day11
using Memoization

function parseinput(input::String)::Vector{Int}
  return parse.(Int, split(input, ' '))
end

function nextstone(stone::Int)::Vector{Int}
  if stone == 0
    return [1]
  elseif ndigits(stone) % 2 == 0
    lhs_scale = 10^(ndigits(stone)>>1)
    lhs = div(stone, lhs_scale)
    rhs = stone - lhs*lhs_scale
    return [lhs, rhs]
  else
    return [stone * 2024]
  end
end

@memoize function howmanystones(stone::Int, age::Int)::Int
  if age == 0 return 1 end
  return sum([howmanystones(x, age-1) for x in nextstone(stone)])
end

function part1(input::String)::Int
  stones = parseinput(input)
  num_stones = 0
  for stone in stones
    num_stones += howmanystones(stone, 25)
  end
  return num_stones
end

function part2(input::String)::Int
  stones = parseinput(input)
  num_stones = 0
  for stone in stones
    num_stones += howmanystones(stone, 75)
  end
  return num_stones
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1: ", part1(getinput(11, testing)))
  println("Part 2: ", part2(getinput(11, testing)))
end

end # module Day11
