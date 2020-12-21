
source('abtest.r')


files = list.files(path = getwd(), pattern = '.*\\.csv')

mats = lapply(files, function(fl) ab_test(read_csv(fl))[['mat']])

total_mat = Reduce("+", mats)/length(mats)


