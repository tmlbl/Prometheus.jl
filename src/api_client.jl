PROM_BASE_URL = "http://localhost:9090"

function get(path::String)::Dict{String,Any}
    r = HTTP.request("GET", PROM_BASE_URL * path)
    return JSON.parse(String(r.body))
end

"""
Returns the list of all labels in use.

GET /api/v1/labels
"""
function labels()::Vector{String}
    return get("/api/v1/labels")["data"]
end

"""
Returns the list of values in use for the particular label.

GET /api/v1/label/<label_value>/values
"""
function label_values(label::String)::Vector{String}
    return get("/api/v1/label/$label/values")["data"]
end

"""
Returns a list of series matching the given selector

GET /api/v1/series
"""
function series(labels::Pair...)::Vector{Series}
    path = "/api/v1/series?match[]=" * promlabelstr(labels...)
    data = get(path)["data"]
    s = Vector{Series}()
    for d in data
        push!(s, Series(d["__name__"], d["job"], d["instance"]))
    end
    return s
end

"""
Returns a list of Targets containing information about Prometheus scrape targets 

GET /api/v1/targets
"""
function targets()::Vector{Target}
    data = get("/api/v1/targets")["data"]
    targets = Vector{Target}()
    for t in data["activeTargets"]
        job = t["labels"]["job"]
        target = Target(job, t["scrapeUrl"], t["health"] == "up")
        push!(targets, target)
    end
    return targets
end

"""
Execute a Prometheus query over a time range

GET /api/v1/query_range


    query = Query(:node_cpu_seconds_total, :job => "node_exporter")
    result = Prometheus.range(query, Dates.now(UTC) - Hour(12))
"""
function range(query::String, start_t::DateTime, end_t::DateTime, step::String)::Array{MatrixResult}
    qs = qstring("query" => query, "start" => start_t, "end" => end_t, "step" => step)
    path = "/api/v1/query_range" * "?" * qs
    result = get(path)["data"]["result"]
    ret = Vector{MatrixResult}()
    for r in result
        # Convert to a TimeArray
        meta = r["metric"]
        n = length(r["values"])
        timestamps = Vector{DateTime}(undef, n)
        values = Vector{String}(undef, n)
        colnames = Vector{Symbol}()
        push!(colnames, Symbol(meta["__name__"]))

        for i = 1:n
            v = r["values"][i]
            timestamps[i] = unix2datetime(v[1])
            values[i] = v[2]
        end

        ta = TimeArray(timestamps, values, colnames, meta)
        push!(ret, MatrixResult(meta, ta))
    end
    return ret
end

range(q::Query, s::DateTime, e::DateTime, step::String) = range(string(q), s, e, step)
range(q::Query, t::DateTime, s::String) = range(q, t, Dates.now(UTC), s)
range(q::Query, t::DateTime) = range(q, t, "1m")
