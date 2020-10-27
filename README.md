# empirical project
This repository contains the matlab code and course project for the course empirical method.

- `cqr_ilp.m` is the function that used to compute censored quantile regression by Iterative Linear Programming. Input is (independent var, dependent var, censored point, quantile, initial value, number of burn in iterations, numbers of iterations that are kept). Output is (estimate, keep sequence, whether converge to a local minimum).
- `dgp.m` is the data generating process function of the simulated model. Input is (sample size, true parameter, random seed).
- `histo.m` is the subroutine that plots histograms of the estimation results.
- `mc_chain.m` is the subroutine used to plot the simulated Markov Chain in quasi-Bayesian method. And also plot the surface of objective function.
- `mcmc\_run.m` is the function run the MCMC procedure. Input is (dependent var, independent var, initial var, quantile, length of burn in sequence, length of keep sequence, preset acceptance rate,random seed). Output is (estimate, number of times accepted).
- `obj.m` is objective function of censored quantile model. Input is (dependent var, independent var, parameter, quantile).
- `rq.m` is the quantile regression solver provided online by Roger Koenker.

