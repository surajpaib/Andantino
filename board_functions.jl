# Independent FUnctions related to evaluating the board

map_move = Dict(
    1 => 2,
    3 => 4,
    5 => 6,
    2 => 1,
    4 => 3,
    6 => 5 
)


function create_board()
    upper_board = Array{Int64,1}[[-1 for i in 1:(10+j)] for j in 0:9]
    lower_board =  Array{Int64,1}[[-1 for i in 1:(18-j)] for j in 0:8]
    andantino_board = [upper_board; lower_board]
    return andantino_board

end


# Return a list of occupied hexagons from the board 
function evaluate_board(board::Array{Array{Int64, 1}})
    occupied_hexagons = Array{Int64, 1}[]
    for (i, row) in enumerate(board)
        for (j, hexagon) in enumerate(row)
            if hexagon != -1
                push!(occupied_hexagons, Int64[i, j])
            end
        end
    end
    return occupied_hexagons
end

# Return a copy of the board with the updated moves 
function evaluate_board(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}}, player_positions::Array{Int64, 1})
    board_copy = deepcopy(board)

    for (i, move) in enumerate(played_moves)
        board_copy[move[1]][move[2]] = player_positions[i]
    end

    return board_copy
end

# Flood fill edge cases for enclosing around the boundaries
function check_flood_fill_edge_case(board::Array{Array{Int64, 1}}, player::Int64)
    for (i, row) in enumerate(board)
        for (j, hexagon) in enumerate(row)
            if hexagon == player
                flood_fill_algorithm([i,1], board, player)
                flood_fill_algorithm([1,j], board, player)

            end
        end
    end
    return evaluate_board(board, player)
end

# Check if player exists on the board
function evaluate_board(board::Array{Array{Int64, 1}}, player::Int64)
    for row in board
        for hexagon in row
            if hexagon == player
                return true
            end
        end
    end
    return false
end

# Get opponent value 
function get_opponent(player::Int64)
    if player == 22
        return 11
    elseif player == 11
        return 22
    end
end


# Get all the occupied positions of a particular player
function get_player_positions(board::Array{Array{Int64, 1}}, player::Int64)
    occupied_hexagons = Array{Int64, 1}[]
    for (i, row) in enumerate(board)
        for (j, hexagon) in enumerate(row)
            if ((hexagon != -1) && (hexagon == player))
                push!(occupied_hexagons, Int64[i, j])
            end
        end
    end
    return occupied_hexagons
end

# Check if the move is within the board limits
function check_board_limits(x::Array{Int64, 1})
    if ((x[1] > 0) && ( x[2] > 0))
        if ((x[1] < 11) && (x[2] < x[1] + 10))
            return true
        elseif ((x[1] > 10 ) && (x[1] < 20) && (x[2] < 10 - x[1] + 20))
            return true

        else 
            return false
        end

    else
        return false
            

    end
end

# Command line formatted board printing
function prettyprintboard(board::Array{Array{Int64, 1}})
    sizes = [size(row) for row in board]
    max_width = maximum(sizes)[1] + 1
    for row in board
        spaces = max_width - size(row)[1]
        
        p_out = "    " ^ floor(Int, spaces/2)
        if spaces % 2 != 0
            p_out = string(p_out, "    ")
        end
        for value in row
            p_out=string(p_out, string(value), "  ")
        end
        p_out=string(p_out, "    " ^ floor(Int, spaces/2))
        if spaces % 2 != 0
            p_out = string(p_out, "    ")
        end
        p_out = string(p_out, "\n")
        println(p_out)
    end
end