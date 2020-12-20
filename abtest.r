
library(tidyverse)


total_test = function(long_df, all_normal = FALSE){
  if(all_normal){
    p = summary(aov(value ~ name, data = long_df))[[1]][["Pr(>F)"]]
  } else {
    p = kruskal.test(value ~ name, data = long_df)$p.value
  }
  return(p < 0.05)
}


pair_test = function(vec1, vec2, both_normal = FALSE){
  if(both_normal){
    p = t.test(vec1 , vec2, paired = FALSE, var.equal = TRUE)$p.value
  } else {
    p = wilcox.test(vec1 , vec2, paired = FALSE)$p.value
  }
  return(p < 0.05)
}


ab_test = function(df){
  # convert to long format
  df2 = pivot_longer(df, cols = names(df)) %>% mutate(name = factor(name))
  
  g = ggplot(df2, aes(y = value, x = name)) + geom_boxplot() + 
    labs(x = 'Group', title = 'Boxplots by groups') + theme_bw()
  print(g)
  
  # check normal distribution
  normals_vec = sapply(df, function(x) nortest::ad.test(x)$p.value > 0.05)
  
  # if there are global differences
  if(total_test(df2, sum(normals_vec) == length(normals_vec))){
    
  } else{
    cat('\n No difference \n')
    return()
  }
  
  
  # matrix of compares
  eq_mat = matrix(0, nrow = ncol(df), ncol = ncol(df))
  
  for(i in 1:(ncol(df)-1)){
    for(j in (i+1):ncol(df)){
      
      is_norm = normals_vec[i] & normals_vec[j]
      
      is_diff = pair_test(df[[i]], df[[j]], is_norm)
      
      if(is_diff){ # if stat. important
        
        if(mean(df[[i]]) > mean(df[[j]])){
          eq_mat[i,j] = 1
          eq_mat[j,i] = -1
        } else {
          eq_mat[i,j] = -1
          eq_mat[j,i] = 1
        }
        
      }    
      
    }
  }
  
  cat('\n Comparing matrix: \n')
  print(eq_mat)
  
  # the rule for finding most less case
  counts = rowSums(eq_mat<1)
  min_res = (1:ncol(df))[counts == max(counts)]
  
  print(colnames(df)[min_res])
}







