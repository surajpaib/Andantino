include("board_functions.jl")
include("game_moves.jl")
include("evaluation_functions.jl")
include("transposition_tables.jl")

function minimax_search(player::Int64, position::Array{Int64, 1}, depth::Int64, maximizing_player::Bool, played_moves::Array{Array{Int64,1},1}, board::Array{Array{Int64,1}, 1}, n_eval::Int64)
    push!(played_moves, position)

    if depth == 0
        # println("Played Moves at Terminal Node", played_moves)
        score = evaluation_function(board, played_moves)
        # println("Reached End Node!! Score: ", score)
        n_eval = n_eval + 1

        pop!(played_moves)
        return score, n_eval, played_moves
    end

    if maximizing_player
        score = -99999.0
        node_moves = possible_positions(board, played_moves)
        for child in node_moves
            # println("Children Moves for MAX: ", child)

            value, n_eval, played_moves = minimax_search(player, child, depth - 1, false, played_moves, board, n_eval)
            if (value > score)
                score = value
            end
      
        end
    else
        score = 99999.0
        node_moves = possible_positions(board, played_moves)
        for child in node_moves

            
            if player == 22
                opponent = 11
            else
                opponent = 22
            end
            # println("Children Moves for MIN: ", child)
            
            value, n_eval, played_moves = minimax_search(opponent, child, depth - 1, true, played_moves, board, n_eval)
            if (value < score)
                score = value
            end
        end

    end

    pop!(played_moves)
    return score, n_eval, played_moves
end



function ab_search(main_player::Int64, player::Int64, position::Array{Int64, 1}, depth::Int64, alpha::Float64, beta::Float64, maximizing_player::Bool, played_moves::Array{Array{Int64,1},1}, player_positions::Array{Int64,1}, board::Array{Array{Int64,1}, 1}, n_eval::Int64, pvs::Array{Array{Int64, 1}, 1})
    push!(played_moves, position)
    push!(player_positions, player)

    pvs = pvs[2:end]

    if player == 22
        opponent = 11
    else
        opponent = 22
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
        if size(pvs)[1] > 0
            if pvs[1] in node_moves
                value, n_eval, played_moves = ab_search(main_player, opponent, pvs[1], depth - 1, alpha, beta, false, played_moves, player_positions, board, n_eval, pvs)
                score = max(score, value) 
                alpha = max(alpha, score)
                filter!(x -> x==pvs[1], node_moves)
            end
        end
      
        for child in node_moves

            value, n_eval, played_moves = ab_search(main_player, opponent, child, depth - 1, alpha, beta, false, played_moves, player_positions, board, n_eval, pvs)
            score = max(score, value) 
            alpha = max(alpha, score)

            if (alpha >= beta)
            
                break
            end
        
        end

  
    else
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
        if size(pvs)[1] > 0

            if pvs[1] in node_moves
                value, n_eval, played_moves = ab_search(main_player, opponent, pvs[1], depth - 1, alpha, beta, true, played_moves, player_positions,  board, n_eval, pvs)
                score = min(score, value) 
                beta = min(beta, score)
                filter!(x-> x==pvs[1], node_moves)
            end

        end

        for child in node_moves

            value, n_eval, played_moves = ab_search(main_player, opponent, child, depth - 1, alpha, beta, true, played_moves, player_positions,  board, n_eval, pvs)
            score = min(score, value) 
            beta = min(beta, score)

            if ( alpha >= beta)
                break
            end
        end

    end

    pop!(played_moves)
    pop!(player_positions)
    return score, n_eval, played_moves
end



function ab_search(main_player::Int64, player::Int64, position::Array{Int64, 1}, depth::Int64, alpha::Float64, beta::Float64, maximizing_player::Bool, played_moves::Array{Array{Int64,1},1}, player_positions::Array{Int64,1}, board::Array{Array{Int64,1}, 1}, n_eval::Int64, hash::Int64)
    alphaOriginal = deepcopy(alpha)
    push!(played_moves, position)
    push!(player_positions, player)
    
    if player == 22
        node = xor(hash, ZobristTable[1][position[1]][position[2]])
        opponent = 11
    else
        node = xor(hash, ZobristTable[2][position[1]][position[2]])
        opponent = 22
    end

    if debug
    println("New Hash ", node, " @: ", position)
    end

    entry = transpositionTableLookup(node)
    if debug

    println("Lookup results: ", entry)
    end
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

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player)
        n_eval = n_eval + 1

        pop!(played_moves)
        pop!(player_positions)
        return score, n_eval, played_moves
    end

    if maximizing_player
        if debug
          println("MAX: ")
        end
        score = -99999.0
        node_moves = possible_moves(board, played_moves)
        if debug
            println("Children: ", node_moves)
        end
        for child in node_moves

            value, n_eval, played_moves = ab_search(main_player, opponent, child, depth - 1, alpha, beta, false, played_moves, player_positions, board, n_eval, node)
            score = max(score, value) 
            alpha = max(alpha, score)
            if debug
                println("@MAX Alpha: ", alpha, "Beta: ", beta)
            end

            if (alpha >= beta)
                if debug
                    println("\nCut-off at :", child)
                end
                break
            end
      
        end

        if debug
            println("Max Player Score: ", score)
        end

    else
        if debug
            println("\n\n MIN: ")
        end
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
        if debug
            println("Children: ", node_moves)
        end
        for child in node_moves    
            value, n_eval, played_moves = ab_search(main_player, opponent, child, depth - 1, alpha, beta, true, played_moves, player_positions,  board, n_eval, node)
            if (value < score)
                score = value
            end
       
            score = min(score, value) 
            beta = min(beta, score)
          
            if debug
                println("@MIN Alpha: ", alpha, ", Beta: ", beta)
            end
            if ( alpha >= beta)
                if debug
                    println("\nCut-off at :", child)
                end
                break
            end
        end

        if debug
            println("Min Player Score: ", score)
        end

    end

    pop!(played_moves)
    pop!(player_positions)

    entry["value"] = score
    if score <= alphaOriginal
        entry["flag"] = "UB"
    elseif score >= beta
        entry["flag"] = "LB"
    else
        entry["flag"] = "EXACT"
    end
    entry["depth"] = depth

    transpositionTableStore(node, entry)
    if debug
        println("Stored Node: ", entry, " @: ", node)
    end
    return score, n_eval, played_moves
end


function ab_search(main_player::Int64, player::Int64, position::Array{Int64, 1}, depth::Int64, alpha::Float64, beta::Float64, maximizing_player::Bool, played_moves::Array{Array{Int64,1},1}, player_positions::Array{Int64,1}, board::Array{Array{Int64,1}, 1}, n_eval::Int64)
    push!(played_moves, position)
    push!(player_positions, player)
     
    if player == 22
        opponent = 11
    else
        opponent = 22
    end

    if depth == 0
        score = evaluation_function(board, played_moves, player_positions, main_player)
        n_eval = n_eval + 1

        pop!(played_moves)
        pop!(player_positions)
        return score, n_eval, played_moves
    end

    if maximizing_player
        if debug
          println("MAX: ")
        end
        score = -99999.0
        node_moves = possible_moves(board, played_moves)
        if debug
            println("Children: ", node_moves)
        end
        for child in node_moves

            value, n_eval, played_moves = ab_search(main_player, opponent, child, depth - 1, alpha, beta, false, played_moves, player_positions, board, n_eval)
            score = max(score, value) 
            alpha = max(beta, score)
            if debug
                println("@MAX Alpha: ", alpha, "Beta: ", beta)
            end

            if (alpha >= beta)
                if debug
                    println("\nCut-off at :", child)
                end
                break
            end
      
        end

        if debug
            println("Max Player Score: ", score)
        end

    else
        if debug
            println("\n\n MIN: ")
        end
        score = 99999.0
        node_moves = possible_moves(board, played_moves)
        if debug
            println("Children: ", node_moves)
        end
        for child in node_moves

       
            
            value, n_eval, played_moves = ab_search(main_player, opponent, child, depth - 1, alpha, beta, true, played_moves, player_positions,  board, n_eval)
            if (value < score)
                score = value
            end
       
            score = min(score, value) 
            beta = min(beta, score)
          
            if debug
                println("@MIN Alpha: ", alpha, ", Beta: ", beta)
            end
            if ( alpha >= beta)
                if debug
                    println("\nCut-off at :", child)
                end
                break
            end
        end

        if debug
            println("Min Player Score: ", score)
        end

    end

    pop!(played_moves)
    pop!(player_positions)
    return score, n_eval, played_moves
end



function iterative_deeping(ply, player, moves_to_play, hash)
    println("Depth Searched: ", ply)
    move_scores = Float64[]
    n_evaluations = 0
    for move in moves_to_play
        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        score, n_evaluations, played_moves = ab_search(player, player, move, ply - 1, -99999.0, 99999.0, false, played_moves, move_values, andantino_board, n_evaluations, hash)
        push!(move_scores, score)
    end
    best_move = findmax(move_scores)[2]
    if debug
        println("Total Moves Checked :", n_evaluations * size(moves_to_play)[1])
    end
    
    move = moves_to_play[best_move] 
    return move
end


function iterative_deeping(ply, player, moves_to_play)
    println("Depth Searched: ", ply)
    move_scores = Float64[]
    pvs_moves = Array{Array{Int64, 1}, 1}[]
    n_evaluations = 0
    for move in moves_to_play

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        score, n_evaluations, played_moves = ab_search(player, player, move, ply - 1, -99999.0, 99999.0, false, played_moves, move_values, andantino_board, n_evaluations)
        push!(move_scores, score)
        push!(pvs_moves, played_moves)
    end
    best_move = findmax(move_scores)[2]
    pvs_move = pvs_moves[best_move]
    if debug
        println("Total Moves Checked :", n_evaluations * size(moves_to_play)[1])
    end
    
    move = moves_to_play[best_move] 
    return move, pvs_move
end


function iterative_deeping(ply, player, moves_to_play, pvs_move)
    println("Depth Searched: ", ply)
    move_scores = Float64[]
    pvs_moves = Array{Array{Int64, 1}, 1}[]
    n_evaluations = 0
    for move in moves_to_play

        played_moves = Array{Int64,1}[]
        move_values = Int64[]
        score, n_evaluations, played_moves = ab_search(player, player, move, ply - 1, -99999.0, 99999.0, false, played_moves, move_values, andantino_board, n_evaluations, pvs_move)
        push!(move_scores, score)
        push!(pvs_moves, played_moves)
    end
    best_move = findmax(move_scores)[2]
    pvs_move = pvs_moves[best_move]
    if debug
        println("Total Moves Checked :", n_evaluations * size(moves_to_play)[1])
    end
    move = moves_to_play[best_move] 
    return move, pvs_move
end