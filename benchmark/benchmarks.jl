using BenchmarkTools
using IGraphs
using Graphs

const SUITE = BenchmarkGroup()

SUITE["construction"] = BenchmarkGroup()
SUITE["construction"]["default"] = @benchmarkable IGraph()


SUITE["conversion"] = BenchmarkGroup()
SUITE["conversion"]["SimpleGraph_to_IGraph"] = @benchmarkable IGraph($g) setup=(g = Graphs.cycle_graph(100))
