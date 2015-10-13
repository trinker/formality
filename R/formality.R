#' Formality Score
#'
#' Formality score by grouping variable(s).
#'
#' @param text.var The text string variable or another \code{formality} object.
#' The latter recycles the part of speech tagging and is much faster.
#' @param grouping.var The grouping variable(s).  Default \code{NULL} generates
#' one word list for all text.  Also takes a single grouping variable or a list
#' of 1 or more grouping variables.  If \code{TRUE} an \code{id} variable is
#' used with a \code{seq_along} the \code{text.var}.
#' @param order.by.formality logical.  If \code{TRUE} orders the results
#' descending by formality score.
#' @param \ldots ignored.
#' @section Warning: Heylighen & Dewaele (2002) state, "At present, a sample would
#' probably need to contain a few hundred words for the measure to be minimally
#' reliable. For single sentences, the F-value should only be computed for
#' purposes of illustration" (p. 24).
#' @details Heylighen & Dewaele(2002)'s formality \emph{F-measure} is defined
#' formally as:
#'
#' \deqn{F = 50(\frac{n_{f}-n_{c}}{N} + 1)}{F = 50(n_f-n_c/N + 1)}
#'
#' Where:
#'
#' \deqn{f = \left \{noun, \;adjective, \;preposition, \;article\right \}}{f = {noun,adjective, preposition, article}}
#' \deqn{c = \left \{pronoun, \;verb, \;adverb, \;interjection\right \}}{c = {pronoun, verb, adverb, interjection}}
#' \deqn{N = \sum{(n_{f}\;+ \;n_{c})}}{N = \sum(f + c)}
#'
#' This yields an \emph{F-measure} between \eqn{0} and \eqn{100}\%, with
#' completely contextualizes language on the zero end and completely formal
#' language on the \eqn{100} end.
#' @references Heylighen, F. (1999). Advantages and limitations of formal expression. doi:10.1023/A:1009686703349 \cr \cr
#' Heylighen, F. & Dewaele, J.-M. (1999). Formality of language: Definition, measurement and behavioral determinants. Center "Leo Apostel", Free University of Brussels. Retrieved from \url{http://pespmc1.vub.ac.be/Papers/Formality.pdf} \cr \cr
#' Heylighen, F. & Dewaele, J.-M. (2002). Variation in the contextuality of language: An empirical measure. \emph{Foundations of Science}, 7(3), 293-340. doi:10.1023/A:1019661126744
#' @keywords formality
#' @importFrom data.table :=
#' @export
#' @examples
#' data(presidential_debates_2012)
#' (form1 <- with(presidential_debates_2012, formality(dialogue, person)))
#' with(presidential_debates_2012, formality(form1, list(person, time))) #recycle form 1 for speed
formality <- function(text.var, grouping.var = NULL, order.by.formality = TRUE, ...){

    UseMethod("formality")

}

#' @export
#' @method formality default
formality.default <- function(text.var, grouping.var = NULL, order.by.formality = TRUE, ...){

    .SD <- n <- F <- NULL

    if(is.null(grouping.var)) {
        G <- "all"
    } else {
        if (is.list(grouping.var)) {
            m <- unlist(as.character(substitute(grouping.var))[-1])
            G <- sapply(strsplit(m, "$", fixed=TRUE), function(x) {
                    x[length(x)]
                }
            )
        } else {
            if (isTRUE(grouping.var)) {
                G <- "id"
            } else {
                G <- as.character(substitute(grouping.var))
                G <- G[length(G)]
            }
        }
    }
    if(is.null(grouping.var)){
        grouping <- rep("all", length(text.var))
    } else {
        if (isTRUE(grouping.var)) {
                grouping <- seq_along(text.var)
        } else {
            if (is.list(grouping.var) & length(grouping.var)>1) {
                grouping <- grouping.var
            } else {
                grouping <- unlist(grouping.var)
            }
        }
    }

    formal <- c('noun', 'adjective', 'preposition', 'article')
    contextual <- c('pronoun', 'verb', 'adverb', 'interjection')

    ## in other version this will be extracted
    #=============================================
    counts <- tagger::count_tags(tagger::as_basic(tagger::tag_pos(text.var)))
    data.table::setDT(counts)
    forms <- formal[formal %in% colnames(counts)]
    contexts <- contextual[contextual %in% colnames(counts)]
    cols <- c(forms, contexts)

    ## quoting for use in the data.table
    forms_exp <- parse(text=paste(forms, collapse=" + "))[[1]]
    contexts_exp <- parse(text=paste(contexts, collapse=" + "))[[1]]

    counts <- counts[, cols, with = FALSE][, formal := eval(forms_exp)][, contextual := eval(contexts_exp)]

    #=============================================
    ## in other version this will be extracted

    formality_counts <- new.env(hash=FALSE)
    formality_counts[["counts"]] <- counts

    counts <- cbind(
        data.table::as.data.table(stats::setNames(data.frame(grouping, stringsAsFactors = FALSE), G)),
        counts
    )

    out <- counts[, lapply(.SD, sum, na.rm = TRUE), keyby = G][,
        n := formal + contextual][,
        F := 50*(((formal - contextual)/(n))+1)]

    if (isTRUE(order.by.formality)){
        data.table::setorder(out, -F)
    }

    class(out) <- c("Formality", class(out))
    attributes(out)[["group.vars"]] <- G
    attributes(out)[["pos.vars"]] <- cols
    attributes(out)[["counts"]] <- formality_counts
    out

}


#' @export
#' @method formality Formality
formality.Formality <- function(text.var, grouping.var = NULL, order.by.formality = TRUE, ...){

    .SD <- n <- F <- NULL

    if(is.null(grouping.var)) {
        G <- "all"
    } else {
        if (is.list(grouping.var)) {
            m <- unlist(as.character(substitute(grouping.var))[-1])
            G <- sapply(strsplit(m, "$", fixed=TRUE), function(x) {
                    x[length(x)]
                }
            )
        } else {
            if (isTRUE(grouping.var)) {
                G <- "id"
            } else {
                G <- as.character(substitute(grouping.var))
                G <- G[length(G)]
            }
        }
    }
    if(is.null(grouping.var)){
        grouping <- rep("all", length(text.var))
    } else {
        if (isTRUE(grouping.var)) {
                grouping <- seq_along(text.var)
        } else {
            if (is.list(grouping.var) & length(grouping.var)>1) {
                grouping <- grouping.var
            } else {
                grouping <- unlist(grouping.var)
            }
        }
    }

    formal <- c('noun', 'adjective', 'preposition', 'article')
    contextual <- c('pronoun', 'verb', 'adverb', 'interjection')

    counts <- attributes(text.var)[["counts"]][["counts"]]

    counts <- cbind(
        data.table::as.data.table(stats::setNames(data.frame(grouping, stringsAsFactors = FALSE), G)),
        counts
    )

    out <- counts[, lapply(.SD, sum, na.rm = TRUE), keyby = G][,
        n := formal + contextual][,
        F := 50*(((formal - contextual)/(n))+1)]

    if (isTRUE(order.by.formality)){
        data.table::setorder(out, -F)
    }

    class(out) <- c("Formality", class(out))
    attributes(out)[["group.vars"]] <- G
    attributes(out)[["pos.vars"]] <- attributes(text.var)[["pos.vars"]]
    attributes(out)[["counts"]] <- attributes(text.var)[["counts"]][["counts"]]
    out

}
