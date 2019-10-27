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



#  Alpha-Beta Search with Minimax
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
        score = -Inf
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
        score = Inf
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




#Alpha Beta Search with Principal Continuation
function minimax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64, pvs_moves)
    if time() - current_time > max_time
        return -Inf, n_eval, played_moves
    end
    push!(played_moves, position)
    push!(player_positions, player)
    pvs_moves = pvs_moves[2:end]

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
function minimax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64, hash, ZobristTable)
    
    # Restrict Iterative Deepening to a particular time bound
    if check_timeout()
        return -Inf, n_eval, played_moves
    end


    a = deepcopy(alpha)
    b = deepcopy(beta)

    push!(played_moves, position)
    push!(player_positions, player)
    opponent = get_opponent(player)

    if player == 22
        hash = xor(hash, ZobristTable[2][position[1]][position[2]])
    else
        hash = xor(hash, ZobristTable[1][position[1]][position[2]])
    end

    entry = transpositionTableLookup(hash)

    if length(entry) > 0 && entry["depth"] >= depth && entry["player"] == player
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
        score = evaluation_function(board, played_moves, player_positions, main_player, player)
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
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, false, a, beta, played_moves, player_positions, board, n_eval, hash, ZobristTable)
            if (value > score)
                score = value
            end

            if (score > a)
                a = score

            end

            if ( a >= beta)
                break
            end

      
        end
    else

        score = 99999.0
        node_moves = possible_moves(board, played_moves)
         

        # Sorting Nodes Before Expanding the tree

        # sort!(node_moves, by= x -> evaluation_function(board, played_moves, x, player_positions, opponent, main_player))

        for child in node_moves
            
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, b, played_moves, player_positions, board, n_eval, hash, ZobristTable)
            if (value < score)
                score = value
            end

            if (b < score)
                b = score
            end

            if ( alpha >= b )
                break
            end
        end

    end



    entry["player"] = player
    entry["value"] = score
    if score <= a
        entry["flag"] = "UB"
    elseif score >= b
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



# Alpha Beta Search with Principal Continuation and TT
function minimax_search_alpha_beta(main_player, player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, alpha::Float64, beta::Float64, played_moves::Array{Array{Int64,1},1}, player_positions, board::Array{Array{Int64,1}, 1}, n_eval::Int64, hash, ZobristTable, pvs_moves)
    a = deepcopy(alpha)
    b = deepcopy(beta)

    push!(played_moves, position)
    push!(player_positions, player)
    pvs_moves = pvs_moves[2:end]
    opponent = get_opponent(player)

    if player == 22
        hash = xor(hash, ZobristTable[2][position[1]][position[2]])
    else
        hash = xor(hash, ZobristTable[1][position[1]][position[2]])
    end

    entry = transpositionTableLookup(hash)

    if length(entry) > 0 && entry["depth"] >= depth && entry["player"] == player
        println("Retrieve move  ", position, ", TT: ", entry, "Current Depth: ", depth)
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
        score = evaluation_function(board, played_moves, player_positions, main_player, player)
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

        if size(pvs_moves)[1] > 0
            if pvs_moves[1] in node_moves
                value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, false, a, beta, played_moves, player_positions, board, n_eval, hash, ZobristTable,  pvs_moves)
                if (value > score)
                    score = value
                end
    
                if (score > alpha)
                    a = score
    
                end
                filter!(x -> x==pvs_moves[1], node_moves)
            end
        end


        for child in node_moves
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, false, a, beta, played_moves, player_positions, board, n_eval, hash, ZobristTable, pvs_moves)
            if (value > score)
                score = value
            end

            if (score > a)
                a = score

            end

            if ( a >= beta)
                break
            end

      
        end
    else

        score = 99999.0
        node_moves = possible_moves(board, played_moves)
        if size(pvs_moves)[1] > 0
            if pvs_moves[1] in node_moves
                value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, b, played_moves, player_positions, board, n_eval, hash, ZobristTable, pvs_moves)
                if (value < score)
                    score = value
                end
    
                if (b < score)
                    b = score
                end
                filter!(x -> x==pvs_moves[1], node_moves)
            end
        end

        # Sorting Nodes Before Expanding the tree

        # sort!(node_moves, by= x -> evaluation_function(board, played_moves, x, player_positions, opponent, main_player))

        for child in node_moves
            
            value, n_eval, played_moves = minimax_search_alpha_beta(main_player, opponent, child, depth - 1, true, alpha, b, played_moves, player_positions, board, n_eval, hash, ZobristTable, pvs_moves)
            if (value < score)
                score = value
            end

            if (b < score)
                b = score
            end

            if ( alpha >= b )
                break
            end
        end

    end



    entry["player"] = player
    entry["value"] = score
    if score <= a
        entry["flag"] = "UB"
    elseif score >= b
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