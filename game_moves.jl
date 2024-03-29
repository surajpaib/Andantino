include("board_functions.jl")

using Combinatorics



# Return a list of hexagons adjacent to a particular hexagon
function find_adjacent_hexagons(hexagon::Array{Int64, 1})
    if hexagon[1] <= 9
        adjacent_positions = [[hexagon[1] - 1, hexagon[2] - 1], [hexagon[1] - 1, hexagon[2]], [hexagon[1], hexagon[2] - 1], [hexagon[1], hexagon[2] + 1], [hexagon[1] + 1, hexagon[2]], [hexagon[1] + 1, hexagon[2] + 1]]
    elseif hexagon[1] == 10
        adjacent_positions = [[hexagon[1] - 1, hexagon[2] - 1], [hexagon[1] - 1, hexagon[2]], [hexagon[1], hexagon[2] - 1], [hexagon[1], hexagon[2] + 1], [hexagon[1] + 1, hexagon[2] - 1], [hexagon[1] + 1, hexagon[2]]]
    else
        adjacent_positions = [[hexagon[1] - 1, hexagon[2]], [hexagon[1] - 1, hexagon[2] + 1], [hexagon[1], hexagon[2] - 1], [hexagon[1], hexagon[2] + 1], [hexagon[1] + 1, hexagon[2] - 1], [hexagon[1] + 1, hexagon[2]]]
    end

    return adjacent_positions
end


# Return a list of all possible moves/legal moves that are playable on the board
function possible_moves(board::Array{Array{Int64, 1}})
    occupied_hexagons = evaluate_board(board)

    if (size(occupied_hexagons)[1]) == 0
        return Array{Int64,1}[Int64[10, 10]]
    elseif (size(occupied_hexagons)[1]) == 1
        return find_adjacent_hexagons(occupied_hexagons[1])
    else
        possible_combinations = collect(combinations(occupied_hexagons, 2))

        moves_possible = Array{Int64,1}[]
        for hexagon_duo in possible_combinations
            possible_positions1 = find_adjacent_hexagons(hexagon_duo[1])
            possible_positions2 = find_adjacent_hexagons(hexagon_duo[2])
            intersected_positions = intersect(possible_positions1, possible_positions2)
            for moves in intersected_positions
                push!(moves_possible, moves)
            end
        end


        for moves in occupied_hexagons
            filter!(x->x!=moves, moves_possible)
        end
        
        filter!(x->check_board_limits(x), moves_possible)
        return moves_possible
    end
end


# Return a list of possible moves given a board and some incremental moves played on this board
function possible_moves(board::Array{Array{Int64, 1}}, played_moves::Array{Array{Int64, 1}})
    occupied_hexagons = evaluate_board(board)


    for move in played_moves
        if ~(move in occupied_hexagons)
            push!(occupied_hexagons, move)
        end
    end

    if (size(occupied_hexagons)[1]) == 0
        return Array{Int64,1}[Int64[10, 10]]
    elseif (size(occupied_hexagons)[1]) == 1

        return find_adjacent_hexagons(occupied_hexagons[1])
    else
        possible_combinations = collect(combinations(occupied_hexagons, 2))
        moves_possible = Array{Int64,1}[]
        for hexagon_duo in possible_combinations
            possible_positions1 = find_adjacent_hexagons(hexagon_duo[1])
            possible_positions2 = find_adjacent_hexagons(hexagon_duo[2])
            intersected_positions = intersect(possible_positions1, possible_positions2)
            for moves in intersected_positions
                if ~(moves in moves_possible) && check_board_limits(moves) && ~(moves in occupied_hexagons)
                    push!(moves_possible, moves)
                end
            end
        end

        return moves_possible
    end
end

