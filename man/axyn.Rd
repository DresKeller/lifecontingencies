\name{axyn}
\alias{axyn}
\alias{Axyn}

\title{
Functions to evaluate life insurance and annuities on two heads.
}
\description{
These functions evalutates life insurances and annuities on two heads.
}
\usage{

axyn(tablex, tabley, x, y, n, i, m, k = 1, status = "joint", type = "EV")

Axyn(tablex, x, tabley, y, n, i, m, k = 1, status = "joint", type = "EV")
}

\arguments{

  \item{tablex}{
Life X \code{lifetable} object.
}
  \item{tabley}{
Life Y \code{lifetable} object.
}
  \item{x}{
Age of life X.
}
  \item{y}{
Age of life Y.
}
  \item{n}{
Insured duration. Infinity if missing.
}
  \item{i}{
Interest rate. Default value is those implied in \code{actuarialtable}.
}
  \item{m}{
Deferring period. Default value is zero.
}
  \item{k}{
Fractional payments or periods where insurance is payable.
}
  \item{status}{
Either "joint" or "last" survival status.
}
  \item{type}{
"immediate" or "due", annuities only.
}

}
\details{
Actuarial mathematics book formulas has been implemented with little testing available.
}
\value{
A numeric value representing APV of the chosen insurance.
}
\references{
	Actuarial Mathematics (Second Edition), 1997, by Bowers, N.L., Gerber, H.U., Hickman, J.C., 
	Jones, D.A. and Nesbitt, C.J.
}
\author{
Giorgio A. Spedicato
}
\note{
Further checkings is needed. E.g. Axyn does not return the correct value.
}

\section{Warning }{
	The function is provided as is, without any warranty regarding the accuracy of calculations. The author disclaims any liability for eventual 
	losses arising from direct or indirect use of this software.
}

\seealso{
\code{\link{pxyt}}
}
\examples{
	data(soa08Act)
	#last survival status annuity
	axyn(tablex=soa08Act, tabley=soa08Act, x=65, y=70, n=5,  status = "last", 
    type = "EV")
    #first survival status annuity
	
	Axyn(tablex=soa08Act, tabley=soa08Act, x=65, y=70,   status = "last", 
    type = "EV")
}