library(dplyr)
library(data.table) #fread dcast 
library(arules) #���p���R�]
library(arulesViz) 
##�榡��z####
data <- fread(file="D:\\relation.csv",header=TRUE)
name <- fread(file="D:\\node.csv",header=TRUE,encoding="UTF-8")
data$Source <- as.numeric(data$Source)
data$Target <- as.numeric(data$Target)
name$Id <- as.numeric(name$Id)
names(name)[names(name)=="Id"]="Source"
data <- left_join(data,name,by="Source")
names(name)[names(name)=="Source"]="Target"
data <- left_join(data,name,by="Target")
data$Label.x[is.na(data$Label.x)] <- ""
data$Label.y[is.na(data$Label.y)] <- ""
���p�榡 <- data[-c(1),c(3:4)] %>% 
            subset(Label.y!=""&Label.x!="")# ��1�U

trans <- as(���p�榡, "transactions")

##���W�h####
rule1 <- apriori(trans,parameter = list(support = 0.001,confidence = 0.6,
                                       minlen=1,maxlen=3))
# support = ����~���P�ɥX�{�b�浧�b���/�`�b���
# confidence = �R����~���U�A�ʶR�k��~�������v
# lift = �V�ʶR����~�����H���˥k��~��/�V�Ҧ��H���˥k��~��
summary(rule1)
outcome <- data.frame(lhs = labels(lhs(rule1)),rhs = labels(rhs(rule1)),rule1@quality)

#�[����(�d�� & coverage)
�[���� <- data.frame(interestMeasure(rule1, measure = c("coverage", "chiSquared"), significance=T, data))
# coverage = ����~���e��
# �d�� <0.05 �ڵ� r^2=0
���� <- cbind(outcome,�[����)
colnames(����) <- c("LHS", "RHS","support","confidence","lift","count","coverage","Chi-square") 

##�g�����}####
library(htmlwidgets)
p=inspectDT(rule1, width="100%") #���������t�m
saveWidget(p,"D:\\weibo_rules.html", selfcontained = TRUE, libdir = NULL,
           background = "white")
