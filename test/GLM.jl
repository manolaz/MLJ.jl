module TestGLM

# using Revise
using MLJ
using Test
using DataFrames

task = load_boston()
X, y = X_and_y(task)
X = DataFrame(X) # needed for DataFrames < v0.17.0

import GLM

train, test = partition(eachindex(y), 0.7)

atom_ols = OLSRegressor()

ols = machine(atom_ols, X[train, :], y[train])
fit!(ols)

p = predict(ols, X[test, :])

# hand made regression to compare

Xa = convert(Matrix{Float64}, X)
Xa1 = hcat(Xa, ones(size(Xa, 1)))
coefs = Xa1[train, :] \ y[train]

p2 = Xa1[test, :] * coefs

@test p ≈ p2

info(atom_ols)

end # module
true