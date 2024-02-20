using DSP
using RecipesBase

@recipe function plot(
    f::FilterCoefficients;
    xguide = "Real part",
    yguide = "Imaginary part",
    legend = true,
    unitcolor = :auto,
    zerocolor = :auto,
    zeromarker = :o,
    polecolor = :auto,
    polemarker = :x,
)
    f = ZeroPoleGain(f)

    xguide := xguide
    yguide := yguide

    @series begin
        seriestype := :path
        label := ""
        marker := :none
        linestyle := :dash
        seriescolor := unitcolor
        cos, sin, 0, 2 * π
    end

    seriestype := :scatter
    aspect_ratio := :equal

    @series begin
        label := "zero"
        marker := zeromarker
        markercolor := zerocolor
        Complex.(f.z)
    end

    @series begin
        label := "pole"
        marker := polemarker
        markercolor := polecolor
        Complex.(f.p)
    end
end