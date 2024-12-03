#!/usr/bin/env julia

##########
# Part 1 #
##########

raw_input = open(string(@__DIR__, "/input.txt")) do f
  read(f, String)
end

mul_reg = r"mul\([0-9]+,[0-9]+\)"
mul_strings = [m.match for m = eachmatch(mul_reg, raw_input)]

mul_sum = 0

for str in mul_strings
  substr = str[5:end-1]
  nums = [parse(Int, x) for x in split(substr, ",")]
  global mul_sum += nums[1] * nums[2]
end

println("muls sums: ", mul_sum)
