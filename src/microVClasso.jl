## input

# V: provide path for VCs files (.csv file)
# y: provide file name and column index (.csv file, with column names)
# X: provide file name and column index (.csv file)
# λgrid: provide value or use the default (vector)
# print: default is false (Bool)
# λfactor: provide vector which the unpenalized VCs set to zero other wise the
#          default is vector of 1 with length equal to number of VCs (vector)

# criterion: None, AIC, BIC, default is AIC (String)
#            if None, will output estimations under each tuning parameter

## output

function microVClasso(args...; resFile::String= "", covFile::String = "",
  Vpath::String = "", outpath::String = "",
  covIdx ::Array{Int, 1} = [3,4], resIdx ::Int = 3, idIdx::Int = 1,
  yhead::Bool = true, xhead::Bool = true, longitudinal::Bool = false,
  λgrid::Array{Float64, 1} = Float64[], print::Bool = false,
  λfactor::Array{Float64, 1} = Float64[], criterion::String = "AIC")

  # input response data: y
    if isempty(resFile)
      error("microVClasso:ymissing\n",
      "# need to input responses file name");
    else
      y = readcsv(resFile)
      if yhead
        y = y[2:end,resIdx];
        nper = y[2:end,idIdx]
      else
        y = y[:,resIdx];
        nper = y[:,idIdx]
      end
      y = convert(Array{Float64, 1}, y);
    end

    n = length(y)

  # input covariates data: X

    if isempty(covFile)
      # no covariates provided
      X = ones(nPer, 1);
    else
      X = readcsv(covFile)
      if xhead
        X = X[2:end,covIdx];
      else
        X = X[:,covIdx];
      end
      X = convert(Array{Float64, 2}, X);
    end

    # input microbiome kernel matrices (variance components)

    if isempty(Vpath)
      error("microVClasso:vmisiing\n",
      "# need to input a path for kernel matrices");
    else
      vclist = readdir(Vpath)
      vcname = [split(vclist[i],".csv")[1] for i =1:length(vclist)]
      vc = []

      if longitudinal & isempty(λfactor)

        dic = countmap(nper)
        id = unique(nper)

        ZZ = cat([1,2],ones(dic[id[1]],dic[id[1]]))
        for i = 2:length(id)
          ZZ = cat([1,2],ZZ,ones(dic[id[i]],dic[id[i]]))
        end
        λfactor = vcat(0,ones(Int,length(vclist)))
        push!(vc,Hermitian(ZZ))
        vcname = vcat("ZZ",vcname)
      end

      for i=1:length(vclist)
        if endswith(Vpath,"/")
          psd = readcsv(string(Vpath,vclist[i]))
        else
          psd = readcsv(string(Vpath,"/",vclist[i]))
        end
        push!(vc, Hermitian(psd[:,:]))
      end
      push!(vc, eye(n,n)) # add the error term
    end

    vc = collect(vc)
    vc = convert(Array{Array{Float64,2},1}, vc)


    if isempty(λgrid)
      λgrid = vcat(0.1:0.1:0.6,1.35,5,10)
    end

    if longitudinal
      Lasso = VClasso(y, X, vc, λfactor,false, λgrid)
    else
      λfactor = ones(Int,length(vc)-1)
      Lasso = VClasso(y, X, vc, λfactor,false, λgrid)
    end

    σ2 = Lasso[1][1:(end-1),:]
    nvc = [countnz(σ2[:,col]) for col=1:size(σ2,2)]
    k = nvc .+ size(X, 2)
    nloglik = Lasso[3]

    AIC = 2 * k - nloglik * 2
    BIC = log(n) * k - nloglik * 2

    σ2AIC = σ2[:,indmin(AIC)]
    vcAIC = vcname[σ2AIC.!=0] # output selected name and the estimates
    outAIC = hcat(vcAIC,σ2AIC[σ2AIC.!=0])

    σ2BIC = σ2[:,indmin(BIC)]
    vcBIC = vcname[σ2BIC.!=0] # output selected name and the estimates
    outBIC = hcat(vcBIC,σ2BIC[σ2BIC.!=0])

    if endswith(outpath,"/")
      outpath = outpath
    else
      outpath = string(outpath,"/")
    end

    writedlm(string(outpath,"vcest_all.txt"),σ2)
    writedlm(string(outpath,"loglik_all.txt"),hcat(λgrid,nloglik))

    if criterion == "None"
      return σ2, nloglik
    elseif criterion == "AIC"
      writedlm(string(outpath,"AIC_all.txt"),hcat(λgrid,AIC))
      writedlm(string(outpath,"vc_AIC_",λgrid[indmin(AIC)],".txt"),outAIC)
      return σ2, nloglik, AIC, outAIC
    elseif criterion == "BIC"
      writedlm(string(outpath,"BIC_all.txt"),hcat(λgrid,BIC))
      writedlm(string(outpath,"vc_BIC_",λgrid[indmin(BIC)],".txt"),outBIC)
      return σ2, nloglik, BIC, outBIC
    elseif criterion == "Both"
      writedlm(string(outpath,"AIC_BIC_all.txt"),hcat(λgrid,AIC,BIC))
      writedlm(string(outpath,"vc_AIC_",λgrid[indmin(AIC)],".txt"),outAIC)
      writedlm(string(outpath,"vc_BIC_",λgrid[indmin(BIC)],".txt"),outBIC)
      return σ2, nloglik, AIC, outAIC, BIC, outBIC
    end

  end
