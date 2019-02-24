"""
Encode pairs into Prometheus query selectors

    promlabelstr("job" => "prometheus") # "{job="prometheus"}
"""
function promlabelstr(ps::Pair...)::String
    ss = Vector{String}()
    for (k, v) in Dict(ps)
        push!(ss, "$k=\"$v\"")
    end
    return "{$(join(ss, ','))}"
end

function unix2str(t::Number)::String
    return string(convert(BigInt, trunc(t)))
end

function paramstr(p::Any)::String
    t = typeof(p)
    if t <: DateTime
        return unix2str(datetime2unix(p))
    else
        return string(p)
    end
end

# Function for formatting parameters into a query string
function qstring(params::Dict{String,Any})::String
    pairs = Vector{String}()
    for (k, v) in params
        push!(pairs, URIs.escapeuri(k)*"="*URIs.escapeuri(paramstr(v)))
    end
    return join(pairs, "&")
end

qstring(ps::Pair...) = qstring(Dict{String,Any}(ps))
