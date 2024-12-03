#!/usr/bin/env julia

##########
# Part 1 #
##########

safe_lines = open(string(@__DIR__, "/input.txt")) do f
  local safe_lines = 0
  # Process each line at a time
  for ln in eachline(f)
    # Parse each line to an array of ints
    ln_array = [parse(Int, x) for x in split(ln)]
    diffs = ln_array[1:end-1] - ln_array[2:end]
    #println("Line: ", ln_array)
    #println("Diffs: ", diffs)
    # Count up positive, negative, zeros, and gaps larger than 3
    # This can certainly be done more efficiently but I'm getting tired and it
    # works
    zerCount = count(x->x==0, diffs)
    posCount = count(x->x>0, diffs)
    negCount = count(x->x<0, diffs)
    bigCount = count(x->x>3, broadcast(abs, diffs))
    # If they are all homogeneous positive or negative, posCount * negCount == 0
    safe_lines += (zerCount == 0) && (bigCount == 0) &&
                  (posCount * negCount == 0)
  end
  safe_lines
end

println("Safe reports: ", safe_lines)

##########
# Part 2 #
##########

safeish_lines = open(string(@__DIR__, "/input.txt")) do f
  local safeish_lines = 0
  # Process each line at a time
  for ln in eachline(f)
    # Parse each line to an array of ints
    ln_array = [parse(Int, x) for x in split(ln)]
    # Remove a unique element each time, starting with the whole list
    for i in range(0, lastindex(ln_array))
      # Too tired to think of a good name tbh
      bababooey = copy(ln_array)
      if i > 0
        deleteat!(bababooey, i)
      end

      diffs = bababooey[1:end-1] - bababooey[2:end]
      # Count up positive, negative, zeros, and gaps larger than 3
      # This can certainly be done more efficiently but I'm getting tired and
      # it works
      zerCount = count(x->x==0, diffs)
      posCount = count(x->x>0, diffs)
      negCount = count(x->x<0, diffs)
      bigCount = count(x->x>3, broadcast(abs, diffs))
      if (zerCount == 0) && (bigCount == 0) && (posCount * negCount == 0)
        safeish_lines += 1
        break
      end
    end
  end
  safeish_lines
end

println("Safe-ish reports: ", safeish_lines)

