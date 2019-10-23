include("board_functions.jl")

function evaluation_function(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}}, player_positions::Array{Int64, 1}, player::Int64)
    eval_board = evaluate_board(board, played_moves, player_positions)
    opponent = get_opponent(player)
    score = evaluate_five_in_row(eval_board, player, played_moves, player_positions)  -   evaluate_five_in_row(eval_board, opponent, played_moves, player_positions) - 1
    return score
end


function evaluation_function(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}}, move::Array{Int64, 1}, player_positions::Array{Int64, 1}, current_player::Int64, player::Int64)
    push!(played_moves, move)
    push!(player_positions, current_player)
    eval_board = evaluate_board(board, played_moves, player_positions)
    opponent = get_opponent(player)
    score = evaluate_five_in_row(eval_board, player, played_moves, player_positions) - evaluate_five_in_row(eval_board, opponent, played_moves, player_positions)
    return score
end


function conv_kernel_evaluation(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}}, player_positions::Array{Int64, 1}, player::Int64)
    eval_board = evaluate_board(board, played_moves, player_positions)
    opponent = get_opponent(player)
    score =  -evaluate_conv(eval_board, opponent, played_moves)
    return score
end


function evaluate_conv(board::Array{Array{Int64, 1}}, player::Int64)

end


function evaluate_five_in_row(board::Array{Array{Int64, 1}}, player::Int64, played_moves::Array{Array{Int64, 1}}, player_positions)
    occupied_hexagons = evaluate_board(board)
    factor = 1
    scores = []
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
                score = exp(check_next_hexagons(occupied_hexagons[i], board, index, 0, 0,  player)) * factor
                push!(scores, score)
            end
        end
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
    return maximum(scores)
end


function check_next_hexagons(last_hexagon::Array{Int64, 1}, board::Array{Array{Int64, 1}}, index::Int64, count, op_count, player)
    adjacent_hex = find_adjacent_hexagons(last_hexagon)



    if check_board_limits(adjacent_hex[index])
        if board[adjacent_hex[index][1]][adjacent_hex[index][2]] == player
            count = count + 1
            if count == 4
                return Inf
            end
            return check_next_hexagons(adjacent_hex[index], board, index, count, op_count, player)

        elseif board[adjacent_hex[index][1]][adjacent_hex[index][2]] == get_opponent(player)
            op_count = op_count + 1
            if op_count == 2
                return -Inf
            else
                return count
            end
        else
            return count
        end
    else
        return count
    end

end


