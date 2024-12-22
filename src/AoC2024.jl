#!/usr/bin/env julia
module AoC2024

using ArgParse
using Logging
using Printf

const days = 1:15
const parts = 1:2
function parse_commandline(args::Vector{String}=ARGS)::Dict{String,Any}
  s = ArgParseSettings()
  @add_arg_table! s begin
    "--days", "-d"
      help = "The day to run"
      arg_type = Int
      nargs = '+'
      default = collect(days)
      range_tester = (x->x in days)
    "--test", "-t"
      help = "Run with the small test inputs"
      action = :store_true
    "--benchmark", "-b"
      help = "Benchmark the selected tests"
      action = :store_true
  end
  return parse_args(args, s)
end

function getinput(day::Int, test::Bool=false)::String
  suffix = test ? "_test" : ""
  path = joinpath(@__DIR__, "..", "inputs",
                  @sprintf("day%02d%s.txt", day, suffix))
  return readchomp(path)
end
export getinput

function getmodulesymbol(day::Int)::Symbol
  return Symbol(@sprintf("Day%02d", day))
end

function getfunctionsymbol(part::Int)::Symbol
  return Symbol("part$part")
end

function runday(day::Int, input::String)
  mod_sym = getmodulesymbol(day)
  part1_sym = getfunctionsymbol(1)
  part1 = @eval AoC2024.$mod_sym.$part1_sym($input)
  part2_sym = getfunctionsymbol(2)
  part2 = @eval AoC2024.$mod_sym.$part2_sym($input)
  @info "Day $(day)" part1 part2
end

function benchmarkday(day::Int, input::String)
end

function (@main)(args::Vector{String})
  parsed_args = parse_commandline(args)
  if parsed_args["benchmark"]
    # Print benchmark header
    println("| Day | Time | Memory |")
  end
  for day in parsed_args["days"]
    module_path = joinpath(@__DIR__, @sprintf("Day%02d.jl", day))
    if !ispath(module_path)
      continue
    end
    include(module_path)
    input = getinput(day, parsed_args["test"])
    if parsed_args["benchmark"]
      benchmarkday(day, input)
    else
      runday(day, input)
    end
  end
end
export main

end # module AoC2024
using .AoC2024
