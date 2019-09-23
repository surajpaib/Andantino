include("game_moves.jl")
include("alpha_beta_search.jl")

function play_random_turn(player)
    moves_to_play = possible_moves(andantino_board)
    move = moves_to_play[rand(1:end)]
    andantino_board[move[1]][move[2]] = player
    return move
end


function play_turn(player, move)
    moves_to_play = possible_moves(andantino_board)
    if move in moves_to_play
        #println(move)
        andantino_board[move[1]][move[2]] = player
        return true
    else
        println("Invalid Move, Pick a different move: ", moves_to_play)
        return false
    end
end


function play_turn_search(player, search_ply)
    searched_moves = Array{Int64,1}[]
    moves_to_play = possible_moves(andantino_board)
    # println("All moves to play: ", moves_to_play)    
    move_scores = Float64[]
    n_evaluations = 0
    for move in moves_to_play

        # if move in searched_moves
        #     println("Skip Move", move)
        #     continue
        # end

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        push!(searched_moves, move)
        score, n_evaluations, played_moves = ab_search(player, move, search_ply, -99999.0, 99999.0, true, played_moves, andantino_board, n_evaluations)
        println("Played Moves: ", played_moves)
        push!(move_scores, score)

    end
    best_move = findmax(move_scores)[2]
    println("Total Moves Checked :", n_evaluations)
    andantino_board[moves_to_play[best_move][1]][moves_to_play[best_move][2]] = player

    return moves_to_play[best_move]

end
