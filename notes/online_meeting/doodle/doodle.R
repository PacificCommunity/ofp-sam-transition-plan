library(TAF)

doodle <- read.table("doodle.dat", header=TRUE, check.names=FALSE)
rownames(doodle) <- NULL

cbind(sort(rowSums(doodle[-1])))
cbind(sort(colSums(doodle[-1])))

doodle <- doodle[c("Person", "13d", "16b")]
doodle$Person[doodle$"13d"==1 & doodle$"16b"==0]
doodle$Person[doodle$"13d"==0 & doodle$"16b"==1]
doodle$Person[doodle$"13d"==1 & doodle$"16b"==1]
