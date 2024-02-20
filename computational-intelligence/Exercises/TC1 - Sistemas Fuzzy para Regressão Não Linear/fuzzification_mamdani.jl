function input_fuzzification(xₙ, I)
    sets = rand(I)
    if I == 2
        # SMALL fuzzy set (1th set) → ~N(72, 350)
        x̄ₙ, σ²ₓ = 72, 350
        sets[1] = ℯ^(-((max(xₙ, x̄ₙ)-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

        # LARGE fuzzy set (2th set) → ~N(172, 350)
        x̄ₙ = 172
        sets[2] = ℯ^(-((min(xₙ, x̄ₙ)-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

    elseif I == 3
        # SMALL fuzzy set (1th set) → ~N(52, 600)
        x̄ₙ, σ²ₓ = 52, 600
        sets[1] = ℯ^(-((max(xₙ, x̄ₙ)-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

        # MEDIUM fuzzy set (2th set) → ~N(127, 300)
        x̄ₙ, σ²ₓ = 127, 300
        sets[2] = ℯ^(-((xₙ-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

        # LARGE fuzzy set (3th set) → ~N(202, 600)
        x̄ₙ, σ²ₓ = 202, 600
        sets[3] = ℯ^(-((min(xₙ, x̄ₙ)-x̄ₙ)^2)/(2*σ²ₓ))/√(2*π*σ²ₓ)

    end
    return sets
end

function output_fuzzification(yₙ, I)
    sets = rand(I)
    if I == 2
        # SMALL fuzzy set (1th set) → ~N(40, 800)
        ȳₙ, σ²y = 40, 800
        sets[1] = ℯ^(-((max(yₙ, ȳₙ)-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
        
        # LARGE fuzzy set (2th set) → ~N(125, 800)
        ȳₙ = 125
        sets[2] = ℯ^(-((min(yₙ, ȳₙ)-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
    elseif I == 3
        # SMALL fuzzy set (1th set) → ~N(5, 100)
        ȳₙ, σ²y = 5, 100
        sets[1] = ℯ^(-((max(yₙ, ȳₙ)-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)

        # MEDIUM fuzzy set (2th set) → ~N(70, 100)
        ȳₙ = 70
        sets[2] = ℯ^(-((yₙ-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
        
        # LARGE fuzzy set (3th set) → ~N(140, 100)
        ȳₙ = 140
        sets[3] = ℯ^(-((min(yₙ, ȳₙ)-ȳₙ)^2)/(2*σ²y))/√(2*π*σ²y)
    end
    return sets
end