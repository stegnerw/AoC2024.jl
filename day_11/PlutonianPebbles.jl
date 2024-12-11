#!/usr/bin/env julia

using Memoization

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  parse.(Int, split(split(read(f, String), '\n')[1], ' '))
end

##########
# Part 1 #
##########

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

# @memoize is OP! Took the runtime from infeasible to 1.4 seconds!
# TODO: Do some timing plotting on this function with and without memoization.
@memoize function howmanystoneplox(stone::Int, age::Int, age_limit::Int)::Int
  if age == age_limit return 1 end
  return sum([howmanystoneplox(x, age+1, age_limit) for x in nextstone(stone)])
end

stones = copy(input)
num_stones = 0

for stone in stones
  global num_stones += howmanystoneplox(stone, 0, 25)
end

println("Number of stones: $(num_stones)")

##########
# Part 2 #
##########

stones = copy(input)
num_stones = 0

for stone in stones
  global num_stones += howmanystoneplox(stone, 0, 75)
end

println("Number of stones: $(num_stones)")
