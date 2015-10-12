#' Calculate Text Formality
#'
#' The \pkg{formality} package's main function is also titled \code{formality}
#' and uses Heylighen & Dewaele's (1999) \emph{F-measure}.  The \emph{F-measure}
#' is defined formally as:
#'
#' \deqn{F = 50(\frac{n_{f}-n_{c}}{N} + 1)}{F = 50(n_f-n_c/N + 1)}
#'
#' Where:
#'
#' \deqn{f = \left \{noun, \;adjective, \;preposition, \;article\right \}}{f = {noun,adjective, preposition, article}}
#' \deqn{c = \left \{pronoun, \;verb, \;adverb, \;interjection\right \}}{c = {pronoun, verb, adverb, interjection}}
#' \deqn{N = \sum{(n_{f}\;+ \;n_{c})}}{N = \sum(f + c)}
#' Please see the following resources for additional information:
#'
#' \itemize{
#' \item Heylighen, F. (1999). Advantages and limitations of formal expression. doi:10.1023/A:1009686703349
#' \item Heylighen, F. & Dewaele, J.-M. (1999). Formality of language: Definition, measurement and behavioral determinants. Center "Leo Apostel", Free University of Brussels. Retrieved from \url{http://pespmc1.vub.ac.be/Papers/Formality.pdf}
#' \item Heylighen, F. & Dewaele, J.-M. (2002). Variation in the contextuality of language: An empirical measure. \emph{Foundations of Science}, 7(3), 293-340. doi:10.1023/A:1019661126744
#' }
#' @docType package
#' @name formality
#' @aliases formality package-formality
NULL



#' 2012 U.S. Presidential Debates
#'
#' A dataset containing a cleaned version of all three presidential debates for
#' the 2012 election.
#'
#' @details
#' \itemize{
#'   \item person. The speaker
#'   \item tot. Turn of talk
#'   \item dialogue. The words spoken
#'   \item time. Variable indicating which of the three debates the dialogue is from
#' }
#'
#' @docType data
#' @keywords datasets
#' @name presidential_debates_2012
#' @usage data(presidential_debates_2012)
#' @format A data frame with 2912 rows and 4 variables
NULL



#' Sam I Am Text
#'
#' A dataset containing a character vector of the text from Seuss's 'Sam I Am'.
#'
#' @docType data
#' @keywords datasets
#' @name sam_i_am
#' @usage data(sam_i_am)
#' @format A character vector with 169 elements
#' @references Seuss, Dr. (1960). Green Eggs and Ham.
NULL
