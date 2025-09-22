@testitem "ExplicitImports" begin
    using ExplicitImports
    using IGraphs

    check_no_implicit_imports(IGraphs; allow_unanalyzable=(IGraphs.LibIGraph,))
    check_all_explicit_imports_via_owners(IGraphs)
    check_all_explicit_imports_are_public(IGraphs)
    check_no_stale_explicit_imports(IGraphs; allow_unanalyzable=(IGraphs.LibIGraph,))
    check_all_qualified_accesses_via_owners(IGraphs)
    #check_all_qualified_accesses_are_public(IGraphs)
    check_no_self_qualified_accesses(IGraphs)
end
