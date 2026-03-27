using Documenter
using IGraphs

makedocs(
    sitename = "IGraphs.jl",
    modules = [IGraphs],
    pages = [
        "Home" => "index.md",
    ],
)
