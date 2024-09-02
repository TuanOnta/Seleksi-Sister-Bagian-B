function read_matrix(filename)
    local file = io.open(filename, "r")
    local n = tonumber(file:read("*line"))
    local matrix = {}
    for i = 1, n do
        local row = {}
        for num in file:read("*line"):gmatch("%S+") do
            table.insert(row, tonumber(num))
        end
        table.insert(matrix, row)
    end
    file:close()
    return matrix, n
end

function write_matrix(filename, matrix)
    local file = io.open(filename, "w")
    for _, row in ipairs(matrix) do
        for j, num in ipairs(row) do
            if j > 1 then file:write(" ") end
            file:write(string.format("%.6f", num))
        end
        file:write("\n")
    end
    file:close()
end

function gauss_jordan(matrix, n)
    local identity = {}
    for i = 1, n do
        identity[i] = {}
        for j = 1, n do
            identity[i][j] = (i == j) and 1 or 0
        end
    end

    for i = 1, n do
        if matrix[i][i] == 0 then
            for j = i + 1, n do
                if matrix[j][i] ~= 0 then
                    matrix[i], matrix[j] = matrix[j], matrix[i]
                    identity[i], identity[j] = identity[j], identity[i]
                    break
                end
            end
        end

        local pivot = matrix[i][i]
        for j = 1, n do
            matrix[i][j] = matrix[i][j] / pivot
            identity[i][j] = identity[i][j] / pivot
        end

        for k = 1, n do
            if k ~= i then
                local factor = matrix[k][i]
                for j = 1, n do
                    matrix[k][j] = matrix[k][j] - factor * matrix[i][j]
                    identity[k][j] = identity[k][j] - factor * identity[i][j]
                end
            end
        end
    end

    return identity
end

local matrix, n = read_matrix("input.txt")
local inverse_matrix = gauss_jordan(matrix, n)
write_matrix("output.txt", inverse_matrix)
