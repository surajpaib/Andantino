include("board_functions.jl")
include("game_moves.jl")
include("evaluation_functions.jl")
include("transposition_tables.jl")


# Minimax Search
function minimax_search(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64)
    push!(played_moves, position)
    push!(player_positions, player)
    opponent = get_opponent(player)

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player)
        n_eval = n_eval + 1
        pop!(played_moves)
        pop!(player_positions)
        return score, n_eval, played_moves
    end

    if maximizing_player
        score = -99999.0
        node_moves = possible_moves(board, played_moves)
        for child in node_moves
            value, n_eval, played_moves = minimax_search(main_player, opponent, child, depth - 1, false, played_moves, player_positions, board, n_eval)
            if (value > score)
                score = value
            end
      
        end
    else
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
        for child in node_moves
            value, n_eval, played_moves = minimax_search(main_player, opponent, child, depth - 1, true, played_moves, player_positions, board, n_eval)
            if (value < score)
                score = value
            end
        end

    end
99999.0
    pop!(played_moves)
    pop!(player_positions)
    return score, n_eval, played_moves
end

# Negamax Alpha-Beta Search
function negamax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64)
    push!(played_moves, position)
    push!(player_positions, player)
    opponent = get_opponent(player)

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player, player)
        if main_player != player
            score = -score
        end
        n_eval = n_eval + 1
        pop!(played_moves)
        pop!(player_positions)

        return score, n_eval, played_moves
    end

    score = -99999.0

    node_moves = possible_moves(board, played_moves)
    for child in node_moves

        value, n_eval, played_moves = negamax_search_alpha_beta(main_player, opponent, child, depth - 1, false, -beta, -alpha, played_moves, player_positions, board, n_eval)
        value = -value
        if (value > score)
            score = value
        end

        if (score > alpha)
            alpha = score

        end

        if ( alpha >= beta)
            break
        end

    
    end
    

    pop!(played_moves)
    pop!(player_positions)

    return score, n_eval, played_moves
end



# Regular Alpha-Beta Search
function minimax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64)
    push!(played_moves, position)
    push!(player_positions, player)
    opponent = get_opponent(player)

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player, player)
        n_eval = n_eval + 1
        pop!(played_moves)
        pop!(player_positions)

        return score, n_eval, played_moves
    end

    if maximizing_player
        score = -99999.0
        node_moves = possible_moves(board, played_moves)
        for child in node_moves

            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, false, alpha, beta, played_moves, player_positions, board, n_eval)
            if (value > score)
                score = value
            end

            if (score > alpha)
                alpha = score

            end

            if ( alpha >= beta)
                break
            end

      
        end
    else
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
        for child in node_moves

            
            
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, beta, played_moves, player_positions, board, n_eval)
            if (value < score)
                score = value
            end

            if (beta < score)
                beta = score
            end

            if ( alpha >= beta )

                break
            end
        end

    end

    pop!(played_moves)
    pop!(player_positions)

    return score, n_eval, played_moves
end



# Alpha Beta Search with Principal Variation Search
function minimax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64, pvs_moves)
    push!(played_moves, position)
    push!(player_positions, player)
    pvs_moves = pvs_moves[2:end]

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player)
        n_eval = n_eval + 1

        pop!(played_moves)
        pop!(player_positions)

        return score, n_eval, played_moves
    end

    if maximizing_player
        score = -99999.0
        node_moves = possible_moves(board, played_moves)
        if size(pvs_moves)[1] > 0
            if pvs_moves[1] in node_moves
                value, n_eval, played_moves = minimax_search_alpha_beta(main_player, player, child, depth - 1, false, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
                if (value > score)
                    score = value
                end
    
                if (score > alpha)
                    alpha = score
    
                end
                filter!(x -> x==pvs_moves[1], node_moves)
            end
        end

        for child in node_moves

            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, player, child, depth - 1, false, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
            if (value > score)
                score = value
            end

            if (score > alpha)
                alpha = score

            end

            if ( alpha >= beta)
                break
            end

      
        end
    else
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
         
        opponent = get_opponent(player)

        if size(pvs_moves)[1] > 0

            if pvs_moves[1] in node_moves
                value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
                if (value < score)
                    score = value
                end
    
                if (beta < score)
                    beta = score
                end
                filter!(x-> x==pvs_moves[1], node_moves)
            end

        end    

        for child in node_moves
            
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
            if (value < score)
                score = value
            end

            if (beta < score)
                beta = score
            end

            if ( alpha >= beta )
                break
            end
        end

    end

    pop!(played_moves)
    pop!(player_positions)

    return score, n_eval, played_moves
end


# Alpha Beta Search with TT
function minimax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64, hash)
    alphaOriginal = deepcopy(alpha)
    push!(played_moves, position)
    push!(player_positions, player)
    opponent = get_opponent(player)

    if player == 22
        hash = xor(hash, ZobristTable[1][position[1]][position[2]])
    else
        hash = xor(hash, ZobristTable[2][position[1]][position[2]])
    end

    entry = transpositionTableLookup(hash)

    if length(entry) > 0 && entry["depth"] >= depth
        if entry["flag"] == "EXACT"
            return entry["value"], n_eval, played_moves
        elseif entry["flag"] == "LB"
            alpha = max(alpha, entry["value"])
        elseif entry["flag"] == "UB"
            beta = min(beta, entry["value"])
        end

        if alpha >= beta
            return entry["value"], n_eval, played_moves
        end
    end

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player)
        n_eval = n_eval + 1

        pop!(played_moves)
        pop!(player_positions)

        return score, n_eval, played_moves
    end

    if maximizing_player
        score = -99999.0
        node_moves = possible_moves(board, played_moves)


        # Sorting Nodes Before Expanding the tree
        # sort!(node_moves, by= x -> evaluation_function(board, played_moves, x, player_positions, opponent, main_player), rev=true)

        for child in node_moves
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, false, alpha, beta, played_moves, player_positions, board, n_eval, hash)
            if (value > score)
                score = value
            end

            if (score > alpha)
                alpha = score

            end

            if ( alpha >= beta)
                break
            end

      
        end
    else
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
         

        # Sorting Nodes Before Expanding the tree

        # sort!(node_moves, by= x -> evaluation_function(board, played_moves, x, player_positions, opponent, main_player))

        for child in node_moves
            
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, beta, played_moves, player_positions, board, n_eval, hash)
            if (value < score)
                score = value
            end

            if (beta < score)
                beta = score
            end

            if ( alpha >= beta )
                break
            end
        end

    end

    entry["value"] = score
    if score <= alphaOriginal
        entry["flag"] = "UB"
    elseif score >= beta
        entry["flag"] = "LB"
    else
        entry["flag"] = "EXACT"
    end
    entry["depth"] = depth

    transpositionTableStore(hash, entry)
    pop!(played_moves)
    pop!(player_positions)

    return score, n_eval, played_moves
end



# Alpha Beta Search with Principal Variation Search and TT
function minimax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64, pvs_moves, hash)
    alphaOriginal = deepcopy(alpha)
    push!(played_moves, position)
    push!(player_positions, player)

    if player == 22
        hash = xor(hash, ZobristTable[1][position[1]][position[2]])
    else
        hash = xor(hash, ZobristTable[2][position[1]][position[2]])
    end

    entry = transpositionTableLookup(hash)

    if length(entry) > 0 && entry["depth"] >= depth
        if entry["flag"] == "EXACT"
            return entry["value"], n_eval, played_moves
        elseif entry["flag"] == "UB"
            alpha = max(alpha, entry["value"])
        elseif entry["flag"] == "LB"
            beta = min(beta, entry["value"])
        end

        if alpha >= beta
            return entry["value"], n_eval, played_moves
        end
    end

    pvs_moves = pvs_moves[2:end]

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player)
        n_eval = n_eval + 1

        pop!(played_moves)
        pop!(player_positions)

        return score, n_eval, played_moves
    end

    if maximizing_player
        score = -99999.0
        node_moves = possible_moves(board, played_moves)
        if size(pvs_moves)[1] > 0
            if pvs_moves[1] in node_moves
                value, n_eval, played_moves = minimax_search_alpha_beta(main_player, player, child, depth - 1, false, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
                if (value > score)
                    score = value
                end
    
                if (score > alpha)
                    alpha = score
    
                end
                filter!(x -> x==pvs_moves[1], node_moves)
            end
        end

        for child in node_moves

            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, player, child, depth - 1, false, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
            if (value > score)
                score = value
            end

            if (score > alpha)
                alpha = score

            end

            if ( alpha >= beta)
                break
            end

      
        end
    else
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
         
        opponent = get_opponent(player)

        if size(pvs_moves)[1] > 0

            if pvs_moves[1] in node_moves
                value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
                if (value < score)
                    score = value
                end
    
                if (beta < score)
                    beta = score
                end
                filter!(x-> x==pvs_moves[1], node_moves)
            end

        end    

        for child in node_moves
            
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, beta, played_moves, player_positions, board, n_eval, pvs_moves)
            if (value < score)
                score = value
            end

            if (beta < score)
                beta = score
            end

            if ( alpha >= beta )
                break
            end
        end

    end



    entry["value"] = score
    if score <= alphaOriginal
        entry["flag"] = "UB"
    elseif score >= beta
        entry["flag"] = "LB"
    else
        entry["flag"] = "EXACT"
    end
    entry["depth"] = depth

    transpositionTableStore(hash, entry)
    
    pop!(played_moves)
    pop!(player_positions)



    return score, n_eval, played_moves
end
