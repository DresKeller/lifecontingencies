\name{lifetable-class}
\Rdversion{1.1}
\docType{class}
\alias{lifetable-class}


\title{Class \code{"lifetable"}}
\description{
	Life table objects allow to define and use life table to evaluate survival probability, mortality rate easily.
	Such values represent building blocks to estimate life contingencies actuarial value.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("lifetable", ...)}.
Two vectors are needed. The age vector and the population at risk vector.
}
\section{Slots}{
  \describe{
    \item{\code{x}:}{Object of class \code{"numeric"}, representing the sequence 0,1,\eqn{\ldots, \omega-1}}
    \item{\code{lx}:}{Object of class \code{"numeric"}, representing a non increasing sequence of people living at beginning of year x. The last 
element of vector x is supposed to be > 0, as 0 is reached at age \eqn{\omega}	}
    \item{\code{name}:}{Object of class \code{"character"}, reporting the name of the table }
  }
}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "lifetable", to = "data.frame")}: method to create a data - frame from a lifetable object }
    \item{plot}{\code{signature(x = "lifetable")}: method to plot the survival probability implied in the table }
    \item{show}{\code{signature(object = "lifetable")}: identical to \code{plot} method }
	 }
}
\references{
	Actuarial Mathematics (Second Edition), 1997, by Bowers, N.L., Gerber, H.U., Hickman, J.C., 
	Jones, D.A. and Nesbitt, C.J.
}
\author{
	Giorgio A. Spedicato
}
\note{
	\code{t} may be missing in \code{pxt}, \code{qxt}, \code{ext}. It assumes value equal to 1 in such case.
}

\section{Warning }{
	The function is provided as is, without any warranty regarding the accuracy of calculations. The author disclaims any liability for eventual 
	losses arising from direct or indirect use of this software.
}

\seealso{
\code{\linkS4class{actuarialtable}}
}
\examples{
showClass("lifetable")
}
\keyword{classes}