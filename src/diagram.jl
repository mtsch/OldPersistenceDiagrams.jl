"""
An `AbstractInterval` stores the birth and death times of a feature.

Concrete subtypes should either have the fields `birth` and `death` or define the `birth`
and `death` accessor functins.
"""
abstract type AbstractInterval{T} end

"""
    birth(interval)

Get the birth time of an interval.
"""
birth(i::AbstractInterval) = i.birth
"""
    death(interval)

Get the death time of an interval.
"""
death(i::AbstractInterval) = i.death

Base.eltype(::AbstractInterval{T}) where {T} = T
Base.eltype(::Type{A}) where A<:AbstractInterval{T} where {T} = T

"""
Vanilla persistence interval. Has a `birth` and a `death`.
"""
struct Interval{T} <: AbstractInterval{T}
    birth ::T
    death ::T

    function Interval(b::T, d::T) where {T}
        b < d || throw(ArgumentError("`birth` cannot be larger than `death`!"))
        new{T}(b, d)
    end
end

function Base.show(io::IO, int::AbstractInterval)
    format_time(t, n=10) = lpad(t, n)[1:n]

    print(io, "($(format_time(birth(int))), $(format_time(death(int))))")
end

function Base.show(io::IO, ::MIME"text/plain", int::AbstractInterval)
    print(io, typeof(int))
    print(io, "($(birth(int)), $(death(int)))")
end

"""
An `AbstractDiagram` is essentially an array of `AbstractIntervals` with an associated
dimension.

Concrete subtypes should either have the fields `intervals::AbstractVector` and `dimension`
or define the Array interface and the `dim` function.
"""
abstract type AbstractDiagram{I} <: AbstractVector{I} end

"""
Vanilla persistence diagram. Holds a vector of intervals and has a `dim`.
"""
struct Diagram{I, V<:AbstractVector{I}} <: AbstractDiagram{I}
    intervals ::V
    dimension ::Int
end

# Array interface:
Base.size(diag::AbstractDiagram) =
    size(diag.intervals)
Base.getindex(diag::D, i) where {D<:AbstractDiagram} =
    if i == Colon() || length(i) ≠ 1
        D(diag.intervals[i], dim(diag))
    else
        diag.intervals[i]
    end
Base.setindex!(diag::AbstractDiagram, v, i) =
    diag.intervals[i] = v
Base.IndexStyle(::Type{D}) where D<:AbstractDiagram = IndexLinear()

"""
    dim(diagram::AbstractDiagram)

Get the dimension of the diagram.
"""
dim(diag::AbstractDiagram) =
    diag.dimension
