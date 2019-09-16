include("board_functions.jl")

using Combinatorics




function find_adjacent_hexagons(hexagon)
    if hexagon[1] <= 9
        adjacent_positions = [[hexagon[1] - 1, hexagon[2] - 1], [hexagon[1] - 1, hexagon[2]], [hexagon[1], hexagon[2] - 1], [hexagon[1], hexagon[2] + 1], [hexagon[1] + 1, hexagon[2]], [hexagon[1] + 1, hexagon[2] + 1]]
    elseif hexagon[1] == 10
        adjacent_positions = [[hexagon[1] - 1, hexagon[2] - 1], [hexagon[1] - 1, hexagon[2]], [hexagon[1], hexagon[2] - 1], [hexagon[1], hexagon[2] + 1], [hexagon[1] + 1, hexagon[2] - 1], [hexagon[1] + 1, hexagon[2]]]
    else
        adjacent_positions = [[hexagon[1] - 1, hexagon[2]], [hexagon[1] - 1, hexagon[2] + 1], [hexagon[1], hexagon[2] - 1], [hexagon[1], hexagon[2] + 1], [hexagon[1] + 1, hexagon[2] - 1], [hexagon[1] + 1, hexagon[2]]]
    end

    # filter!(x->check_board_limits(x), adjacent_positions)

    # println("Adjacent Positions remaining: ", adjacent_positions)
    return adjacent_positions
end


function possible_moves(board)
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

