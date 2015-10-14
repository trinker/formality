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
#'
#' plot(form1)
#' plot(with(presidential_debates_2012, formality(form1, list(person, time))))
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

    formal <- c('noun', 'preposition', 'adjective', 'article')
    contextual <- c('verb', 'pronoun', 'adverb', 'interjection')

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

    formal <- c('noun', 'preposition', 'adjective', 'article')
    contextual <- c('verb', 'pronoun', 'adverb', 'interjection')

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



#' Plots a Formality Object
#'
#' Plots a Formality object.
#'
#' @param x The Formality object
#' @param plot logical.  If \code{TRUE} the output is plotted.
#' @param \ldots ignored.
#' @return Returns a list of the three \pkg{ggplot2} objects that make the
#' combined plot.
#' @importFrom data.table :=
#' @method plot Formality
#' @export
plot.Formality <- function(x, plot = TRUE, ...){

    group.vars <- n <- warn <- contextual <- formal <- type <- NULL

    grps <- attr(x, "group.var")
    pos <- attr(x, "pos.vars")

    ## Prepare the pos data
    express1 <- paste0("lapply(list(", paste(pos, collapse=","), "), function(y) as.numeric(y/n))")
    express2 <- paste0("paste(", paste(grps, collapse=", "), ", sep = \"_\")")
    pos_dat <- x[, c(grps, pos, "n"), with=FALSE][,
        (pos) := eval(parse(text=express1))][,
        'group.vars' := eval(parse(text=express2))][,
        'group.vars' := factor(group.vars, levels=rev(group.vars))][,
        c(pos, "n", "group.vars"), with = FALSE]

    pos_dat_long <- data.table::melt(pos_dat, id = c("group.vars", "n"),
        variable.name = "pos", value.name = "proportion")[,
        pos := factor(pos, levels = attr(x, "pos.vars"))]

    ## prepare the formality data
    form_dat <- x[, c(grps, "n", "F"), with=FALSE][,
        'group.vars' := eval(parse(text=express2))][,
        'group.vars' := factor(group.vars, levels=rev(group.vars))][,
        c("group.vars", "n", "F"), with = FALSE][,
        warn := ifelse(n > 300, FALSE, TRUE)]

    ## prepare the contectual/formal data
    con_form_dat <- x[, c(grps, "contextual", "formal", "n"), with=FALSE][,
        (c("contextual", "formal")) := list(contextual/n, formal/n)][,
        'group.vars' := eval(parse(text=express2))][,
        'group.vars' := factor(group.vars, levels=rev(group.vars))][,
        c("contextual", "formal", "n", "group.vars"), with = FALSE]

    con_form_long <- data.table::melt(con_form_dat, id = c("group.vars", "n"),
        variable.name = "type", value.name = "proportion")[,
        type := factor(type, levels = c("formal", "contextual"))]

    con_form_plot <- ggplot2::ggplot(con_form_long,
        ggplot2::aes_string(x = "group.vars", weight = "proportion", fill ="type")) +
        ggplot2::geom_bar() +
        ggplot2::coord_flip() +
        ggplot2::xlab(NULL) +
        ggplot2::ylab("") +
        ggplot2::theme_bw() +
        ggplot2::theme(
            panel.grid = ggplot2::element_blank(),
            #legend.position="bottom",
            legend.title = ggplot2::element_blank(),
            panel.border = ggplot2::element_blank(),
            axis.line = ggplot2::element_line(color="grey70")
        ) +
        ggplot2::scale_y_continuous(labels=function(x) paste0(round(x*100, 0), "%"),
           expand = c(0,0)) +
        ggplot2::scale_fill_manual(values=pals[c(2, 6), 2])

    form_plot <- ggplot2::ggplot(form_dat,
        ggplot2::aes_string(y = "group.vars", x = "F")) +
        ggplot2::geom_point(ggplot2::aes_string(size="n"), alpha=.22) +
        ggplot2::scale_size(range=c(1, 7), name = "Text\nLength") +
        ggplot2::geom_point(ggplot2::aes_string(color="warn"), size=1.5) +
        ggplot2::scale_color_manual(values=c("black", "red"), guide=FALSE, drop=FALSE) +
        ggplot2::ylab(NULL) +
        ggplot2::xlab("F Measure") +
        ggplot2::theme_bw() +
        ggplot2::theme(
            #legend.position="bottom",
            axis.title.x = ggplot2::element_text(size=11),
            #legend.title = ggplot2::element_blank(),
            panel.border = ggplot2::element_blank(),
            axis.line = ggplot2::element_line(color="grey70")
        )

     pos_heat_plot <- ggplot2::ggplot(pos_dat_long,
        ggplot2::aes_string(y = "group.vars", x = "pos", fill="proportion")) +
        ggplot2::geom_tile() +
        ggplot2::scale_fill_gradient(
            labels=function(x) paste0(round(x*100, 0), "%"),
            high="#BF812D",
            low="white",
            name = ggplot2::element_blank()
        )+
        ggplot2::ylab(NULL) +
        ggplot2::xlab("Part of Speech") +
        ggplot2::theme_bw() +
        ggplot2::theme(
            panel.grid = ggplot2::element_blank(),
            #legend.position="bottom",
            axis.title.x = ggplot2::element_text(size=11),
            legend.title = ggplot2::element_blank(),
            panel.border = ggplot2::element_rect(color="grey88")
        ) +
        ggplot2::guides(fill = ggplot2::guide_colorbar(barwidth = .5, barheight = 10)) #+
        #ggplot2::guides(fill = ggplot2::guide_colorbar(barwidth = 14, barheight = .5))

    plotout1 <- gridExtra::arrangeGrob(con_form_plot, form_plot,
        widths = grid::unit(c(.5, .5), "native"), ncol=2)

    plotout2 <- gridExtra::arrangeGrob(plotout1, pos_heat_plot, ncol=1)
    if (isTRUE(plot)) gridExtra::grid.arrange(plotout2)
    return(invisible(list(formality = form_plot, contextual_formal = con_form_plot, pos = pos_heat_plot)))
}


pals <- structure(list(pos = c("noun", "adjective", "preposition", "article",
    "pronoun", "verb", "adverb", "interjection"), cols = c("#8C510A",
    "#BF812D", "#DFC27D", "#F6E8C3", "#C7EAE5", "#80CDC1", "#35978F",
    "#01665E")), .Names = c("pos", "cols"), row.names = c(NA, -8L
    ), class = "data.frame")



