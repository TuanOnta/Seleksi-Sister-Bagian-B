def read_matrix(filename)
    lines = File.readlines(filename)
    n = lines[0].to_i
    matrix = lines[1..n].map { |line| line.split.map(&:to_f) }
    return matrix, n
end

def write_matrix(filename, matrix)
    File.open(filename, "w") do |file|
        matrix.each do |row|
            file.puts row.map { |num| format("%.6f", num) }.join(" ")
        end
    end
end

def gauss_jordan(matrix, n)
    identity = Array.new(n) { Array.new(n, 0.0) }
    n.times { |i| identity[i][i] = 1.0 }

    n.times do |i|
        if matrix[i][i] == 0.0
            (i + 1...n).each do |j|
                if matrix[j][i] != 0.0
                    matrix[i], matrix[j] = matrix[j], matrix[i]
                    identity[i], identity[j] = identity[j], identity[i]
                    break
                end
            end
        end

        pivot = matrix[i][i]
        n.times do |j|
            matrix[i][j] /= pivot
            identity[i][j] /= pivot
        end

        n.times do |k|
            if k != i
                factor = matrix[k][i]
                n.times do |j|
                    matrix[k][j] -= factor * matrix[i][j]
                    identity[k][j] -= factor * identity[i][j]
                end
            end
        end
    end

    identity
end

matrix, n = read_matrix("input.txt")
inverse_matrix = gauss_jordan(matrix, n)
write_matrix("output.txt", inverse_matrix)
