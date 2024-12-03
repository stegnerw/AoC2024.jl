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

##########
# Part 2 #
##########

# This doesn't work because regex is greedy and prunes too much
#dont_do_reg = r"don't\(\).*do\(\)"
#dont_do_strings = [m.match for m = eachmatch(dont_do_reg, raw_input)]
#println(dont_do_strings)
#filtered_input = replace(raw_input, dont_do_reg => "")

filtered_input = raw_input
while true
  global filtered_input
  dont_idx = findfirst("don't()", filtered_input)
  if isnothing(dont_idx)
    break
  end
  # Have to search after the first don't() command
  do_idx = findfirst("do()", filtered_input[dont_idx[end]+1:end])
  chop_start = dont_idx[1]-1
  # Index relative to the don't() command
  chop_end = do_idx[end]+1 + dont_idx[end]
  filtered_input = filtered_input[1:chop_start] * filtered_input[chop_end:end]
end

mul_strings = [m.match for m = eachmatch(mul_reg, filtered_input)]

mul_sum = 0

for str in mul_strings
  substr = str[5:end-1]
  nums = [parse(Int, x) for x in split(substr, ",")]
  global mul_sum += nums[1] * nums[2]
end

println("filtered muls sums: ", mul_sum)
