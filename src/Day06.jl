#!/usr/bin/env julia
"https://adventofcode.com/2024/day/6"
module Day06

function parseinput(input::String)::Matrix{Char}
  return stack(split(input, "\n"))
end

const dirs = [CartesianIndex(0,-1), # North
              CartesianIndex(1,0),  # East
              CartesianIndex(0,1),  # South
              CartesianIndex(-1,0)] # West

function getinitpos(lab::Matrix{Char})::CartesianIndex{2}
  return findfirst(x->x=='^', lab)
end

function printlab(lab::Matrix{Char}, visited::Matrix{Bool})
  for (i,c) in enumerate(eachcol(lab))
    for (j,r) in enumerate(c)
      if r == '#' || r == '^'
        print(r)
      else
        print(visited[j,i] ? '+' : ' ')
      end
    end
    println()
  end
end

function getturndir(d::Int)::Int
  return (d % 4) + 1
end

function facingedge(p::CartesianIndex{2}, d::Int, l::Matrix{Char})::Bool
  facing = p + dirs[d]
  return facing[1] == 0 || facing[1] == size(l)[1]+1 ||
         facing[2] == 0 || facing[2] == size(l)[2]+1
end

function facingobby(p::CartesianIndex{2}, d::Int, l::Matrix{Char})::Bool
  facing = p + dirs[d]
  return !facingedge(p, d, l) && l[facing] == '#'
end

function move(p::CartesianIndex{2}, d::Int,
              lab::Matrix{Char})::Tuple{CartesianIndex{2}, Int}
  if facingobby(p, d, lab)
    # turn right until can walk forward
    while facingobby(p, d, lab)
      d = getturndir(d)
    end
  else
    # Walk forward
    p += dirs[d]
  end
  return p, d
end

function walklab(l::Matrix{Char}, p::CartesianIndex{2}, v::Matrix{Bool})
  d = 1
  v[p] = true
  while !facingedge(p, d, l)
    p, d = move(p, d, l)
    v[p] = true
  end
end

function part1(input::String)::Int
  lab = parseinput(input)
  pos = getinitpos(lab)
  visited = zeros(Bool, size(lab))
  walklab(lab, pos, visited)
  #printlab(lab, visited)
  return sum(visited)
end

function part2(input::String)::Int
  lab = parseinput(input)
  init_pos = getinitpos(lab)
  visited = zeros(Bool, size(lab))
  walklab(lab, deepcopy(init_pos), visited)
  loops = 0
  for test_idx in findall(x->x==true, visited)
    # Skip starting position
    if lab[test_idx] == '^' continue end
    # Only going to mark visited tiles when facing an obstacle
    # This helps with loop detection since we can cross the same place twice
    visited_loop = zeros(Bool, size(lab))
    pos = deepcopy(init_pos)
    dir = 1
    looped = false
    lab[test_idx] = '#'
    while !facingedge(pos, dir, lab) && !looped
      pos, dir = move(pos, dir, lab)
      facing = pos + dirs[dir]
      if facingobby(pos, dir, lab)
        if visited_loop[pos]
          loops += 1
          looped = true
        else facingobby(pos, dir, lab)
          visited_loop[pos] = true
        end
      end
    end
    lab[test_idx] = '.'
  end
  return loops
end

# Main
if abspath(PROGRAM_FILE) == @__FILE__
  include(joinpath(@__DIR__, "AoC2024.jl"))
  using .AoC2024
  testing = false
  println("Part 1: ", part1(getinput(6, testing)))
  println("Part 2: ", part2(getinput(6, testing)))
end


end # module Day06
