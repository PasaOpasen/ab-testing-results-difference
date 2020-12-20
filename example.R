

source('abtest.r')



df  <- matrix(data = runif(500*8), ncol = 8) %>% as_tibble()

df[,5] = rnorm(500, mean = 1)
df[, 6] = rnorm(500, mean = -0.7)
df[,7] = runif(500, min = -3, max = 1)
df[,8] = rnorm(500, mean = -0.7, sd = 2)


ab_test(df)


