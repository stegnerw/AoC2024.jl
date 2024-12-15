#!/usr/bin/env julia

using LinearAlgebra

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

##########
# Part 1 #
##########

const button_limit::Int = 100
const cost = [3, 1]

reg_buttons = r"X\+(\d+), Y\+(\d+)"
reg_prize = r"X=(\d+), Y=(\d+)"

total_cost = 0
for i in firstindex(input):4:lastindex(input)
  A = stack([parse.(Int,match(reg_buttons, l).captures) for l in input[i:i+1]])
  b = parse.(Int, match(reg_prize, input[i+2]).captures)

  u = round.(Int, A \ b)
  if count(x->x < 0, u) > 0
    continue
  end
  if (A*u == b)
    c = sum(cost .* u)
    global total_cost += c
  end
end

println("Total cost: $(total_cost)")

##########
# Part 2 #
##########

const p_offset = [10000000000000, 10000000000000]

adjusted_cost = 0
for i in firstindex(input):4:lastindex(input)
  A = stack([parse.(Int,match(reg_buttons, l).captures) for l in input[i:i+1]])
  b = parse.(Int, match(reg_prize, input[i+2]).captures) + p_offset

  u = round.(Int, A \ b)
  if count(x->x < 0, u) > 0
    continue
  end
  if (A*u == b)
    c = sum(cost .* u)
    global adjusted_cost += c
  end
end

println("Adjusted cost: $(adjusted_cost)")
