import Graphs

# Connected components (undirected)
Graphs.connected_components(G::GraphsCompat.IGSimpleGraph) =
    IGraphs.connected_components(G.g)   # return format should match Graphs’ expectation

# BFS tree from a source (return order)
Graphs.bfs_tree(G::GraphsCompat.IGSimpleGraph, s::Int) =
    _to1.(IGraphs.bfs(G.g, _to0(s)))
