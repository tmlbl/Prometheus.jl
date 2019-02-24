struct Target
    job::String
    scrapeUrl::String
    up::Bool
end

struct Series
    name::String
    job::String
    instance::String
end

struct MatrixResultValue
    time::Int64
    value::String
end

struct MatrixResult
    metric::Dict{String,String}
    values::Array{MatrixResultValue}
end
