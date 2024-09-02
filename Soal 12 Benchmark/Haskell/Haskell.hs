import System.IO
import Data.List

type Matrix = [[Double]]

main :: IO ()
main = do
  contents <- readFile "input.txt"
  let (n:rows) = lines contents
      matrix = parseMatrix rows
      inverseMatrix = gaussJordanElimination matrix
  writeFile "output.txt" (formatMatrix inverseMatrix)

parseMatrix :: [String] -> Matrix
parseMatrix = map (map read . words)

formatMatrix :: Matrix -> String
formatMatrix = unlines . map (unwords . map show)

gaussJordanElimination :: Matrix -> Matrix
gaussJordanElimination mat = 
  let size = length mat
      identityMatrix = generateIdentity size
      augmentedMatrix = combineMatrices mat identityMatrix
      forwardEliminated = forwardElimination augmentedMatrix size
      finalMatrix = backwardElimination forwardEliminated size
  in extractInverse finalMatrix size

generateIdentity :: Int -> Matrix
generateIdentity n = [ [if i == j then 1 else 0 | j <- [0..n-1]] | i <- [0..n-1] ]

combineMatrices :: Matrix -> Matrix -> Matrix
combineMatrices = zipWith (++)

forwardElimination :: Matrix -> Int -> Matrix
forwardElimination mat n = foldl (eliminateRow n) mat [0..n-1]

eliminateRow :: Int -> Matrix -> Int -> Matrix
eliminateRow n mat pivot = 
  let pivotRow = normalizeRow (mat !! pivot) pivot
      subRows = map (reduceRow pivotRow pivot) (zip [0..n-1] mat)
  in replaceRow subRows pivot pivotRow

normalizeRow :: [Double] -> Int -> [Double]
normalizeRow row pivot = let factor = row !! pivot
                         in map (/ factor) row

reduceRow :: [Double] -> Int -> (Int, [Double]) -> [Double]
reduceRow pivotRow pivot (index, row)
  | index == pivot = row
  | otherwise = zipWith (\x y -> x - (row !! pivot) * y) row pivotRow

replaceRow :: [a] -> Int -> a -> [a]
replaceRow mat idx newRow = take idx mat ++ [newRow] ++ drop (idx + 1) mat

backwardElimination :: Matrix -> Int -> Matrix
backwardElimination mat n = foldr (eliminateRowBackward n) mat [n-1, n-2..0]

eliminateRowBackward :: Int -> Int -> Matrix -> Matrix
eliminateRowBackward n pivot mat = 
  let pivotRow = mat !! pivot
      subRows = map (reduceRow pivotRow pivot) (zip [0..n-1] mat)
  in replaceRow subRows pivot pivotRow

extractInverse :: Matrix -> Int -> Matrix
extractInverse mat n = map (drop n) mat
