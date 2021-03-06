% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gUtils.R
\name{\%o\%}
\alias{\%o\%}
\alias{\%o\%,GRanges-method}
\title{gr.val shortcut to total per interval width of overlap of gr1 with gr2, ignoring strand}
\usage{
x \%o\% ...
}
\arguments{
\item{x}{See \link{gr.val}}

\item{...}{See \link{gr.val}}
}
\value{
bases overlap of gr1 with gr2
}
\description{
Shortcut for gr.val (using val = names(values(y)))

gr1 %o% gr2
}
\author{
Marcin Imielinski
}
