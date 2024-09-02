const fs = require('fs');

function readMatrix(fileName) {
    const data = fs.readFileSync(fileName, 'utf8');
    const lines = data.trim().split('\n');
    const n = parseInt(lines[0]);
    const matrix = lines.slice(1).map(line => line.split(' ').map(Number));
    return { matrix, n };
}

function writeMatrix(fileName, matrix) {
    const data = matrix.map(row => row.join(' ')).join('\n');
    fs.writeFileSync(fileName, data, 'utf8');
}

function gaussJordan(matrix, n) {
    const identity = Array.from({ length: n }, (_, i) =>
        Array.from({ length: n }, (_, j) => (i === j ? 1 : 0))
    );

    for (let i = 0; i < n; i++) {
        if (matrix[i][i] === 0) {
            for (let j = i + 1; j < n; j++) {
                if (matrix[j][i] !== 0) {
                    [matrix[i], matrix[j]] = [matrix[j], matrix[i]];
                    [identity[i], identity[j]] = [identity[j], identity[i]];
                    break;
                }
            }
        }

        const pivot = matrix[i][i];
        for (let j = 0; j < n; j++) {
            matrix[i][j] /= pivot;
            identity[i][j] /= pivot;
        }

        for (let k = 0; k < n; k++) {
            if (k !== i) {
                const factor = matrix[k][i];
                for (let j = 0; j < n; j++) {
                    matrix[k][j] -= factor * matrix[i][j];
                    identity[k][j] -= factor * identity[i][j];
                }
            }
        }
    }

    return identity;
}

function invertMatrix(inputFile, outputFile) {
    const { matrix, n } = readMatrix(inputFile);
    const inverseMatrix = gaussJordan(matrix, n);
    writeMatrix(outputFile, inverseMatrix);
}

invertMatrix('input.txt', 'output.txt');
