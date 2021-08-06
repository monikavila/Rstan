# Running stan
# 
# 1. Open rstudio as administrator
# 2. Install rstan
# Sys.setenv(MAKEFLAGS = paste0("-j",parallel::detectCores()))
# install.packages(c("StanHeaders", "rstan"), type = "source")
# 3. Test installation 
# example(stan_model, package = "rstan", run.dontrun = TRUE)
# If you get an error that g++ missing you can ignore it. 
# Note: Make sure that you installed Rcpp for C++ 
# in your operating system 
# More details in
# https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
# https://github.com/stan-dev/rstan/wiki/Configuring-C---Toolchain-for-Windows

#install.packages("ggplot2")
#library(ggplot2)
install.packages("dplyr")
library(dplyr)
install.packages("rstanarm")
library(rstanarm)
library(rstan)
# Ex.1 Linear Regression
N=1000
alpha_true=10
beta_true=5
x=runif(N,-1,1)
y=alpha_true+beta_true*x+rnorm(N,0,1)
linreg_dat <- list(N = N, 
                    y = y,
                    x = x)
fit <- stan(file = 'lr.stan', data = linreg_dat)
print(fit)
plot(fit)
pairs(fit, pars = c("beta", "alpha", "sigma"))


# Ex.2 Linear Regression QR transformation. This QR transformation is done to 
# eliminate dependencies between regressors in the design matrix X. 
N=1000
alpha_true=10
K=3
beta_true=c(5,6,2)
x=matrix(rnorm(1000*K),ncol=K)
y=alpha_true+x%*%beta_true+rnorm(N,0,1)
y=c(y)
linreg_dat <- list(N = N,
                   K=K,
                   y = y,
                   x = x)
fit <- stan(file = 'lr_qr.stan', data = linreg_dat)
print(fit)
plot(fit)
pairs(fit, pars = c("beta", "alpha", "sigma"))


# Ex.3 Linear Regression  with priors.
N=1000
alpha_true=10
beta_true=5
x=runif(N,-1,1)
y=alpha_true+beta_true*x+rnorm(N,0,1)
linreg_dat <- list(N = N, 
                   y = y,
                   x = x)

scale_alpha <- sd(y) * 10
scale_beta <- sd(x) * sd(y) * 2.5
loc_sigma <- sd(y)

linreg_dat <- list(N = N,
                   y = y,
                   x = x,
                   scale_alpha=scale_alpha, 
                   scale_beta=scale_beta,
                   loc_sigma=loc_sigma)
fit <- stan(file = 'lr_priors.stan', data = linreg_dat)
print(fit)
plot(fit)
pairs(fit, pars = c("beta", "alpha", "sigma"))



# Ex4.  Multilevel model https://jrnold.github.io/bayesian_notes/multilevel-models.html
# Ex4.1 Pooled Model
data("radon", package = "rstanarm")
glimpse(radon)
radon_county <- radon 
x=radon_county$floor
y=radon_county$log_radon    
dat=list(N = length(y),
        y = y,
        x = x)
fit <- stan(file = 'pooled_model.stan', data = dat)
print(fit)
plot(fit)
pairs(fit, pars = c("beta", "sigma"))

# Ex4.2 Additive RE Model

county_int=as.integer(radon_county$county)
dat=list(N = length(y),
         county=county_int,
         y = y,
         x = x)
fit <- stan(file = 'semipooled_model.stan', data = dat)
print(fit)
plot(fit)
pairs(fit, pars = c("beta", "sigma"))


# Ex4.3 Multiplicative RE Model
county_int=as.integer(radon_county$county)
dat=list(N = length(y),
         county=county_int,
         y = y,
         x = x)
fit <- stan(file = 'semipooled_model.stan', data = dat)
print(fit)
plot(fit)
pairs(fit, pars = c("beta", "sigma"))

# Ex4.4 Multiplicative RE Model - Hierarchical Bayes Estimator 
county_int=as.integer(radon_county$county)
dat=list(N = length(y),
         county=county_int,
         y = y,
         x = x)
fit <- stan(file = 'unpooled_model.stan', data = dat)
print(fit)
plot(fit)
pairs(fit, pars = c("beta", "sigma_y"))



# Note: %>% is a pipe operator that transmits the output of the first function directly to the following function as its input.
# It has a mathematical interpretation as function composition. fog(x)=g(f(x)). 
   