using Documenter
using IGraphs

makedocs(
    sitename = "IGraphs.jl",
    modules = [IGraphs],
    warnonly = true,
    pages = [
        "Home" => "index.md",
    ],
)
