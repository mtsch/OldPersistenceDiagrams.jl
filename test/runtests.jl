using PersistenceDiagrams

using RecipesBase
using Suppressor
using Test

@testset "Interval" begin
    @test_throws ArgumentError Interval(2, 1)
    i1 = Interval(1, 2)
    @test eltype(i1) == Int
    @test birth(i1) == 1
    @test death(i1) == 2
    # Ensure all prints go to io.
    @test @capture_out(print(stdout, i1)) == @capture_err(print(stderr, i1))

    i2 = Interval(0.8, Inf)
    @test eltype(i2) == Float64
    @test birth(i2) == 0.8
    @test death(i2) == Inf
    # Ensure all prints go to io.
    @test @capture_out(print(stdout, i2)) == @capture_err(print(stderr, i2))
end

@testset "Diagram" begin
    dgm = Diagram([Interval(1.0, 2.0),
                   Interval(1.0, 3.0),
                   Interval(2.0, 4.0),
                   Interval(3.0, Inf)], 1)
    # Indexing and array stuff.
    @test eltype(dgm) == Interval{typeof(1.0)}
    @test dgm[1] == Interval(1.0, 2.0)
    @test dgm[end] == Interval(3.0, Inf)
    @test dgm[:] == dgm
    @test dgm[1:end] == dgm
    @test dgm[[false, true, false, true]] == Diagram([Interval(1.0, 3.0),
                                                      Interval(3.0, Inf)], 1)
    @test (dgm[end] = Interval(4.0, Inf)) == Interval(4.0, Inf)
    @test birth.(dgm) == [1.0, 1.0, 2.0, 4.0]
    @test death.(dgm) == [2.0, 3.0, 4.0, Inf]

    # Ensure all prints go to io.
    @test @capture_out(print(stdout, dgm)) == @capture_err(print(stderr, dgm))

    @test dim(dgm) == 1
end
