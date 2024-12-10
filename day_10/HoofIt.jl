#!/usr/bin/env julia

####################
# Input Processing #
####################

input = open(string(@__DIR__, "/input.txt")) do f
  parse.(Int, stack(eachline(f)))
end

##########
# Part 1 #
##########

# Offset to tile entity is facing
dirs = [CartesianIndex{2}(-1, 0), # up
        CartesianIndex{2}(0, 1),  # right
        CartesianIndex{2}(1, 0),  # down
        CartesianIndex{2}(0, -1)] # left

"""
Return a vector of all possible next positions from pos.
"""
function getnextmoves(pos::CartesianIndex{2})::Vector{CartesianIndex{2}}
  next_move_vec = Vector{CartesianIndex{2}}()
  elevation = input[pos]
  for dir in dirs
    next_move = pos + dir
    if checkbounds(Bool, input, next_move) && input[next_move] - elevation == 1
      push!(next_move_vec, next_move)
    end
  end
  return next_move_vec
end

"""
Walk the trailhead starting at pos and return a vector of peaks (value 9 spots)
it reaches. This can include redundant peaks for part 2.
"""
function walktrailhead(pos::CartesianIndex{2})::Vector{CartesianIndex{2}}
  if input[pos] == 9
    return [pos]
  end
  peaks = Vector{CartesianIndex{2}}()
  for next_move in getnextmoves(pos)
    for peak in walktrailhead(next_move)
      push!(peaks, peak)
    end
  end
  return peaks
end

scores = Vector{Int}()
trailheads = findall(x->x==0, input)
for trailhead in trailheads
  peaks = walktrailhead(trailhead)
  push!(scores, length(Set(peaks)))
end

#@show trailheads
#@show scores
println("Unique peak score: $(sum(scores))")

##########
# Part 2 #
##########

dup_scores = Vector{Int}()
for trailhead in trailheads
  peaks = walktrailhead(trailhead)
  push!(dup_scores, length(peaks))
end

println("Duplicate peak score: $(sum(dup_scores))")
