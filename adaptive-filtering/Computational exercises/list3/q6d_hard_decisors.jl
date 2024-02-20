# hard decisors
function hard_decisor_4qam(x) # for 4-QAM
    return x>0 ? 1 : -1
end

function hard_decisor_16qam(x) # for 16-QAM
    if abs(x) > 2
        return x>0 ? 3 : -3
    else
        return x>0 ? 1 : -1
    end
end

function hard_decisor_64qam(x)
    if abs(x) > 4
        if abs(x) > 6
            return x>0 ? 7 : -7
        else
            return x>0 ? 5 : -5
        end
    elseif abs(x) > 2
        return x>0 ? 3 : -3
    else
        return x>0 ? 1 : -1
    end
end

function hard_decisor_256qam(x) # for 256-QAM
    if abs(x) > 8
        if abs(x) > 12
            if abs(x) > 14
                return x>0 ? 15 : -15
            else
                return x>0 ? 13 : -13
            end
        elseif abs(x) > 10
            return x>0 ? 11 : -11
        else
            return x>0 ? 9 : -9
        end
    elseif abs(x) > 4
        if abs(x) > 6
            return x>0 ? 7 : -7
        else
            return x>0 ? 5 : -5
        end
    elseif abs(x) > 2
        return x>0 ? 3 : -3
    else
        return x>0 ? 1 : -1
    end
end