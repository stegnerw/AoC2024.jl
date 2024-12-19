#!/usr/bin/env julia
"https://adventofcode.com/2024/day/9"
module Day09

function parseinput(input::String)::Matrix{Int}
  parse.(Int, stack(split(input)))
end

function getfileid(idx::Int)::Union{Nothing,Int}
  # File ID is zero-indexed but Julia is one-indexed
  if (idx-1) % 2 == 1
    return nothing
  else
    return div(idx, 2)
  end
end

mutable struct FileEntry
  start_addr::Int
  file_size::Int
  file_id::Union{Nothing, Int}
end

function printblocks(blocks::Vector{FileEntry})
  for block in blocks
    for x in 1:block.file_size
      println(isnothing(block.file_id) ? '.' : block.file_id)
    end
  end
end

function getinitblocks(disk_map::Matrix{Int})::Vector{FileEntry}
  blocks = Vector{FileEntry}()
  addr = 0
  for (i, v) in enumerate(disk_map)
    push!(blocks, FileEntry(addr, v, getfileid(i)))
    addr += v
  end
  return blocks
end

function getchecksum(disk_map::Vector{FileEntry})::Int
  checksum = 0
  for block in disk_map
    if isnothing(block.file_id)
      continue
    end
    for i = 0:block.file_size-1
      checksum += block.file_id * (block.start_addr + i)
    end
  end
  return checksum
end

function part1(input::String)::Int
  disk_map = parseinput(input)
  blocks = getinitblocks(disk_map)
  #printblocks(blocks)
  while !isnothing(local empty_idx = findfirst(x->isnothing(x.file_id), blocks))
    empty_block = blocks[empty_idx]
    back_block = blocks[end]
    if isnothing(back_block.file_id)
      deleteat!(blocks, lastindex(blocks))
    else
      if back_block.file_size >= empty_block.file_size
        empty_block.file_id = back_block.file_id
        back_block.file_size -= empty_block.file_size
      else
        empty_block.file_size -= back_block.file_size
        insert!(blocks, empty_idx, FileEntry(empty_block.start_addr,
                                             back_block.file_size,
                                             back_block.file_id))
        empty_block.start_addr += back_block.file_size
        back_block.file_size = 0
      end
      if back_block.file_size == 0
        deleteat!(blocks, lastindex(blocks))
      end
    end
  end
  #printblocks(blocks)
  return getchecksum(blocks)
end

function part2(input::String)::Int
  disk_map = parseinput(input)
  blocks = getinitblocks(disk_map)
  for block_idx in reverse(eachindex(blocks))
    block = blocks[block_idx]
    if isnothing(block.file_id)
      continue
    end
    empty_idx = findfirst(x->isnothing(x.file_id) &&
                          x.file_size >= block.file_size &&
                          x.start_addr < block.start_addr, blocks)
    if isnothing(empty_idx)
      continue
    end
    empty_block = blocks[empty_idx]
    block.start_addr = empty_block.start_addr
    empty_block.start_addr += block.file_size
    empty_block.file_size -= block.file_size
  end
  #printblocks(blocks)
  return getchecksum(blocks)
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1:", part1(getinput(9, testing)))
  println("Part 2:", part2(getinput(9, testing)))
end

end # module Day09
