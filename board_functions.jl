# Independent FUnctions related to evaluating the board

function create_board()
    upper_board = Array{Int64,1}[[-1 for i in 1:(10+j)] for j in 0:9]
    lower_board =  Array{Int64,1}[[-1 for i in 1:(18-j)] for j in 0:8]
    andantino_board = [upper_board; lower_board]
    return andantino_board

end

function evaluate_board(board)
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


function player_check_board(board, player)
    occupied_hexagons = Array{Int64, 1}[]
    for row in board
        for hexagon in row
            if hexagon == player
                return true
            end
        end
    end
    return false
end


function get_player_positions(board, player)
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

function check_board_limits(x)
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


function prettyprintboard(board)
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
