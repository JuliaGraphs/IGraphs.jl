# IGraphs.jl

A Julia wrapper for the [igraph](https://igraph.org/) C library, providing high-performance graph algorithms through the [Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl) interface.

## Installation

```julia
using Pkg
Pkg.add("IGraphs")
```

## Quick Start

```julia
using IGraphs, Graphs

# Create an undirected graph
g = IGraph(10)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)

# Create a directed graph
dg = IGraph(10, true)
add_edge!(dg, 1, 2)

# Use standard Graphs.jl algorithms
println(nv(g))  # 10
println(ne(g))  # 2
```
