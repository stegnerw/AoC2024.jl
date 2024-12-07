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
rejects = Vector{Pair{Int, Vector{Int}}}()

for equation in equations
  accepted = false
  ops = 2
  cfg = zeros(Int, length(equation.second)-1)
  for _ in 1:ops^length(cfg)
    val = equation.second[1]
    for i in 1:length(cfg)
      if cfg[i] == 0
        val += equation.second[i+1]
      else
        val *= equation.second[i+1]
      end
    end
    carry = true
    for i in 1:length(cfg)
      if carry
        cfg[i] += 1
        if cfg[i] > ops - 1
          cfg[i] = 0
        else
          carry = false
        end
      end
    end
    if val == equation.first
      global calibration_result += val
      accepted = true
      break
    end
  end
  if !accepted
    push!(rejects, equation)
  end
end

println("Calibration result: $(calibration_result)")

##########
# Part 2 #
##########

for (i, equation) in enumerate(rejects)
  #println("$(i) / $(length(rejects))")
  #@show equation
  ops = 3
  cfg = zeros(Int, length(equation.second)-1)
  for _ in 1:ops^length(cfg)
    #@show cfg
    val = equation.second[1]
    for i in 1:length(cfg)
      if cfg[i] == 0
        val += equation.second[i+1]
      elseif cfg[i] == 1
        val *= equation.second[i+1]
      else
        val = parse(Int, string(val) * string(equation.second[i+1]))
      end
    end
    carry = true
    for i in 1:length(cfg)
      if carry
        cfg[i] += 1
        if cfg[i] > ops - 1
          cfg[i] = 0
        else
          carry = false
        end
      end
    end
    if val == equation.first
      global calibration_result += val
      break
    end
  end
end

println("Total calibration result: $(calibration_result)")
