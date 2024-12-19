#!/usr/bin/env julia
"https://adventofcode.com/2024/day/4"
module Day04

function parseinput(input::String)::Vector{AbstractString}
  split(input, "\n")
end

function checkmatch(word1, word2)
  return word1 == word2 || word1 == reverse(word2)
end

function part1(input::String)::Int
  grid = parseinput(input)
  word = "XMAS"
  border = length(word)-1
  matches = 0

  for r in 1:length(grid)
    for c in 1:length(grid[r])
      right_word      = ""
      down_word       = ""
      diag_right_word = ""
      diag_left_word  = ""
      for i in 0:border
        if c <= length(grid) - border
          right_word *= grid[r][c+i]
        end
        if r <= length(grid) - border
          down_word *= grid[r+i][c]
        end
        if c <= length(grid) - border && r <= length(grid) - border
          diag_right_word *= grid[r+i][c+i]
        end
        if c > border && r <= length(grid) - border
          diag_left_word *= grid[r+i][c-i]
        end
      end
      matches += checkmatch(right_word, word) +
                 checkmatch(down_word, word) +
                 checkmatch(diag_right_word, word) +
                 checkmatch(diag_left_word, word)
    end
  end

  return matches
end

function part2(input::String)::Int
  grid = parseinput(input)
  word = "MAS"
  border = 1
  matches = 0

  for r in 2:length(grid)-border
    for c in 2:length(grid)-border
      word1 = ""
      word2 = ""
      for i in -1:1
        word1 *= grid[r+i][c+i]
        word2 *= grid[r+i][c-i]
      end
      matches += checkmatch(word1, word) * checkmatch(word2, word)
    end
  end

  return matches
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1: ", part1(getinput(4, testing)))
  println("Part 2: ", part2(getinput(4, testing)))
end

end # module Day04
