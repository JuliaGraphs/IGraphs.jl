@testitem "ExplicitImports" begin
    using ExplicitImports
    using IGraphs

    # Check for any implicit imports (should return empty)
    # LibIGraph module is allowed to be unanalyzable since it contains generated code
    implicit_imports = @test_nowarn check_no_implicit_imports(IGraphs; allow_unanalyzable=(IGraphs.LibIGraph,))
    @test isempty(implicit_imports)
    
    # Check for stale explicit imports (should return empty) 
    stale_imports = @test_nowarn check_no_stale_explicit_imports(IGraphs; allow_unanalyzable=(IGraphs.LibIGraph,))
    @test isempty(stale_imports)
end