function inference(μx_A, all_μy_B, I, 𝐲_range)
    if I == 2 # for 2 set
        # 1th rule
        # IF (xₙ IS HIGH) OR (xₙ IS LOW)
        # THEN yₙ IS LOW
        μx_A₁ = μx_A[1] # the input fuzzy set LOW
        μx_A₂ = μx_A[2] # the input fuzzy set HIGH
        μx_A = map(max, μx_A₁, μx_A₂) # apply the 1th rule -> A = A₁ ∨ A₂ (OR fuzzy operator)
        all_μy_B₁ = all_μy_B[:,1] # the output fuzzy set LOW
        μAtoB⁽¹⁾ = map(min, fill(μx_A, length(all_μy_B₁)), all_μy_B₁) # Modus Ponens

        # 2th rule
        # IF NOT((xₙ IS HIGH) OR (xₙ IS LOW))
        # THEN yₙ IS HIGH
        μx_Ā = 1 - μx_A # apply the 2th rule -> A = ¬(A₁ ∨ A₂)
        all_μy_B₂ = all_μy_B[:,2] # the output fuzzy set HIGH
        μAtoB⁽²⁾ = map(min, fill(μx_Ā, length(all_μy_B₁)), all_μy_B₂) # Modus Ponens

        # resulting output fuzzy set (aggregation)
        μAtoB = map(max, μAtoB⁽¹⁾, μAtoB⁽²⁾)

        # centroid mass (defuzzification)
        ŷₙ = sum(μAtoB.*𝐲_range)./sum(μAtoB)

    else # for 3 set
        # 1th rule
        # IF xₙ IS MEDIUM
        # THEN yₙ IS HIGH
        μx_A₂ = μx_A[2] # the input fuzzy set MEDIUM
        μy_B₃ = all_μy_B[:,3] # the output fuzzy set HIGH
        μAtoB⁽¹⁾ = map(min, fill(μx_A₂, length(μy_B₃)), μy_B₃) # Modus Ponens 
        
        # 2th rule
        # IF xₙ IS LOW
        # THEN yₙ IS MEDIUM
        μx_A₁ = μx_A[1] # the input fuzzy set LOW
        μy_B₂ = all_μy_B[:,2] # the output fuzzy set MEDIUM
        μAtoB⁽²⁾ = map(min, fill(μx_A₁, length(μy_B₂)), μy_B₂) # Modus Ponens

        # 3th rule
        # IF xₙ IS HIGH
        # THEN yₙ IS LOW
        μx_A₃ = μx_A[3] # the input fuzzy set LOW
        μy_B₁ = all_μy_B[:,1] # the output fuzzy set MEDIUM
        μAtoB⁽³⁾ = map(min, fill(μx_A₃, length(μy_B₁)), μy_B₁) # Modus Ponens

        # resulting output fuzzy set (aggregation)
        μAtoB = map(max, μAtoB⁽¹⁾, μAtoB⁽²⁾, μAtoB⁽³⁾)

        # centroid mass (defuzzification)
        ŷₙ = sum(μAtoB.*𝐲_range)./sum(μAtoB)
    end

    return ŷₙ
end