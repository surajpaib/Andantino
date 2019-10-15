


function iterative_deeping(ply, player, moves_to_play, hash::Int64)
    println("Iterative Deeping at PLY: ", ply)
    move_scores = Float64[]
    n_evaluations = 0
    for move in moves_to_play
        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        score, n_evaluations, played_moves = minimax_search_alpha_beta(player, player, move, ply -1, false, -Inf, Inf,  played_moves, move_values, andantino_board, n_evaluations, hash)
        push!(move_scores, score)
    end
    best_move = findmax(move_scores)[2]
    move = moves_to_play[best_move] 
    return move, n_evaluations
end


function iterative_deeping(ply, player, moves_to_play)
    move_scores = Float64[]
    pvs_moves = Array{Array{Int64, 1}, 1}[]
    n_evaluations = 0
    for move in moves_to_play

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        score, n_evaluations, played_moves = minimax_search_alpha_beta(player, player, move, ply -1, false, -Inf, Inf,  played_moves, move_values, andantino_board, n_evaluations)
        push!(move_scores, score)
        push!(pvs_moves, played_moves)
    end
    best_move = findmax(move_scores)[2]
    pvs_move = pvs_moves[best_move]
    move = moves_to_play[best_move] 
    return move, pvs_move, n_evaluations
end

# Iterative Deepening with PVS 
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
    return move, pvs_move, n_evaluations
end