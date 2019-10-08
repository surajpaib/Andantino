TT = Dict()

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


function transpositionTableLookup(node)
    if haskey(TT, node)
        return TT[node]
    else
        return Dict() 
    end
end


function transpositionTableStore(node, entry)
    TT[node] = entry   
end



