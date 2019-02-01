module PersistenceDiagrams

using RecipesBase

include("diagram.jl")
include("plotting.jl")

export
    AbstractInterval, Interval, birth, death,
    AbstractDiagram, Diagram, dim,
    diagramplot, diagramplot!, barcodeplot, barcodeplot!
end
