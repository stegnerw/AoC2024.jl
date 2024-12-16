#!/usr/bin/env julia
"https://adventofcode.com/2024/day/2"
module Day02

function parseinput(input::String)::Vector{Vector{Int}}
  return [parse.(Int, x) for x in split.(split(input, '\n'), ' ')]
end

function part1(input::String)::Int
  safe_lines = 0
  for line in parseinput(input)
    diffs = line[1:end-1] - line[2:end]
    # Count up positive, negative, zeros, and gaps larger than 3
    # This can certainly be done more efficiently but I'm getting tired and it
    # works
    zerCount = count(x->x==0, diffs)
    posCount = count(x->x>0, diffs)
    negCount = count(x->x<0, diffs)
    bigCount = count(x->x>3, broadcast(abs, diffs))
    # If they are all homogeneous positive or negative, posCount * negCount == 0
    safe_lines += (zerCount == 0) && (bigCount == 0) &&
                  (posCount * negCount == 0)
  end
  return safe_lines
end

##########
# Part 2 #
##########

function part2(input::String)::Int
  safeish_lines = 0
  for line in parseinput(input)
    for i in range(0, lastindex(line))
      # Too tired to think of a good name tbh
      line_copy = copy(line)
      if i > 0
        deleteat!(line_copy, i)
      end
      diffs = line_copy[1:end-1] - line_copy[2:end]
      zerCount = count(x->x==0, diffs)
      posCount = count(x->x>0, diffs)
      negCount = count(x->x<0, diffs)
      bigCount = count(x->x>3, broadcast(abs, diffs))
      if (zerCount == 0) && (bigCount == 0) && (posCount * negCount == 0)
        safeish_lines += 1
        break
      end
    end
  end
  return safeish_lines
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(2, testing)))
  println("Part 2:", part2(getinput(2, testing)))
end

end # module Day02
