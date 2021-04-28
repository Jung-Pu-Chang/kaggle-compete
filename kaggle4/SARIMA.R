library(forecast)#AUTO-ARIMA
library(tseries) #adf kpss test
library(dplyr)# mutate %>% 
data <- read.csv(file="D:\\Tesla.csv.CSV",header=TRUE,sep=",")
data$Date <- as.Date(data$Date, format="%m/%d/%Y")
data <- mutate(data,�褸�~=substr(Date,start=1,stop=4))
data <- mutate(data,��=substr(Date,start=6,stop=7))
data <- mutate(data,��=substr(Date,start=9,stop=10))
data <- mutate(data,�s���=paste(�褸�~,��,��,sep=""))
data$�s��� <- as.numeric(data$�s���)

���v��� <- subset(data,data$�s���>=20150000&data$�s���<=20170300)
#�w��20170301~0317
��Ӳ� <- subset(data,data$�s���>=20170301) 

�ɧǮ榡 <- ts(���v���$Close, frequency=30)
��� <- decompose(�ɧǮ榡) #type add(�u�`���H�ɶ��W�[) mult(�H�ɶ��W�[)
plot(���)

#to í�w
adf.test(�ɧǮ榡)
lamda�ഫ <- BoxCox(�ɧǮ榡,lambda = "auto")
BoxCox.lambda(�ɧǮ榡)
adf.test(lamda�ഫ)
�t�� <- diff(�ɧǮ榡, differences = 1)
#�t���B�ഫ <- diff(BoxCox(�ɧǮ榡,lambda = "auto"),differences = 1)
adf.test(�t��)  #< í�w�A�ڭ̦��������Ҿڱ�½��í�w�����]

#�ؼ�
auto.arima(�ɧǮ榡,stepwise = F,d=1,trace = T,stationary = T,ic=c("aic")) #�p�n
fit <- arima(�ɧǮ榡,order=c(2,1,0), include.mean = FALSE)


#�˵�
tsdisplay(residuals(fit), lag.max=50, main='�ݮt�j��')
shapiro.test(fit$residuals) #�ݮt>a �`�A
Box.test(fit$residuals, lag=30, type="Ljung-Box") 
#p>a�S�����Ҿڻ���1~30���ݮt�O�D�s�۬���(�����Y��!=0)>>1~24���W��

#5.�w���~�t�P�˰Q�Ŷ�
p<-forecast(fit,13,lambda = 1)
p
plot(p)
�w�� <- as.data.frame(p)
���� <- cbind(�w��,��Ӳ�)
���� <- ���� %>% 
  mutate(mae=abs(Close-����$`Point Forecast`)) %>% 
  mutate(mape=abs(Close-����$`Point Forecast`)/����$`Point Forecast`)
mean(����$mape)