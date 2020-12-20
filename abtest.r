
library(tidyverse)


df  <- matrix(data = runif(1000), ncol = 4) %>% as_tibble()
dfn  <- matrix(data = rnorm(1000), ncol = 4) %>% as_tibble()
colnames(dfn) = paste0('A', 1:4)

df = cbind(df, dfn)

df2 = pivot_longer(df, cols = names(df)) %>% mutate(name = factor(name))


ggplot(df2, aes(y = value, x = name)) + geom_boxplot() + 
  labs(x = 'Group', title = 'Boxplots by groups') + theme_bw()



normals_vec = sapply(df, function(x) shapiro.test(x)$p.value > 0.05)



t.test(df2$value ~ df2$name, paired = TRUE)




summary(aov(value ~ name, data = df2))



