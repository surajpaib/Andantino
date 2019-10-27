module Andantino
include("andantino_game.jl")

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    play_game()
    return 0
end

end
