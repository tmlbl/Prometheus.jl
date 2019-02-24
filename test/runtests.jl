using Prometheus

@assert (promlabelstr("job" => "prometheus") == "{job=\"prometheus\"}")
