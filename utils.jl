include("game_moves.jl")
include("alpha_beta_search.jl")
include("iterative_deepening.jl")

function play_turn(player::Int64)
    moves_to_play = possible_moves(andantino_board)
    move = moves_to_play[rand(1:end)]
    andantino_board[move[1]][move[2]] = player
    return move
end


function play_turn(player::Int64, move::Array{Int64, 1})
    moves_to_play = possible_moves(andantino_board)
    if move in moves_to_play
        andantino_board[move[1]][move[2]] = player
        return true
    else
        println("Invalid Move, Pick a different move: ", moves_to_play)
        return false
    end
end


function play_turn(player::Int64, search_ply::Int64, alpha, beta)
    moves_to_play = possible_moves(andantino_board)
    main_player = deepcopy(player)
    move_scores = Float64[]

    n_evaluations = 0
    total_time = 0.0
    total_bytes_alloc = 0

    for move in moves_to_play

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        return_vals, id_time, bytes_alloc, _, _ = @timed minimax_search_alpha_beta(main_player, player, move, search_ply -1, false, alpha, beta, played_moves, move_values, andantino_board, n_evaluations)
        score, n_evaluations, played_moves = return_vals[:]
        total_time = total_time + id_time
        push!(move_scores, score)
        total_bytes_alloc = total_bytes_alloc + bytes_alloc

    end
    push!(performance_table, [total_time, total_bytes_alloc, n_evaluations, player])

    best_move = findmax(move_scores)[2]
    andantino_board[moves_to_play[best_move][1]][moves_to_play[best_move][2]] = main_player
    return moves_to_play[best_move]

end


function play_turn(player::Int64, search_ply::Int64)
    moves_to_play = possible_moves(andantino_board)
    main_player = deepcopy(player)
    move_scores = Float64[]

    n_evaluations = 0
    total_time = 0.0
    total_bytes_alloc = 0

    for move in moves_to_play

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        return_vals, id_time, bytes_alloc, _, _ = @timed minimax_search(main_player, player, move, search_ply -1, false,  played_moves, move_values, andantino_board, n_evaluations)
        score, n_evaluations, played_moves = return_vals[:]
        total_time = total_time + id_time
        push!(move_scores, score)
        total_bytes_alloc = total_bytes_alloc + bytes_alloc

    end
    push!(performance_table, [total_time, total_bytes_alloc, n_evaluations, player])

    best_move = findmax(move_scores)[2]
    andantino_board[moves_to_play[best_move][1]][moves_to_play[best_move][2]] = main_player
    return moves_to_play[best_move]

end


function play_turn(player::Int64, max_search_ply::Int64, iterative_deeping_time::Int64, hash)

    moves_to_play = possible_moves(andantino_board)

    n_evaluations = 0
    total_time = 0.0
    total_bytes_alloc = 0

    pvs_move = Array{Int64, 1}[]
    move = Int64[]

    for ply in 1:max_search_ply
        println("Searching Ply: ", ply)
        if ply == 1 || ~(pvs)
            return_vals, id_time, bytes_alloc, _, _ = @timed iterative_deeping(ply, player, moves_to_play, hash)
            move = return_vals[1]
            n_evaluations = n_evaluations + return_vals[2]
        else
            return_vals, id_time, bytes_alloc, _, _ = @timed iterative_deeping(ply, player, moves_to_play, pvs_move, hash)
            move = return_vals[1]
            pvs_move = return_vals[2]
            n_evaluations = n_evaluations + return_vals[3]
        end
        total_time = total_time + id_time
        println("Total Time: ", total_time)

        total_bytes_alloc = total_bytes_alloc + bytes_alloc

        if total_time > iterative_deeping_time
            break
        end
    end
    push!(performance_table, [total_time, total_bytes_alloc, n_evaluations, player])


    andantino_board[move[1]][move[2]] = player
    return move

end


# function play_turn(player::Int64, max_search_ply::Int64, iterative_deeping_time::Int64, hash)
#     moves_to_play = possible_moves(andantino_board)

#     n_evaluations = 0
#     total_time = 0.0
#     total_bytes_alloc = 0


#     move = Int64[]
#     for ply in 1:max_search_ply
#         return_vals, id_time, bytes_alloc, _, _ = @timed iterative_deeping(ply, player, moves_to_play, hash)
#         total_time = total_time + id_time
#         move = return_vals[1]

#         n_evaluations = n_evaluations + return_vals[2]
#         total_bytes_alloc = total_bytes_alloc + bytes_alloc

#         if total_time > iterative_deeping_time
#             break
#         end
#     end
#     push!(performance_table, [total_time, total_bytes_alloc, n_evaluations, player])

#     andantino_board[move[1]][move[2]] = player
#     return move

# end


