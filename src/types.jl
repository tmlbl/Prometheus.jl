import Base.show

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

struct MatrixResult
    metric::Dict{String,String}
    values::TimeArray{String}
end

function Base.show(io::IO, r::MatrixResult)
    print(io, "MatrixResult($(r.metric["__name__"])$(promlabelstr(r.metric)), $(length(r.values)))")
end
