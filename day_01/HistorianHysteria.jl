#!/usr/bin/env julia
using DelimitedFiles

##############
# Input Prep #
##############

# Read delimited file
# Using @__DIR__ so it doesn't matter where cwd is
raw_input = readdlm(string(@__DIR__, "/input.txt"), ' ', Int, '\n')

# List slicing (1-indexed, bleh)
list1 = raw_input[:,1]
list2 = raw_input[:,2]

##########
# Part 1 #
##########

# Nice built-in sort function
list1_sorted = sort(list1)
list2_sorted = sort(list2)

# You can operate on lists as vectors
diff = list1_sorted - list2_sorted

# Execute a func over a list with broadcast
abs_diff = broadcast(abs, diff)

# Sum them up
diff_sum = sum(abs_diff)
println("Total difference: ", diff_sum)

##########
# Part 2 #
##########

similarity = 0

# I was going to pre-map how many times each number occurs but list1 is all
# unique values so it's easier to just iterate
# y->y==x is an anonymous function; count counts how many elements of list2
# evaluate to true in that function
for x in list1
  global similarity += x * count(y->y==x, list2)
end

println("Similarity: ", similarity)
