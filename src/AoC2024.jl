module AoC2024

using Printf

days = 1:2
function getinput(day::Int, test::Bool=false)::String
  suffix = test ? "_test" : ""
  path = joinpath(@__DIR__, "..", "inputs", @sprintf("day%02d%s.txt", day, suffix))
  return readchomp(path)
end
export getinput

# Only include the days if this is the main file.
# This allows each day to be ran as a main file.
# TODO: Import and run each day
if abspath(PROGRAM_FILE) == @__FILE__
  for day in days
    include(joinpath(@__DIR__, @sprintf("Day%02d.jl", day)))
  end
end

end # module AoC2024
