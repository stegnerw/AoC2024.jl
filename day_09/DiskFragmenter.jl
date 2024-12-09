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


function getFileId(idx::Int)::Union{Nothing,Int}
  # File ID is zero-indexed but Julia is one-indexed
  if (idx-1) % 2 == 1
    return nothing
  else
    return div(idx, 2)
  end
end

slot = 0
checksum = 0

function placeFile(fileId::Int)
  global checksum, slot
  #@show slot, fileId
  checksum += slot * fileId
  slot += 1
end

front_idx = firstindex(input)
back_idx = lastindex(input)

while front_idx < back_idx
  global front_idx, back_idx, checksum, slot
  fileId = getFileId(front_idx)
  for i in 1:input[front_idx]
    placeFile(fileId)
  end
  input[front_idx] = 0
  fileId = getFileId(back_idx)
  for i in 1:input[front_idx+1]
    if input[back_idx] == 0
      back_idx -= 2
      fileId = getFileId(back_idx)
      if front_idx == back_idx
        break
      end
    end
    placeFile(fileId)
    input[back_idx] -= 1
  end
  front_idx += 2
end
# Place the remainder from the back
for i in 1:input[back_idx]
  placeFile(getFileId(back_idx))
end

println("Checksum: $(checksum)")

##########
# Part 2 #
##########
