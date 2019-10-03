include("game_moves.jl")
include("alpha_beta_search.jl")

function play_turn(player::Int64)
    moves_to_play = possible_moves(andantino_board)
    move = moves_to_play[rand(1:end)]
    andantino_board[move[1]][move[2]] = player
    return move
end


function play_turn(player::Int64, move::Array{Int64, 1})
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


function play_turn(player::Int64, search_ply::Int64)
    moves_to_play = possible_moves(andantino_board)
    if debug
        println("All moves to play: ", moves_to_play)    
    end
    move_scores = Float64[]
    n_evaluations = 0
    for move in moves_to_play

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        score, n_evaluations, played_moves = ab_search(player, player, move, search_ply - 1, -99999.0, 99999.0, false, played_moves, move_values, andantino_board, n_evaluations)
        push!(move_scores, score)

    end
    best_move = findmax(move_scores)[2]
    if debug
        println("Total Moves Checked :", n_evaluations * size(moves_to_play)[1])
    end
    
    andantino_board[moves_to_play[best_move][1]][moves_to_play[best_move][2]] = player
    return moves_to_play[best_move]

end


function play_turn(player::Int64, max_search_ply::Int64, iterative_deeping_time::Int64)

    moves_to_play = possible_moves(andantino_board)

    if debug
        println("All moves to play: ", moves_to_play)    
    end

    total_time = 0
    pvs_move = Array{Int64, 1}[]
    move = Int64[]
    for ply in 1:max_search_ply
        if ply == 1
            return_vals, id_time, _, _, _ = @timed iterative_deeping(ply, player, moves_to_play)
        else
            return_vals, id_time, _, _, _ = @timed iterative_deeping(ply, player, moves_to_play, pvs_move)
        end
        move = return_vals[1]
        pvs_move = return_vals[2]
        total_time = total_time + id_time
        println("Searching at ply: ", ply, " took: ", id_time, " s")
        if total_time > iterative_deeping_time
            println("Total Search Time: ", total_time)
            break
        end
    end

    andantino_board[move[1]][move[2]] = player
    return move

end


