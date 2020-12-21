
source('abtest.r')

path = str_c(getwd(), '/ration/op_before')

files = list.files(path = path, pattern = '.*\\.csv')

mats = lapply(files, function(fl) ab_test(read_csv(str_c(path, '/', fl)))[['mat']])

total_mat = Reduce("+", mats)/length(mats)


