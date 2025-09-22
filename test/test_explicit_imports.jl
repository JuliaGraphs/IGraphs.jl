@testitem "ExplicitImports" begin
    using ExplicitImports
    using IGraphs

    check_no_implicit_imports(IGraphs; allow_unanalyzable=(IGraphs.LibIGraph,))
end