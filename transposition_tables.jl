include("utils.jl")
include("board_functions.jl")


function initTable()
    RandomValues = rand(Int64, 542)
    upper_board = Array{Int64,1}[[-1 for i in 1:(10+j)] for j in 0:9]
    lower_board =  Array{Int64,1}[[-1 for i in 1:(18-j)] for j in 0:8]
    game_board = [upper_board; lower_board]

    ZobristTable = [game_board, game_board]

    count = 1
    for (i, table) in enumerate(ZobristTable)
        for (j, row) in enumerate(table)
            for (k, hex) in enumerate(row)
                ZobristTable[i][j][k] = RandomValues[count]
                count = count + 1
            end
        end
    end

    # for 
    return ZobristTable
end



function computeHash(ZobristTable, andantino_board)
    h = 0
    for (i, row) in enumerate(andantino_board)
        for (j, hex) in enumerate(row)
            if andantino_board[i][j] == 22
                h=xor(ZobristTable[2][i][j], h)
                
            elseif andantino_board[i][j] == 11
                h=xor(ZobristTable[1][i][j], h)

            end
        end
    end
    return h
end


# TT = Dict<Int64, Any>()




andantino_board = create_board()
ZobristTable = initTable()
original_board = deepcopy(andantino_board)

# println(ZobristTable)


play_turn(11, [10, 10])

play_turn(22, [9, 10])
play_turn(11, [10, 11])

hash = computeHash(ZobristTable, andantino_board)

println("Hash For [10, 10], [9, 10], [10, 9]: ", hash)


andantino_board = deepcopy(original_board)
play_turn(11, [10, 10])
play_turn(22, [10, 11])
play_turn(11, [9, 10])
println("Hash For [10, 10], [10, 9], [9, 10]: ", hash)

