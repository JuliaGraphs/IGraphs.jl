# test_interface_igraphs_containers.jl
# Pattern inspired by NautyGraphs' interface test, adapted to test the
# IGraphs container interfaces using GraphsInterfaceChecker.

using Test
using GraphsInterfaceChecker          # brings in interface definitions & helpers
using Interfaces
import BaseInterfaces                 # IterationInterface, ArrayInterface traits
using IGraphs

@testset "interface (IGraphs base containers)" begin
    # === Vector-like interface checks (IGraphs.vtypes) ===
    for (VTs, ET, _) in IGraphs.vtypes
        VT = eval(VTs)

        # Provide example instances to the checker
        v_samples = [VT(rand(ET, 10))]

        # Declare conformance (mirrors NautyGraphs pattern)
        @implements BaseInterfaces.IterationInterface                 VT v_samples
        @implements BaseInterfaces.IterationInterface{(:indexing,)}   VT v_samples
        @implements BaseInterfaces.ArrayInterface                     VT v_samples
        @implements BaseInterfaces.ArrayInterface{(:logical,:setindex!)} VT v_samples

        # Run the interface tests
        @test Interfaces.test(BaseInterfaces.IterationInterface,                     VT, v_samples)
        @test Interfaces.test(BaseInterfaces.IterationInterface{(:indexing,)},       VT, v_samples)
        @test Interfaces.test(BaseInterfaces.ArrayInterface,                         VT, v_samples)
        @test Interfaces.test(BaseInterfaces.ArrayInterface{(:logical,:setindex!)},  VT, v_samples)

        # Round-trip conversion checks (from IGraphs test_interfaces)
        v = VT(rand(ET, 10))
        @test Vector(VT(Vector(v))) == Vector(v)
        @test VT(Vector(v)) == v
    end

    # === Matrix-like interface checks (IGraphs.mtypes) ===
    for (MTs, ET, _) in IGraphs.mtypes
        MT = eval(MTs)

        m_samples = [MT(rand(ET, 10, 5))]

        # Declare conformance
        @implements BaseInterfaces.IterationInterface                 MT m_samples
        @implements BaseInterfaces.IterationInterface{(:indexing,)}   MT m_samples
        @implements BaseInterfaces.ArrayInterface                     MT m_samples
        @implements BaseInterfaces.ArrayInterface{(:logical,:setindex!)} MT m_samples

        # Run the interface tests
        @test Interfaces.test(BaseInterfaces.IterationInterface,                     MT, m_samples)
        @test Interfaces.test(BaseInterfaces.IterationInterface{(:indexing,)},       MT, m_samples)
        @test Interfaces.test(BaseInterfaces.ArrayInterface,                         MT, m_samples)
        @test Interfaces.test(BaseInterfaces.ArrayInterface{(:logical,:setindex!)},  MT, m_samples)

        # Round-trip conversion checks
        m = MT(rand(ET, 10, 5))
        @test Matrix(MT(Matrix(m))) == Matrix(m)
        @test MT(Matrix(m)) == m
    end
end
