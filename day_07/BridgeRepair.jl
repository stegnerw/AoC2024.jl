#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

equations = [(parse(Int, split(line, ':')[1]) =>
              parse.(Int, split(line, ' ')[2:end])) for line in input]

##########
# Part 1 #
##########

calibration_result = 0

for equation in equations
  for cfg in 0:2^(length(equation.second)-1)-1
    val = equation.second[1]
    for i in 1:length(equation.second)-1
      if ((cfg >> (i - 1)) & 1) == 0
        val += equation.second[i+1]
      else
        val *= equation.second[i+1]
      end
    end
    if val == equation.first
      global calibration_result += val
      break
    end
  end
end

println("Calibration result: $(calibration_result)")

##########
# Part 2 #
##########
