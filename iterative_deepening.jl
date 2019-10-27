import Base.Threads.@threads


# Iterative Deepening with Transposition Tables
function iterative_deeping(ply, player, moves_to_play, hash::Int64, ZobristTable)
    println("Iterative Deeping at PLY: ", ply)
    number_of_moves = size(moves_to_play)[1]
    move_scores = Array{Float64}(undef, number_of_moves)
    n_evaluations =  Array{Int64}(undef, number_of_moves)

    
    for i in 1:number_of_moves
    
        move = moves_to_play[i]
        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        n_eval = 0
        score, n_eval, played_moves = minimax_search_alpha_beta(player, player, move, ply -1, false, -Inf, Inf,  played_moves, move_values, andantino_board, n_eval, hash, ZobristTable) 
        move_scores[i] = score
        n_evaluations[i] = n_eval
    end
    
    evaluations = sum(n_evaluations)
    best_move = findmax(move_scores)[2]
    move = moves_to_play[best_move] 
    return move, evaluations, number_of_moves
end




# Iterative Deepening with Transposition Tables and Principal Continuation
function iterative_deeping(ply, player, moves_to_play, pvs_move, hash::Int64, ZobristTable)
    println("Iterative Deeping at PLY: ", ply)
    number_of_moves = size(moves_to_play)[1]
    move_scores = Array{Float64}(undef, number_of_moves)
    n_evaluations =  Array{Int64}(undef, number_of_moves)
    pvs_moves = Array{Array{Int64, 1}}[]

    for i in 1:number_of_moves
        move = moves_to_play[i]
        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        n_eval = 0
        score, n_eval, played_moves = minimax_search_alpha_beta(player, player, move, ply -1, false, -Inf, Inf,  played_moves, move_values, andantino_board, n_eval, hash, ZobristTable, pvs_move)
        move_scores[i] = score
        push!(pvs_moves, played_moves)
        n_evaluations[i] = n_eval
    end
    
    evaluations = sum(n_evaluations)
    best_move = findmax(move_scores)[2]
    move = moves_to_play[best_move] 
    pvs_move = pvs_moves[best_move]
    return move, pvs_move, evaluations, number_of_moves
end



# Regular Iterative Deepening
function iterative_deeping(ply, player, moves_to_play)
    number_of_moves = size(moves_to_play)[1]
    move_scores = Array{Float64}(undef, number_of_moves)
    n_evaluations =  Array{Int64}(undef, number_of_moves)

    pvs_moves = Array{Array{Int64, 1}, 1}(number_of_moves)

    for i in 1:number_of_moves

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        n_eval = 0
        score, n_eval, played_moves = minimax_search_alpha_beta(player, player, move, ply -1, false, -Inf, Inf,  played_moves, move_values, andantino_board, n_eval)
        move_scores[i] = score
        n_evaluations[i] = n_eval
        pvs_moves[i] = played_moves

    end
    evaluations = sum(n_evaluations)
    best_move = findmax(move_scores)[2]
    pvs_move = pvs_moves[best_move]
    move = moves_to_play[best_move] 
    return move, pvs_move, evaluations, number_of_moves
end


# Iterative Deepening with Principal Continuation 
function iterative_deeping(ply, player, moves_to_play, pvs_move)
    move_scores = Float64[]
    pvs_moves = Array{Array{Int64, 1}, 1}[]
    n_evaluations = 0
    for move in moves_to_play

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        score, n_evaluations, played_moves = minimax_search_alpha_beta(player, player, move, ply -1, false, -Inf, Inf,  played_moves, move_values, andantino_board, n_evaluations, pvs_moves)
        push!(move_scores, score)
        push!(pvs_moves, played_moves)
    end
    best_move = findmax(move_scores)[2]
    pvs_move = pvs_moves[best_move]
    move = moves_to_play[best_move] 
    return move, pvs_move, n_evaluations, number_of_moves
end