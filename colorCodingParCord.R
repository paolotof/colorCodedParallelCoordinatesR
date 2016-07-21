setwd('~/github/colorCodedParallelCoordinatesR/')
# source('colorCodingParCord.R')
meanBehav <- read.table('data', header = TRUE)
head(meanBehav)

require(MASS)
# colour the lines depending on the elements' order within the first variable. 
# 2 groups 
# note parenthesis are (dim(meanBehav)[1]-1), because : has priority on -
colVect <- 1 + (0 : (dim(meanBehav)[1]-1))%/% round(dim(meanBehav)[1] / 2)
parcoord(meanBehav, var.label = TRUE, col = colVect)
# or 3
colVect <- 1 + (0 : (dim(meanBehav)[1]-1)) %/% round(dim(meanBehav)[1] / 3)
parcoord(meanBehav[, c('acc', 'Quest', 'RT')], var.label = TRUE, col = colVect)

# Sort the data along one feature: plotting ordered lines helps in understanding
# how the parcoord function plots
# A the indexes of the lowest to highest scores for the questionnaire
orderedQuest <- sort(meanBehav$Quest, index.return = TRUE)$ix
# B-1 use the Quest index to order the data
# B-2 set Quest to be first plotted so that the 2 groups can easily be identified
parcoord(meanBehav[orderedQuest, c('Quest', 'acc', 'RT')], var.label = TRUE, 
   col = colVect)

# Color lines directions: blue lines go upward  red lines downward.
# I choose RTs and Quest scores but any combination is possible.
dirSlopes <- ifelse(
 (meanBehav$RT - min(meanBehav$RT)) / max(meanBehav$RT) <
 (meanBehav$Quest - min(meanBehav$Quest)) / max(meanBehav$Quest), 
 'up', 'down')
colDir <- ifelse(dirSlopes == 'up', 4, 2)
parcoord(meanBehav[ , c('RT', 'Quest', 'acc')], var.label = TRUE, col = colDir)
legend("top", legend = c("up", "down"), text.col = c(4, 2), bty = 'n')

# use dotted style the 'flat' lines
tmp <- cbind((meanBehav$RT - min(meanBehav$RT)) / max(meanBehav$RT), 
  (meanBehav$Quest - min(meanBehav$Quest)) / max(meanBehav$Quest))
tmp <- tmp * 100
flats <- (tmp[, 1] - tmp[, 2]) > -5 & (tmp[, 1] - tmp[, 2]) < 5
linesType <- rep("solid", 1, dim(meanBehav)[1])
linesType[flats] <-  "dotted"
colDir <- ifelse(dirSlopes == 'up', 4, 2)
parcoord(meanBehav[ , c('RT', 'Quest', 'acc')], var.label = TRUE, 
  col = colDir, main = 'directions', lty = linesType)

## clustering
# scaled
scaledVals <- scale(meanBehav[ , c('RT', 'Quest', 'acc')])
scaledClusters <- hclust(dist(scaledVals))
# plot(scaledClusters)
# specify colors depending on cluster belonging
colDir <- cutree(scaledClusters, 3) + 1
par(mfrow = c(1,2))
parcoord(scaledVals, var.label = TRUE, col = colDir, main = 'scaled')

# unscaled
clusterR <- hclust(dist(meanBehav[ , c('RT', 'Quest', 'acc')]))
colDir <- cutree(clusterR, 3) + 1
parcoord(meanBehav, var.label = TRUE, col = colDir, main = 'unscaled')

par(mfrow = c(1,1))
# export plot
dev.copy(jpeg,'myplot.jpg')
dev.off()
# dev.copy(png,'myplot.png')
# dev.off()

