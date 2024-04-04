function inference(all_w, all_f)
    # all_w -> [w₁, w₂, ..., wₖ]
    return Σ(all_w.*all_f)/Σ(all_w)
end