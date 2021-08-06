//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.

data {
  int<lower=0> N; 
  int<lower=1,upper=85> county[N];
  vector[N] x;
  vector[N] y;
}


// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[85] a;
  vector[85] beta;
  real mu_a;
  real mu_b;
  real<lower=0,upper=100> sigma_a;
  real<lower=0> sigma_b;
  real<lower=0> sigma_y;
} 

transformed parameters {
  vector[N] y_hat;

  for (i in 1:N)
    y_hat[i] = beta[county[i]] * x[i] + a[county[i]];
}


// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  // Hyperpriors 
  sigma_a ~ uniform(0, 100);
  sigma_b ~ uniform(0, 100);
  mu_a ~ normal(0, 100);
  mu_b ~ normal(0, 100);
  // Priors 
  a ~ normal (mu_a, sigma_a);
  beta ~ normal (mu_b, sigma_b);
  // Model 
  y ~ normal(y_hat, sigma_y);
}

