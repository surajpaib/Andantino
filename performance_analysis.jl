using DataFrames
using CSV


function create_performance_table()
    performance_table = DataFrame(Time = [], BytesAllocated = [], Evaluations = [], Player = [])
    return performance_table
end
