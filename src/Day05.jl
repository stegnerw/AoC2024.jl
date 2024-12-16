#!/usr/bin/env julia
"https://adventofcode.com/2024/day/5"
module Day05

function parseinput(input::String)::Tuple{Dict{Int,Set{Int}},
                                          Vector{Vector{Int}}}
  input = split(input, "\n")

  # Split into rules and prints
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
  return rules, prints
end

function sortvalidprints(
    rules::Dict{Int,Set{Int}},
    prints::Vector{Vector{Int}})::Tuple{Vector{Vector{Int}},Vector{Vector{Int}}}
  valid_prints = Vector{Vector{Int}}()
  invalid_prints = Vector{Vector{Int}}()
  for print in prints
    print_set = Set{Int}()
    print_valid = true
    for page in print
      if haskey(rules, page)
        for rule in rules[page]
          if in(rule, print_set)
            print_valid = false
            break
          end
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
  return valid_prints, invalid_prints
end

function part1(input::String)::Int
  rules, prints = parseinput(input)
  valid_prints, _ = sortvalidprints(rules, prints)
  middle_page_sum = 0
  for print in valid_prints
    middle_page_idx = ceil(Int, length(print)/2)
    middle_page_sum += print[middle_page_idx]
  end
  return middle_page_sum
end

function part2(input::String)::Int
  rules, prints = parseinput(input)
  _, invalid_prints = sortvalidprints(rules, prints)
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

  middle_page_sum = 0
  for print in invalid_prints
    middle_page_idx = ceil(Int, length(print)/2)
    middle_page_sum += print[middle_page_idx]
  end

  return middle_page_sum
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(5, testing)))
  println("Part 2:", part2(getinput(5, testing)))
end

end # module Day05
