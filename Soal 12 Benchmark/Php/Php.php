<?php
function readMatrix($filename) {
    $lines = file($filename, FILE_IGNORE_NEW_LINES);
    $n = intval($lines[0]);
    $matrix = [];
    for ($i = 1; $i <= $n; $i++) {
        $matrix[] = array_map('floatval', explode(' ', $lines[$i]));
    }
    return [$matrix, $n];
}

function writeMatrix($filename, $matrix) {
    $content = array_map(function($row) {
        return implode(' ', array_map(function($num) {
            return number_format($num, 6);
        }, $row));
    }, $matrix);
    file_put_contents($filename, implode("\n", $content) . "\n");
}

function gaussJordan(&$matrix, $n) {
    $identity = array_fill(0, $n, array_fill(0, $n, 0));
    for ($i = 0; $i < $n; $i++) {
        $identity[$i][$i] = 1;
    }

    for ($i = 0; $i < $n; $i++) {
        if ($matrix[$i][$i] == 0) {
            for ($j = $i + 1; $j < $n; $j++) {
                if ($matrix[$j][$i] != 0) {
                    list($matrix[$i], $matrix[$j]) = [$matrix[$j], $matrix[$i]];
                    list($identity[$i], $identity[$j]) = [$identity[$j], $identity[$i]];
                    break;
                }
            }
        }

        $pivot = $matrix[$i][$i];
        for ($j = 0; $j < $n; $j++) {
            $matrix[$i][$j] /= $pivot;
            $identity[$i][$j] /= $pivot;
        }

        for ($k = 0; $k < $n; $k++) {
            if ($k != $i) {
                $factor = $matrix[$k][$i];
                for ($j = 0; $j < $n; $j++) {
                    $matrix[$k][$j] -= $factor * $matrix[$i][$j];
                    $identity[$k][$j] -= $factor * $identity[$i][$j];
                }
            }
        }
    }

    return $identity;
}

list($matrix, $n) = readMatrix("input.txt");
$inverseMatrix = gaussJordan($matrix, $n);
writeMatrix("output.txt", $inverseMatrix);
?>
