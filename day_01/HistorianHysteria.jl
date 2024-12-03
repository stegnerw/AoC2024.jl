#!/usr/bin/env julia
using DelimitedFiles

# Read delimited file
raw_input = readdlm("./input.txt", ' ', Int, '\n')

# Nice built-in sort function
list1 = sort(raw_input[:,1])
list2 = sort(raw_input[:,2])

# You can operate on lists as vectors
diff = list1 - list2

# Execute a func over a list with broadcast
abs_diff = broadcast(abs, diff)

# Sum them up
diff_sum = sum(abs_diff)
print("Total difference: ", diff_sum)
