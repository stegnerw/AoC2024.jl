#!/usr/bin/env julia
"https://adventofcode.com/2024/day/3"
module Day03

global mul_reg = r"mul\([0-9]+,[0-9]+\)"

function part1(input::String)::Int
  mul_strings = [m.match for m = eachmatch(mul_reg, input)]
  mul_sum = 0
  for str in mul_strings
    substr = str[5:end-1]
    nums = [parse(Int, x) for x in split(substr, ",")]
    mul_sum += nums[1] * nums[2]
  end
  return mul_sum
end

function part2(input::String)::Int
  while true
    dont_idx = findfirst("don't()", input)
    if isnothing(dont_idx)
      break
    end
    # Have to search after the first don't() command
    do_idx = findfirst("do()", input[dont_idx[end]+1:end])
    chop_start = dont_idx[1]-1
    # Index relative to the don't() command
    chop_end = do_idx[end]+1 + dont_idx[end]
    input = input[1:chop_start] * input[chop_end:end]
  end
  return part1(input)
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(3, testing)))
  println("Part 2:", part2(getinput(3, testing)))
end

end # module Day03
