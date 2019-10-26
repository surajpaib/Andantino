include("board_functions.jl")
include("win_conditions.jl")

function evaluation_function(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}}, player_positions::Array{Int64, 1}, player::Int64, current_player::Int64)
    if current_player == player
        if check_first_move(board, played_moves[1], player_positions[1])
            return Inf
        end
    end
    eval_board = evaluate_board(board, played_moves, player_positions)
    opponent = get_opponent(player)
    score = evaluate_five_in_row(eval_board, player, played_moves, player_positions) - evaluate_five_in_row(eval_board, opponent, played_moves, player_positions) 
    surrounding_score = evaluate_surrounding(eval_board, player, played_moves, player_positions) - evaluate_surrounding(eval_board, opponent, played_moves, player_positions) 
    return 0.5*score + 0.5*surrounding_score
end


function check_first_move(board, played_moves, player_positions)
    eval_board = evaluate_board(board, [played_moves],[player_positions])
    return check_five_in_a_row(played_moves, eval_board)
end

function evaluation_function(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}}, move::Array{Int64, 1}, player_positions::Array{Int64, 1}, current_player::Int64, player::Int64)
    push!(played_moves, move)
    push!(player_positions, current_player)
    eval_board = evaluate_board(board, played_moves, player_positions)
    opponent = get_opponent(player)
    score = evaluate_five_in_row(eval_board, player, played_moves, player_positions) - evaluate_five_in_row(eval_board, opponent, played_moves, player_positions)
    return score
end

function evaluate_surrounding(board::Array{Array{Int64, 1}}, player::Int64, played_moves::Array{Array{Int64, 1}}, player_positions)
    opponent = get_opponent(player)
    board_flood_fill = deepcopy(board)
    flood_fill_algorithm([1, 1], board_flood_fill, opponent)
    if check_flood_fill_edge_case(board_flood_fill, opponent)
        return Inf
    else
        return 0
    end
end


function evaluate_five_in_row(board::Array{Array{Int64, 1}}, player::Int64, played_moves::Array{Array{Int64, 1}}, player_positions)
    occupied_hexagons = evaluate_board(board)
    factor = 1
    scores = []

    hexagon_groups = []
    for i in 1:size(occupied_hexagons)[1]
        for index in 1:6
            if board[occupied_hexagons[i][1]][occupied_hexagons[i][2]] == player
                
                group = check_next_hexagons(occupied_hexagons[i], board, index, player, Array{Int64,1}[occupied_hexagons[i]])
                push!(hexagon_groups, group)
            end
        end

    end

    unique!(hexagon_groups)
    max_size = maximum([size(group)[1] for group in hexagon_groups])
    filter!(x-> size(x)[1]==max_size, hexagon_groups)

    final_score = []
    for moves in hexagon_groups
        score = 0.0
        op_count = 0
        start_element = moves[1]
        end_element = moves[end]

        if size(moves)[1] > 1
            direction_element = moves[2]
            adjacent_hex = find_adjacent_hexagons(start_element)
            index = findall(x->x==direction_element, adjacent_hex)[1]
            if (adjacent_hex[map_move[index]] == get_opponent(player)) && ~(adjacent_hex[map_move[index]] in played_moves)
                op_count = op_count + 1
            end

            adjacent_hex_end = find_adjacent_hexagons(end_element)
            if (adjacent_hex_end[index] == get_opponent(player)) && ~(adjacent_hex_end[index] in played_moves)
                op_count = op_count + 1
            end

            if op_count == 2
                continue
            else
                if size(moves)[1] == 5
                    score = Inf
                else
                    score = size(moves)[1]
                end

            end

        end
        push!(final_score, exp(score))
    end

    return maximum(final_score)
end


function check_next_hexagons(last_hexagon::Array{Int64, 1}, board::Array{Array{Int64, 1}}, index::Int64, player, group::Array{Array{Int64,1}})
    adjacent_hex = find_adjacent_hexagons(last_hexagon)

    if check_board_limits(adjacent_hex[index])
        if board[adjacent_hex[index][1]][adjacent_hex[index][2]] == player
            push!(group, adjacent_hex[index])
            return check_next_hexagons(adjacent_hex[index], board, index, player, group)
        else
            return group
        end
    else
        return group
    end
end


