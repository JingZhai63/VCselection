#
# This function fits penalized variance component model with responses y, design matrix X
# and variance components in V by a multiplicative MM algorithm.
#
using Polynomials
function VClasso(y::Vector{Float64}, X::Matrix{Float64},
                 V::Array{Matrix{Float64}, 1},
                 λfactor::Vector{Int64}, # 0 is not penalized, 1 is penalized to 1.0
                       print::Bool=false, λgrid::Vector{Float64}=[0.0])
  n = length(y)   # no. observations
  n2 = n * n
  p = size(X, 2)  # no. predictors
  m = length(V)   # no. variance components
  ngrid = length(λgrid);
  σ2grid = zeros(m, ngrid);
  Itergrid = zeros(ngrid);
  LogLgrid = zeros(ngrid);
  Objgrid = zeros(ngrid);
  # initialize algorithm
  for k = 1:ngrid
   β = X \ y ;
   σ2 = 1e-2 * ones(m);
   σ = sqrt(σ2);
   Ω = zeros(n, n);
   for j = 1:m
     BLAS.axpy!(n2, σ2[j], V[j], 1, Ω, 1)
   end
   Ωchol = cholfact(Hermitian(Ω));
   Ωinv = inv(Ωchol);
   res = y - X * β;
   v = Ωchol \ res ;
   ##
   loglConst = - 0.5 * n * log(2.0 * pi);
   logl = loglConst - 0.5 * logdet(Ωchol) - 0.5 * dot(res, v)
   Iter = 1 :: Int
   logL = 0.0
   Obj = 0.0

   # MM loop
   maxiter = 10000::Int
   tol = 1e-4
   λ = λgrid[k];
   logllasso = -logl + λ * sumabs(λfactor[1:end].*σ[1:end-1]);
  for i = 1:maxiter
    if print
      println(i, " ",  "Obj ", logllasso, " ", "logL", logl)
    end

    # update variance components
    fill!(Ω, 0.0);
    for l = 1: m - 1
      quartic = BLAS.dot(n2, Ωinv, 1, V[l], 1)
      cubic = λ * λfactor[l]
      constant = -σ[l]^4 * ((v'* V[l])*v)[]
      # @inbounds σ[l] = min_root(quartic, cubic, constant, l, V, σ, res)

      @inbounds σ[l] = min_root(quartic, cubic, constant, l, V, σ, res)[] #ZJ
      @inbounds σ2[l] = σ[l] .^2
      @inbounds BLAS.axpy!(n2, σ2[l], V[l], 1, Ω, 1)
    end
    σ2[m] *= BLAS.nrm2(v) / sqrt(trace(Ωinv))
    σ[m] = sqrt(σ2[m])
    BLAS.axpy!(n2, σ2[m], V[m], 1, Ω, 1)
    Ωchol = cholfact(Hermitian(Ω), :L);
    Ωinv = inv(Ωchol);
    Xnew = Ωchol[:L] \ X;
    ynew = Ωchol[:L] \ y;
    # update fixed effects
    β = Xnew \ ynew;
    res = y - X * β;
    v = Ωchol \ res;
    # check convergence
    logllassoold = logllasso
    logl = loglConst - 0.5 * logdet(Ωchol) - 0.5 * dot(res, v)
    logllasso = -logl + λ * sumabs(λfactor[1:end].*σ[1:end-1]);
    if abs(logllasso - logllassoold) < tol * (abs(logllassoold) + 1.0)
      #println(i," ", logl)
      Obj = logllasso
      logL = logl;
      Iter = i
      break
    end
   end # end of loop over maxiter
   σ2grid[:, k] = σ2;
   Itergrid[k] = Iter;
   LogLgrid[k] = logL;
   Objgrid[k] = Obj;
  end # end of loop over λgrid
    # output
  return σ2grid, Itergrid, LogLgrid, Objgrid
end

# this function returns the \sigma that minimize the objective function: negative loglikelihood plus penalty term
function min_root(quartic, cubic, constant, index, V, σ, res)
  # find the real positive root
  # complex_root = roots(Poly([quartic, cubic, 0, 0, constant]))
  complex_root = roots(Poly([constant,0, 0, cubic, quartic])) # ZJ:: Polynomials.Poly([constant,1,2,3..n])
  #println("root", complex_root)
  # keep real roots
  real_root = real(complex_root[imag(complex_root) .== 0])
  real_pos_root = real_root[real_root .> 0]
  # find the real negative root
  # complex_root = roots(Poly([quartic, -cubic, 0, 0, constant]))
  complex_root = roots(Poly([constant,0, 0, -cubic, quartic])) # ZJ:
  real_root = real(complex_root[imag(complex_root) .== 0])
  real_neg_root = real_root[real_root .< 0]
  root = vcat(real_pos_root, 0.0, real_neg_root) #ZJ:
  obj = copy(root);
  m = length(σ)
  n = size(V[1])[1]
  n2 = n^2
  for i = 1:length(root)
    σ[index] = root[i][1]
    σ2 = σ .^2
    Ω = zeros(n, n);
    for j = 1:m
      BLAS.axpy!(n2, σ2[j], V[j], 1, Ω, 1)
    end
    Ωchol = cholfact(Hermitian(Ω));
    Ωinv = inv(Ωchol);
    v = Ωchol \ res ;
    ##
    obj[i] =  0.5 * logdet(Ωchol) + 0.5 * dot(res, v) + cubic * sumabs(σ[1:end-1])
  end
  return root[indmin(obj)]

end
