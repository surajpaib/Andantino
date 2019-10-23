include("andantino_game.jl")
Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    return play_game()
end
