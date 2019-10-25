include("game_moves.jl")
include("alpha_beta_search.jl")
include("iterative_deepening.jl")
import Base.Threads.@threads


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
    number_of_moves = size(moves_to_play)[1]
    total_bytes_alloc = 0

    total_time = Array{Float64}(undef, number_of_moves)
    move_scores = Array{Float64}(undef, number_of_moves)
    n_evaluations = Array{Int64}(undef, number_of_moves)


    @threads for i in 1:number_of_moves
        move = moves_to_play[i]
        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        n_eval = 0
        return_vals, id_time, bytes_alloc, _, _ = @timed minimax_search_alpha_beta(player, player, move, search_ply -1, false, alpha, beta, played_moves, move_values, andantino_board, n_eval)
        move_scores[i] = return_vals[1]
        n_evaluations[i] = return_vals[2]
        total_time[i] = id_time
      
    end
    
    # print("Moves: ", moves_to_play, ", Move Scores: ", move_scores)

    time_taken = sum(total_time)
    evaluations = sum(n_evaluations)
    push!(performance_table, [time_taken, total_bytes_alloc, evaluations, player])

    best_move = findmax(move_scores)[2]
    andantino_board[moves_to_play[best_move][1]][moves_to_play[best_move][2]] = player
    return moves_to_play[best_move]

end

 


function play_turn(player::Int64, search_ply::Int64)
    moves_to_play = possible_moves(andantino_board)
    number_of_moves = size(moves_to_play)[1]
    total_bytes_alloc = 0

    total_time = Array{Float64}(undef, number_of_moves)
    move_scores = Array{Float64}(undef, number_of_moves)
    n_evaluations = Array{Int64}(undef, number_of_moves)


    for i in 1:number_of_moves

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        n_eval = 0
        return_vals, id_time, bytes_alloc, _, _ = @timed minimax_search(main_player, player, move, search_ply -1, false,  played_moves, move_values, andantino_board, n_eval)
        move_scores[i] = return_vals[1]
        n_evaluations[i] = return_vals[2]
        total_time[i] = id_time

    end

    time_taken = sum(total_time)
    evaluations = sum(n_evaluations)
    push!(performance_table, [time_taken, total_bytes_alloc, evaluations, player])

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


