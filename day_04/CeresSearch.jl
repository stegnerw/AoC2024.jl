#!/usr/bin/env julia

####################
# Input Processing #
####################

#140 X 140 search space
input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

##########
# Part 1 #
##########

function checkmatch(word1, word2)
  return word1 == word2 || word1 == reverse(word2)
end

word = "XMAS"
border = length(word)-1
matches = 0

for r in 1:length(input)
  for c in 1:length(input[r])
    right_word      = ""
    down_word       = ""
    diag_right_word = ""
    diag_left_word  = ""
    for i in 0:border
      if c <= length(input) - border
        right_word *= input[r][c+i]
      end
      if r <= length(input) - border
        down_word *= input[r+i][c]
      end
      if c <= length(input) - border && r <= length(input) - border
        diag_right_word *= input[r+i][c+i]
      end
      if c > border && r <= length(input) - border
        diag_left_word *= input[r+i][c-i]
      end
    end
    global matches += checkmatch(right_word, word) +
                      checkmatch(down_word, word) +
                      checkmatch(diag_right_word, word) +
                      checkmatch(diag_left_word, word)
  end
end

println("Matches: $(matches)")

##########
# Part 2 #
##########
