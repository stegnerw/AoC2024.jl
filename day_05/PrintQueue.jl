#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  split(read(f, String), "\n")[1:end-1]
end

# Split input
split_point = findfirst(x->x=="", input)
rules_raw = input[1:split_point-1]
prints = [parse.(Int, split(print, ',')) for print in input[split_point+1:end]]

# Parse rules
rules = Dict{Int,Set{Int}}()
for rule in rules_raw
  first,second = parse.(Int, split(rule, '|'))
  if !haskey(rules, first)
    rules[first] = Set{Int}()
  end
  push!(rules[first], second)
end

##########
# Part 1 #
##########

valid_prints = Vector{Vector{Int}}()
invalid_prints = Vector{Vector{Int}}()
for print in prints
  print_set = Set{Int}()
  print_valid = true
  for page in print
    for rule in rules[page]
      if in(rule, print_set)
        print_valid = false
        break
      end
    end
    if !print_valid
      break
    end
    push!(print_set, page)
  end
  if print_valid
    push!(valid_prints, print)
  else
    push!(invalid_prints, print)
  end
end

valid_middle_page_sum = 0
for print in valid_prints
  # The round() function follows proper sig-fig rules
  # 8.5 rounds to 8, and 9.5 rounds to 10
  middle_page_idx = trunc(Int, ceil(length(print)/2))
  global valid_middle_page_sum += print[middle_page_idx]
end

println("Valid middle page sum: $(valid_middle_page_sum)")

##########
# Part 2 #
##########

for print in invalid_prints
  changed = true
  while changed
    changed = false
    for test_idx in reverse(1:length(print))
      test_page = print[test_idx]
      insert_idx = nothing
      if !haskey(rules, test_page)
        continue
      end
      for probe_idx in reverse(1:test_idx-1)
        if in(print[probe_idx], rules[test_page])
          insert_idx = probe_idx
        end
      end
      if !isnothing(insert_idx)
        deleteat!(print, test_idx)
        insert!(print, insert_idx, test_page)
        changed = true
      end
    end
  end
end

invalid_middle_page_sum = 0
for print in invalid_prints
  # The round() function follows proper sig-fig rules
  # 8.5 rounds to 8, and 9.5 rounds to 10
  middle_page_idx = trunc(Int, ceil(length(print)/2))
  global invalid_middle_page_sum += print[middle_page_idx]
end

println("Valid middle page sum: $(invalid_middle_page_sum)")

