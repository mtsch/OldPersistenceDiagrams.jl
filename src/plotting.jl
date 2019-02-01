#TODO tolerances

function upperlim(dgm)
    T = eltype(eltype(dgm))
    lastdeath  = max(maximum(death.(dgm)),
                     maximum(birth.(dgm)))
    lastfinite = max(maximum(filter(x -> x < typemax(T), death.(dgm))),
                     maximum(birth.(dgm)))
    if lastfinite == lastdeath
        upper = lastdeath
    else
        rounded = round(lastfinite, RoundUp)
        upper = rounded + (lastfinite ≥ 1 ? length(digits(rounded)) : 0)
    end

    upper, lastfinite ≠ lastdeath
end

"""
    diagramplot(diagram)
    diagramplot!(diagram)

Plot the persistence diagram.
"""
diagramplot
"""
    diagramplot(diagram)
    diagramplot!(diagram)

Plot the persistence diagram.
"""
diagramplot!

@userplot DiagramPlot
@recipe function plot(dp::DiagramPlot)
    length(dp.args) == 1 ||
        throw(ArgumentError("Expected single argument, got $(dp.args)"))

    dgm = dp.args[1]
    upper, isinf = upperlim(dgm)
    # x = y line
    @series begin
        seriestype := :path
        label := ""
        color := :black

        [0, upper], [0, upper]
    end
    # points
    @series begin
        seriestype := :scatter
        label --> "dim = $(dim(dgm))"

        birth.(dgm), death.(dgm)
    end
    # infinity line
    if isinf
        @series begin
            seriestype := :path
            label := :inf
            color := :grey

            [0, upper], [upper, upper]
        end
    end
end

"""
    barcodeplot(diagram)
    barcodeplot!(diagram)

Plot the persistence barcode.
"""
barcodeplot
"""
    barcodeplot(diagram)
    barcodeplot!(diagram)

Plot the persistence barcode.
"""
barcodeplot!

@userplot BarcodePlot
@recipe function plot(bp::BarcodePlot)
    length(bp.args) == 1 ||
        throw(ArgumentError("Expected single argument, got $(bp.args)"))

    dgm = bp.args[1]
    upper, isinf = upperlim(dgm)
    n = length(dgm)

    @series begin
        seriestype := :path
        label --> "dim = $(dim(dgm))"
        linewidth --> 3

        xs = Float64[]
        ys = Float64[]
        for (i, int) in enumerate(sort(dgm, by = birth, rev = true))
            b, d = birth(int), min(death(int), upper)
            append!(xs, (b, d, NaN))
            append!(ys, (i, i, i))
        end
        xs, ys
    end
end
