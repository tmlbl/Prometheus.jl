struct Query
    metric::String
    labels::Array{Pair}
end

Query(m::String, l::Pair...) = Query(m, collect(l))
Query(s::Symbol, l::Pair...) = Query(string(s), collect(l))

function Base.string(q::Query)
    return "$(q.metric)$(promlabelstr(q.labels...))"
end

function Base.show(io::IO, q::Query)
    print(io, "Query($(string(q)))")
end
