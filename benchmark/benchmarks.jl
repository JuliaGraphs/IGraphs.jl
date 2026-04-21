using BenchmarkTools
using IGraphs
using Graphs

const SUITE = BenchmarkGroup()

SUITE["construction"] = BenchmarkGroup()
SUITE["construction"]["undirected_100"] = @benchmarkable IGraph(100, false)
SUITE["construction"]["directed_100"] = @benchmarkable IGraph(100, true)

SUITE["conversion"] = BenchmarkGroup()
SUITE["conversion"]["SimpleGraph_to_IGraph"] = @benchmarkable IGraph($g) setup=(g = Graphs.cycle_graph(100))
