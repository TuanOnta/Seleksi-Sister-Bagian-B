read_matrix <- function(filename) {
  lines <- suppressWarnings(readLines(filename))
  n <- as.integer(lines[1])
  matrix <- matrix(as.numeric(unlist(strsplit(lines[-1], " "))), nrow=n, byrow=TRUE)
  list(matrix=matrix, n=n)
}



write_matrix <- function(filename, matrix) {
  formatted_matrix <- apply(matrix, c(1, 2), function(x) sprintf("%.6f", x))
  write.table(formatted_matrix, file=filename, row.names=FALSE, col.names=FALSE, quote=FALSE)
}

gauss_jordan <- function(matrix, n) {
  identity <- diag(n)
  
  for (i in 1:n) {
    if (matrix[i, i] == 0) {
      for (j in (i+1):n) {
        if (matrix[j, i] != 0) {
          matrix[c(i, j), ] <- matrix[c(j, i), ]
          identity[c(i, j), ] <- identity[c(j, i), ]
          break
        }
      }
    }
    
    pivot <- matrix[i, i]
    matrix[i, ] <- matrix[i, ] / pivot
    identity[i, ] <- identity[i, ] / pivot
    
    for (k in 1:n) {
      if (k != i) {
        factor <- matrix[k, i]
        matrix[k, ] <- matrix[k, ] - factor * matrix[i, ]
        identity[k, ] <- identity[k, ] - factor * identity[i, ]
      }
    }
  }
  
  identity
}

data <- read_matrix("input.txt")
inverse_matrix <- gauss_jordan(data$matrix, data$n)
write_matrix("output.txt", inverse_matrix)
