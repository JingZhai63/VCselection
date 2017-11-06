module VCselection

if VERSION > v"0.5-"
  import Polynomials
  using Polynomials
  export
  VClasso,
  LVClasso,
  include("VClasso_v5.jl")
  include("LVClasso_v5.jl")
elseif VERSION < v"0.5-" && VERSION >= v"0.4-"
  export
  Polynomial,
  VClasso,
  LVClasso
  include("Polynomial.jl")
  include("VClasso.jl")
  include("LVClasso.jl")
end

end
