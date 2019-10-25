include("board_functions.jl")

function evaluation_function(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}}, player_positions::Array{Int64, 1}, player::Int64)
    eval_board = evaluate_board(board, played_moves, player_positions)
    opponent = get_opponent(player)
    score = evaluate_five_in_row(eval_board, player, played_moves, player_positions) - evaluate_five_in_row(eval_board, opponent, played_moves, player_positions)
    surrounding_score = evaluate_surrounding(eval_board, player, played_moves, player_positions) - evaluate_surrounding(eval_board, opponent, played_moves, player_positions)
    return 0.5*score + 0.5*surrounding_score
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


# function moore_tracing_algorithm()

function evaluate_five_in_row(board::Array{Array{Int64, 1}}, player::Int64, played_moves::Array{Array{Int64, 1}}, player_positions)
    occupied_hexagons = evaluate_board(board)
    factor = 1
    scores = []

    hexagon_groups = []
    for i in 1:size(occupied_hexagons)[1]


        # for (n, move) in enumerate(played_moves)
        #     if occupied_hexagons[i] == move
        #         factor = size(played_moves)[1] - n + 1
        #     else
        #         factor = 1
        #     end
        # end

        for index in 1:6
            if board[occupied_hexagons[i][1]][occupied_hexagons[i][2]] == player
                
                group = check_next_hexagons(occupied_hexagons[i], board, index, player, Array{Int64,1}[occupied_hexagons[i]])
                # sort!(group)
                push!(hexagon_groups, group)
            end
        end

    end

    unique!(hexagon_groups)
    max_size = maximum([size(group)[1] for group in hexagon_groups])
    # println("Max Size: ", max_size)
    filter!(x-> size(x)[1]==max_size, hexagon_groups)
    # println("Top Groups: ", hexagon_groups)

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
                    score = 1000
                else
                    score = size(moves)[1]
                end

            end

        end
        push!(final_score, exp(score))
    end

    


    # white_positions = []
    # black_positions = []
    # for hex in occupied_hexagons
    #     if board[hex[1]][hex[2]] == 11
    #       push!(black_positions, hex)
        
    #     elseif board[hex[1]][hex[2]] == 22
    #       push!(white_positions, hex)
    #     end
    #   end
      

    # body!(w, """<script>
    # var white_positions = eval('$white_positions'.replace('Any', ''));
    # var black_positions = eval('$black_positions'.replace('Any', ''));
    #                 (function printBtn() {
    #                 var container = document.createElement("div");

    #                 var undo_button = document.createElement("button");
    #                 undo_button.innerHTML = "UNDO";
                
    #                 undo_button.setAttribute('id', 'undo');
    #                 undo_button.setAttribute('onclick', 'Blink.msg("undo","white")');

    #                 container.style.margin = '15px 0';
    #                 container.appendChild(undo_button);

    #                 for (var j=1; j<20; j++){
    #                 var rowdiv = document.createElement("div");
    #                     if (j<=10){
    #                         for (var i = 1; i <= 10 + j - 1; i++) {
    #                     var btn = document.createElement("button");
    #                     btn.innerHTML = "&#x2B21;";
    #                     btn.setAttribute('class', 'hex-buttons');
                    
    #                     btn.setAttribute('id', String(j) + ',' + String(i));
    #                     btn.setAttribute('onclick', 'Blink.msg("white","'+ String(j) + ',' + String(i) + '")');
    #                     rowdiv.appendChild(btn);
    #                     }
    #                     }else{
    #                     for (var i = 1; i <= 29 - j; i++) {
    #                     var btn = document.createElement("button");
    #                     btn.innerHTML = "&#x2B21;";
    #                     btn.setAttribute('class', 'hex-buttons');

    #                     btn.setAttribute('id', String(j) + ',' + String(i));
    #                     btn.setAttribute('onclick', 'Blink.msg("white","'+ String(j) + ',' + String(i) + '")');
    #                     rowdiv.appendChild(btn);
    #                     }
    #                     }
                    
    #                     rowdiv.setAttribute('style', 'text-align:center');
    #                     container.appendChild(rowdiv);
    #                     document.body.appendChild(container);
    #                 }
                    
    #                 })();

    #                 white_positions.forEach(function(element) {
    #                     var added_piece = document.getElementById(String(element[0])+","+String(element[1]));
    #                     added_piece.innerHTML = "&#x2B22;";
    #                     added_piece.style.color = '#ffffff';
    #                     added_piece.removeAttribute('onclick');
    #                 });


    #             black_positions.forEach(function(element) {
    #                     var added_piece = document.getElementById(String(element[0])+","+String(element[1]));
    #                     added_piece.innerHTML = "&#x2B22;";
    #                     added_piece.style.color = '#000000';
    #                     added_piece.removeAttribute('onclick');
    #                 });
                    
                
    #         </script>""");
    # println("\n Maximum Score: ", maximum(scores))
    # readline()
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


