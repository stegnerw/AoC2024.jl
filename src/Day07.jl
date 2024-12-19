#!/usr/bin/env julia
"https://adventofcode.com/2024/day/7"
module Day07

function parseinput(input::String)::Vector{Pair{Int, Vector{Int}}}
  input_lines = split(input, "\n")
  return [(parse(Int, split(line, ':')[1]) =>
          parse.(Int, split(line, ' ')[2:end])) for line in input_lines]
end

function evaluate(eq::Vector{Int}, ops::Vector{Int}, num_ops::Int)::Int
  result = eq[1]
  for (i, val) in enumerate(eq[2:end])
    if ops[i] == 0
      result += val
    elseif ops[i] == 1
      result *= val
    else
      result = parse(Int, string(result) * string(val))
    end
  end
  return result
end

function nextops(ops::Vector{Int}, num_ops::Int)
  for i in eachindex(ops)
    ops[i] += 1
    if ops[i] < num_ops
      break
    end
    ops[i] = 0
  end
end

function part1(input::String)::Int
  equations = parseinput(input)

  calibration_result = 0
  rejects = Vector{Pair{Int, Vector{Int}}}()

  for equation in equations
    num_ops = 2
    ops = zeros(Int, length(equation.second)-1)
    #@show equation
    for _ in 0:num_ops^length(ops)-1
      result = evaluate(equation.second, ops, num_ops)
      if result == equation.first
        calibration_result += result
        break
      end
      nextops(ops, num_ops)
    end
  end

  return calibration_result
end

##########
# Part 2 #
##########

function part2(input::String)::Int
  equations = parseinput(input)

  calibration_result = 0
  rejects = Vector{Pair{Int, Vector{Int}}}()

  for equation in equations
    num_ops = 3
    ops = zeros(Int, length(equation.second)-1)
    #@show equation
    for _ in 0:num_ops^length(ops)-1
      result = evaluate(equation.second, ops, num_ops)
      if result == equation.first
        calibration_result += result
        break
      end
      nextops(ops, num_ops)
    end
  end

  return calibration_result
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(7, testing)))
  println("Part 2:", part2(getinput(7, testing)))
end


end # module Day07
