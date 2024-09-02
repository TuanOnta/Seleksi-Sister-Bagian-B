import java.io.File

fun readMatrix(fileName: String): Pair<Array<DoubleArray>, Int> {
    val lines = File(fileName).readLines()
    val n = lines[0].toInt()
    val matrix = Array(n) { DoubleArray(n) }
    
    for (i in 1..n) {
        val row = lines[i].split(" ").map { it.toDouble() }.toDoubleArray()
        matrix[i-1] = row
    }
    
    return Pair(matrix, n)
}

fun writeMatrix(fileName: String, matrix: Array<DoubleArray>) {
    val content = matrix.joinToString("\n") { it.joinToString(" ") { num -> "%.6f".format(num) } }
    File(fileName).writeText(content)
}

fun gaussJordan(matrix: Array<DoubleArray>, n: Int): Array<DoubleArray> {
    val identity = Array(n) { DoubleArray(n) }
    for (i in 0 until n) {
        identity[i][i] = 1.0
    }

    for (i in 0 until n) {
        if (matrix[i][i] == 0.0) {
            for (j in i + 1 until n) {
                if (matrix[j][i] != 0.0) {
                    matrix[i] = matrix[j].also { matrix[j] = matrix[i] }
                    identity[i] = identity[j].also { identity[j] = identity[i] }
                    break
                }
            }
        }

        val pivot = matrix[i][i]
        for (j in 0 until n) {
            matrix[i][j] /= pivot
            identity[i][j] /= pivot
        }

        for (k in 0 until n) {
            if (k != i) {
                val factor = matrix[k][i]
                for (j in 0 until n) {
                    matrix[k][j] -= factor * matrix[i][j]
                    identity[k][j] -= factor * identity[i][j]
                }
            }
        }
    }

    return identity
}

fun main() {
    val (matrix, n) = readMatrix("input.txt")
    val inverseMatrix = gaussJordan(matrix, n)
    writeMatrix("output.txt", inverseMatrix)
}
