"""
Enum describing the default port of various Prometheus exporters.

    ExporterType(9100) # NodeExporter::ExporterType = 9100
    ExporterType("http://foo:9100/metrics") # NodeExporter::ExporterType = 9100
"""
@enum ExporterType begin
    PrometheusExporter = 9090

    # github.com/prometheus/prometheus/wiki/Default-port-allocations
    NodeExporter = 9100
    HAProxy      = 9101
    StatsD       = 9102
    Collectd     = 9103
    MySQLd       = 9104
    Mesos        = 9105
    CloudWatch   = 9106
    Consul       = 9107
end

function ExporterType(uri::String)::ExporterType
    return ExporterType(parse(Int64, HTTP.URI(uri).port))
end

function ExporterType(t::Target)::ExporterType
    return ExporterType(t.scrapeUrl)
end
