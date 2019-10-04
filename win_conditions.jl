include("board_functions.jl")
include("game_moves.jl")



# Check for 5 in a line hexagons for one win condition
function check_next_hexagons(last_hexagon::Array{Int64, 1}, board::Array{Array{Int64, 1}}, counter::Int64, index::Int64)
    adjacent_hex = find_adjacent_hexagons(last_hexagon)

    if check_board_limits(adjacent_hex[index])
        if board[adjacent_hex[index][1]][adjacent_hex[index][2]] == board[last_hexagon[1]][last_hexagon[2]]
            counter = counter + 1
            if counter == 5
                return true
            else
                return check_next_hexagons(adjacent_hex[index], board, counter, index)
            end
        else
            return false
        end
    else
        return false
    end

end



function check_five_in_a_row(last_hexagon::Array{Int64, 1}, board::Array{Array{Int64, 1}})
    adjacent_hex = find_adjacent_hexagons(last_hexagon)
    for i in 1:size(adjacent_hex)[1]
        if check_board_limits(adjacent_hex[i])
            if board[adjacent_hex[i][1]][adjacent_hex[i][2]] == board[last_hexagon[1]][last_hexagon[2]]
                if check_next_hexagons(adjacent_hex[i], board, 2, i)
                    return true
                    
                end  
            end
        end
    end 
    return false
end


# Check for Surrounded Hexagons of Opponent

function check_surround_piece(last_hexagon::Array{Int64, 1}, board::Array{Array{Int64, 1}})
    current_player = board[last_hexagon[1]][last_hexagon[2]]
    if current_player == 22
        opponent = 11
    else
        opponent = 22
    end

    board_flood_fill = deepcopy(board)
    flood_fill_algorithm([1, 1], board_flood_fill, opponent)
    return check_flood_fill_edge_case(board_flood_fill, opponent)
end



function flood_fill_algorithm(position::Array{Int64, 1}, board_flood_fill::Array{Array{Int64, 1}}, opponent::Int64)
    adjacent_hex = find_adjacent_hexagons(position)
    for hexagons in adjacent_hex
        if check_board_limits(hexagons)
            if (board_flood_fill[hexagons[1]][hexagons[2]] == opponent) || (board_flood_fill[hexagons[1]][hexagons[2]] == -1)
                board_flood_fill[hexagons[1]][hexagons[2]] = -10
                flood_fill_algorithm(hexagons, board_flood_fill, opponent)
            end  
        end
    end  
end

function check_game_end(last_hexagon::Array{Int64, 1}, board::Array{Array{Int64, 1}})
    return check_five_in_a_row(last_hexagon, board) || check_surround_piece(last_hexagon, board)

end