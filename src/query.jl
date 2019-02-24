struct Query
    metric::String
    labels::Array{Pair}
end

Query(m::String, l::Pair...) = Query(m, collect(l))

function Base.string(q::Query)
    return "$(q.metric)$(promlabelstr(q.labels...))"
end
