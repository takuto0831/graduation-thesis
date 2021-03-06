library(dplyr)
library(tidyverse)
library(foreach)
library(ggthemes)
library(circular)

# project normal func
ff <- function(theta,mu,Sigma){
  u = matrix(c(cos(theta),sin(theta)),ncol=1)
  A = t(u) %*% solve(Sigma) %*% u
  B = t(u) %*% solve(Sigma) %*% mu
  C = (-1/2) * (t(mu) %*% solve(Sigma) %*% mu)
  tmp = B/sqrt(A)
  p = (1/(2*pi*A*sqrt(det(Sigma)))) * exp(C) * 
    (1 + tmp*pnorm(tmp,0,1)/dnorm(tmp,0,1))
  return(p)
}

# 平均 0  
mu = matrix(c(0,0),ncol=1); 
sigma1 = 1; sigma2 = 1; rho = 0
Sigma = matrix(c(sigma1^2,rho*sigma1*sigma2,
                 rho*sigma1*sigma2,sigma2^2),ncol=2)

# 予測値をプロット
theta <- seq(0, 2 * pi ,0.1)
x <- foreach(i=theta, .combine = c) %do% projected_normal_circular(i,mu,Sigma) 

data.frame(theta = theta,prob = x) %>% 
  ggplot(aes(x = theta, y = prob)) + 
  geom_line() 

# 非対称分布 
mu = matrix(c(-0.19,2.09),ncol=1); 
sigma1 = 1.58; sigma2 = 1.4; rho = -0.84
Sigma = matrix(c(sigma1^2,rho*sigma1*sigma2,
                 rho*sigma1*sigma2,sigma2^2),ncol=2)

# 予測値をプロット
theta <- seq(0, 2 * pi ,0.1)
x <- foreach(i=circular(theta), .combine = c) %do% projected_normal_circular(i,mu,Sigma) 
data.frame(theta = theta,prob = x) %>% 
  ggplot(aes(x = theta, y = prob)) + 
  geom_line() 

ff <- function(x) dpnorm(x, mu=mu, sigma=Sigma)
par(mar = c(0,0,0,0))
curve.circular(ff, shrink=1.6,n=1000,cex=1.4,lwd=2)

# project normal 2峰性
mu = matrix(c(-0.24,0.15),ncol=1); 
sigma1 = 0.458; sigma2 = 1.5; rho = 0.15
Sigma = matrix(c(sigma1^2,rho*sigma1*sigma2,
                 rho*sigma1*sigma2,sigma2^2),ncol=2)
# 予測値をプロット
theta <- seq(0, 2 * pi ,0.1)
x <- foreach(i=theta, .combine = c) %do% projected_normal_circular(i,mu,Sigma) 

data.frame(theta = theta,prob = x) %>% 
  ggplot(aes(x = theta, y = prob)) + 
  geom_line() 

ff <- function(x) dpnorm(x, mu=mu, sigma=Sigma)
par(mar = c(0,0,0,0))
curve.circular(ff, shrink=1.6,n=1000,cex=1.4,lwd=2)

# project normal 共分散行列 = I
mu = matrix(c(-1.2,-0.95),ncol=1)
Sigma = matrix(c(1,0,0,1),ncol=2)

# 予測値をプロット
theta <- seq(0, 2 * pi ,0.1)
x <- foreach(i=theta, .combine = c) %do% projected_normal_circular(i,mu,Sigma) 

data.frame(theta = theta,prob = x) %>% 
  ggplot(aes(x = theta, y = prob)) + 
  geom_line() 

ff <- function(x) dpnorm(x, mu=mu, sigma=Sigma)
par(mar = c(0,0,0,0))
curve.circular(ff, shrink=1.6,n=1000,cex=1.4,lwd=2)
# von Mises sample

x <- foreach(i=theta, .combine = c) %do% dvonmises(i, mu=circular(3/4), kappa=5)
data.frame(theta = theta,prob = x) %>% 
  ggplot(aes(x = theta, y = prob)) + 
  geom_line() 

## 平均方向の説明
plot(c(circular(pi/3),circular(5*pi/3)),shrink = 1)
arrows.circular(c(circular(pi/3),circular(5*pi/3)))
arrows.circular(circular(0),col=4,cex=50,lty=5)
arrows.circular(circular(pi),col=4,cex=50,lty=5)

