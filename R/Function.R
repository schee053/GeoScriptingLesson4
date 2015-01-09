# Remove clouds for landsat 8
cloud8NA <- function(x, y){
  x[y != 0] <- NA
  return(x)
}

# Remove clouds for landsat 5
cloud5NA <- function(x, y){
  x[y != 0] <- NA
  return(x)
}
