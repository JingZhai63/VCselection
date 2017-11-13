module VCselection
import StatsBase
using StatsBase

  if VERSION > v"0.5-"
    import Polynomials
    using Polynomials
    export
    microVClasso,
    VClasso

    include("microVClasso.jl")
    include("VClasso_v5.jl")
  elseif VERSION < v"0.5-" && VERSION >= v"0.4-"
    export
    microVClasso,
    Polynomial,
    VClasso

    include("microVClasso.jl")
    include("Polynomial.jl")
    include("VClasso.jl")
  end

end # module
