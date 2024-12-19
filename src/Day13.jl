#!/usr/bin/env julia
"https://adventofcode.com/2024/day/13"
module Day13
using LinearAlgebra

function parseinput(input::String)::Vector{Tuple{Matrix{Int}, Vector{Int}}}
  lines = split(input, "\n")
  machines = Vector{Tuple{Matrix{Int}, Vector{Int}}}()
  a_reg = r"X\+(\d+), Y\+(\d+)"
  b_reg = r"X=(\d+), Y=(\d+)"
  for i in firstindex(lines):4:lastindex(lines)
    A = stack([parse.(Int,match(a_reg, l).captures) for l in lines[i:i+1]])
    b = parse.(Int, match(b_reg, lines[i+2]).captures)
    push!(machines, (A, b))
  end
  return machines
end

const cost = [3, 1]

function solvemachine(A::Matrix{Int}, b::Vector{Int})::Int
  u = round.(Int, A\b)
  if count(x->x < 0, u) > 0
    return 0
  end
  if (A*u != b)
    return 0
  end
  return sum(cost .* u)
end

function part1(input::String)::Int
  cost = 0
  for (A, b) in parseinput(input)
    cost += solvemachine(A, b)
  end

  return cost
end

const p_offset = [10000000000000, 10000000000000]

function part2(input::String)::Int
  cost = 0
  for (A, b) in parseinput(input)
    cost += solvemachine(A, b+p_offset)
  end

  return cost
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(13, testing)))
  println("Part 2:", part2(getinput(13, testing)))
end

end # module Day13
