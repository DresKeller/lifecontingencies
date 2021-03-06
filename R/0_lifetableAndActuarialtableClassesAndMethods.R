# TODO: Add comment
# 
# Author: Giorgio Spedicato
###############################################################################

# need to set up Rcpp calls

#CLASSES DEFINITIONS



setClass("lifetable", #classe lifetable
		representation(x="numeric",lx="numeric",name="character"),
		prototype(x=c(0,1,2,3),
				lx=c(100,90,50,10),
				name="Generic life table"
		)
)
#actuarial classes
setClass("actuarialtable",
         representation=representation(interest="numeric"),
         contains="lifetable",
         prototype(x=c(0,1,2,3),
                   lx=c(100,90,50,10),
                   name="Generic actuarial table",
                   interest=0.03
         )
)

#METHODS DEFINITIONS

#constructor for lifetable object
# lifetable <- function(x = 0:3, lx = c(100,90, 50, 10), name = "Generic life table") {
#   if(length(x) != length(lx)) stop("length of x and lx must be equal")
#   
#   posToRemove <- which(lx %in% c(0,NA))
#   if(length(posToRemove) > 0) {
#     x <- x[-posToRemove]
#     lx <- lx[-posToRemove]
#   }
#   
#   # order by increasing value of x
#   o <- order(x)
#   x <- x[o]
#   lx <- lx[o]
#   
#   out <- new("lifetable", x = x, lx = lx, name = name)
#   return(out)
# }

setMethod(f="initialize",
          signature="lifetable",
          definition=function(.Object, x = 0:3, lx=c(100,90, 50, 10), name="Generic life table") {
            
            if(length(x) != length(lx)) stop("length of x and lx must be equal")
          
            posToRemove <- which(lx %in% c(0,NA))
            if(length(posToRemove) > 0) {
              x <- x[-posToRemove]
              lx <- lx[-posToRemove]
            }
            
            # order by increasing value of x
            o <- order(x)
            x <- x[o]
            lx <- lx[o]
            
            .Object@x <- x
            .Object@lx <- lx
            .Object@name <- name
            validObject(.Object)
            return(.Object)
          }
)


setMethod(f="initialize",
          signature="actuarialtable",
          definition=function(.Object, x = 0:3, lx=c(100,90, 50, 10), name="Generic life table", interest=0.03) {
            if(length(x) != length(lx)) stop("length of x and lx must be equal")
            
            posToRemove <- which(lx %in% c(0,NA))
            if(length(posToRemove) > 0) {
              x <- x[-posToRemove]
              lx <- lx[-posToRemove]
            }
            
            # order by increasing value of x
            o <- order(x)
            x <- x[o]
            lx <- lx[o]
            
            .Object@x <- x
            .Object@lx <- lx
            .Object@name <- name
            .Object@interest <- interest
            validObject(.Object)
            return(.Object)
          }
)


#validity method for lifetable object
setValidity("lifetable",
		function(object) {
			check <- character(0)
			if(length(object@x)!=length(object@lx)) 
			  check <- c(check, "x and lx do not match in length")
			if(any(diff(object@lx)>0)) 
			  check <- c(check, "lx must be non-increasing")
			if(any(abs(object@x - floor(object@x)) > 0))
			  check <- c(check, "x must be integral")
			if(any(object@x < 0))
			  check <- c(check, "x must be non-negative")
			if(any(diff(object@x) != 1))
			  check <- c(check, "x must be consecutive integers")
			
			if(length(check) == 0) 
			  return(TRUE) 
			else 
				return(check)
		}
)






#function to create lifetable cols
.createLifeTableCols<-function(object)
{
	omega<-length(object@lx)+1
	#vector used to obtain px
	lxplus<-object@lx[2:length(object@lx)]
	lxplus<-c(lxplus,0)
	#ex
	lenlx=length(object@lx)
	Tx=numeric(lenlx)
	Lx=numeric(lenlx)
	exni=numeric(lenlx)
	for(i in 1:lenlx) Tx[i]=sum(object@lx[i:lenlx])
	#for(i in 1:lenlx) Lx[i]=Lxt(object=object, x=i) # 1:lenlx prima object@x
	for(i in 1:lenlx) exni[i]=exn(object=object, x=i-1,type="curtate") #prima x=i e come sopra e c'era complete
	out<-data.frame(x=object@x, lx=object@lx,px=lxplus/object@lx, 
			ex=exni)
	#remove last row
	out<-out[1:(nrow(out)-1),]
	rownames(out)=NULL
	return(out)
}

#show method 4 lifetable: prints x, lx, px, ex
setMethod("show","lifetable", #metodo show
		function(object){
			cat(paste("Life table",object@name),"\n")
			cat("\n")
			
			out<-.createLifeTableCols(object)
			print(out)
			cat("\n")
		}
)

#show method 4 lifetable: prints x, lx, px, ex
setMethod("print","lifetable", #metodo show
		function(x){
			cat(paste("Life table",x@name),"\n")
			cat("\n")
			
			out<-.createLifeTableCols(x)
			print(out)
			cat("\n")
		}
)

#head and tail methods
setMethod("head",
		signature(x = "lifetable"),
		function (x, ...) 
		{
			temp<-data.frame(x=x@x, lx=x@lx)
			head(temp)
		}
)

#summary

setMethod("summary",
		signature(object="lifetable"),
		function (object, ...)
		{
			cat("This is lifetable: ",object@name, "\n","Omega age is: ",getOmega(object), "\n", "Expected curtated lifetime at birth is: ",exn(object))
		}
)

setMethod("summary",
		signature(object="actuarialtable"),
		function (object, ...)
		{
			cat("This is lifetable: ",object@name, "\n","Omega age is: ",getOmega(object), "\n", 
					"Expected curtated lifetime at birth is: ",exn(object),
					"Interest rate used is:",object@interest)
		}
)


#tail
setMethod("tail",
		signature(x = "lifetable"),
		function (x, ...) 
		{
			temp<-data.frame(x=x@x, lx=x@lx)
			tail(temp)
		}
)
#internal function to create the actuarial table object
.createActuarialTableCols<-function(object)
{
	omega<-length(object@lx)+1
	#vector used to obtain px
	lxplus<-object@lx[2:length(object@lx)]
	lxplus<-c(lxplus,0)
	#Dx
	Dx=object@lx*(1+object@interest)^(-object@x)
	lnDx=length(Dx)
	#Cx
	dx=object@lx-lxplus
	Cx=dx*(1+object@interest)^(-object@x-1)	
	#Nx
	Nx=numeric(length(Dx))
	for(i in 1:length(Dx)) Nx[i]=sum(Dx[i:lnDx])
	#Mx
	Mx=Dx-(object@interest/(1+object@interest))*Nx
	#Rx
	Rx=numeric(length(Mx))
	lnMx=length(Mx)
	for(i in 1:length(Rx)) Rx[i]=sum(Mx[i:lnMx])
	out<-data.frame(x=object@x, lx=object@lx, Dx=Dx, Nx=Nx, Cx=Cx,
			Mx=Mx, Rx=Rx)
	rownames(out)=NULL
	return(out)
	
}

setMethod("show","actuarialtable", #metodo show
		function(object){
			out<-NULL
			cat(paste("Actuarial table ",object@name, "interest rate ", object@interest*100,"%"),"\n")
			cat("\n")
			#create the actuarial table object
			out<-.createActuarialTableCols(object=object)
			print(out)
			cat("\n")
		}
)

#print method: show clone

setMethod("print","actuarialtable", #metodo show
		function(x){
			out<-NULL
			cat(paste("Actuarial table ",x@name, "interest rate ", 
							x@interest*100,"%"),"\n")
			cat("\n")
			#create the actuarial table object
			out<-.createActuarialTableCols(object=x)
			print(out)
			cat("\n")
		}
)


setMethod("plot","lifetable",
		function(x,y,...){
			plot(x=x@x, y=x@lx, xlab="x values", 
					ylab="population at risk", 
					main=paste("life table",x@name),...)
		}
)
#saves lifeTableObj as data frame
setAs("lifetable","data.frame",
		function(from){
			out<-.createLifeTableCols(object=from)
			return(out)
		}
)

#get a data.frame containing x and lx and returns a new lifetable object
setAs(from="data.frame",to="lifetable",
		def=function(from){
			if(any(is.na(match(c("x","lx"), names(from))))) stop("Error! Both x and lx columns required!")
			from<-from[complete.cases(from),]
			out<-new("lifetable",x=from$x, lx=from$lx, name="COERCED")
			return(out)
		}
)

#saves actuarialtable as data frame (have same slots as life - table)
setAs("actuarialtable","data.frame",
		function(from){
			out<-.createActuarialTableCols(object=from)
			return(out)
		}
)

#coerce methods to numeric

setAs("lifetable","numeric",
		function(from) {
			out<-numeric(getOmega(from)+1)
			for(i in 0:getOmega(from)) out[i+1]<-qxt(object=from,x=i,t=1)
			return(out)
		}
)

setAs("actuarialtable","numeric",
		function(from) {
			out<-numeric(getOmega(from))
			for(i in 0:(getOmega(from)-2)) out[i+1]<-Axn(actuarialtable=from,x=i)
			return(out)
		}
)

#demographic classes and methods

#setGeneric("pxt", function(object) standardGeneric("pxt"))
#setGeneric("qxt", function(object) standardGeneric("qxt"))