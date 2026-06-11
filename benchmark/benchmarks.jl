using BenchmarkTools
using Graphs
using IGraphs

const SUITE = BenchmarkGroup()

function benchmark_graph()
    graph = Graph(200)
    for vertex in 1:199
        add_edge!(graph, vertex, vertex + 1)
    end
    for vertex in 1:198
        add_edge!(graph, vertex, vertex + 2)
    end
    return graph
end

const SAMPLE_GRAPH = benchmark_graph()
const SAMPLE_IGRAPH = IGraph(SAMPLE_GRAPH)

SUITE["conversion"] = BenchmarkGroup()
SUITE["conversion"]["Graphs_to_IGraph"] = @benchmarkable IGraph($SAMPLE_GRAPH)
SUITE["conversion"]["IGraph_to_Graphs"] = @benchmarkable Graphs.Graph($SAMPLE_IGRAPH)

SUITE["algorithms"] = BenchmarkGroup()
SUITE["algorithms"]["diameter"] = @benchmarkable diameter($SAMPLE_GRAPH, IGraphAlg())
SUITE["algorithms"]["radius"] = @benchmarkable radius($SAMPLE_GRAPH, IGraphAlg())
