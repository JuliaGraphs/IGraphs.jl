using Documenter
using IGraphs

makedocs(
    sitename = "IGraphs.jl",
    modules = [IGraphs],
    checkdocs = :none,
    repo = "https://github.com/JuliaGraphs/IGraphs.jl/blob/{commit}{path}#L{line}",
    format = Documenter.HTML(
        repolink = "https://github.com/JuliaGraphs/IGraphs.jl",
    ),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/JuliaGraphs/IGraphs.jl.git",
    push_preview = true,
)
