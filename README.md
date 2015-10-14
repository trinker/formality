formality
============


[![Project Status: Wip - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](http://www.repostatus.org/badges/0.1.0/wip.svg)](http://www.repostatus.org/#wip)
[![Build
Status](https://travis-ci.org/trinker/formality.svg?branch=master)](https://travis-ci.org/trinker/formality)
[![Coverage
Status](https://coveralls.io/repos/trinker/formality/badge.svg?branch=master)](https://coveralls.io/r/trinker/formality?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
<img src="inst/formality_logo/r_formality.png" width="300" alt="tagger Logo">

**formality** utilizes the
[**tagger**](https://github.com/trinker/tagger) package to conduct
formality analysis. Heylighen (1999) and Heylighen & Dewaele (2002,
1999) have given the *F-measure* as a measure of how *contextual* or
*formal* language is. Language is considered more formal when it
contains much of the information directly in the text, whereas,
contextual language relies on shared experiences to more efficiently
dialogue with others.


Table of Contents
============

-   [Formality Equation](#formality-equation)
-   [Installation](#installation)
-   [Contact](#contact)
-   [Examples](#examples)
    -   [Load the Tools/Data](#load-the-toolsdata)
    -   [Assessing Formality](#assessing-formality)
    -   [Recycling the First Run](#recycling-the-first-run)

Formality Equation
============


The **formality** package's main function is also titled `formality` and
uses Heylighen & Dewaele's (1999) *F-measure*. The *F-measure* is
defined formally as:

*F* = 50(((*n*<sub>*f*</sub> − *n*<sub>*c*</sub>)/*N*) + 1)

Where:

*f* = {*n**o**u**n*, *a**d**j**e**c**t**i**v**e*, *p**r**e**p**o**s**i**t**i**o**n*, *a**r**t**i**c**l**e*}
  
*c* = {*p**r**o**n**o**u**n*, *v**e**r**b*, *a**d**v**e**r**b*, *i**n**t**e**r**j**e**c**t**i**o**n*}
  
*N* = *n*<sub>*f*</sub> + *n*<sub>*c*</sub>

This yields an *F-measure* between 0 and 100%, with completely
contextualized language on the zero end and completely formal language
on the 100 end.

Please see the following references for more details about formality and
the *F-measure*:

-   Heylighen, F. (1999). Advantages and limitations of formal
    expression. Foundations of Science, 4, 25-56.
    <a href="http://link.springer.com/article/10.1023%2FA%3A1009686703349">doi:10.1023/A:1009686703349</a>
-   Heylighen, F. & Dewaele, J.-M. (1999). Formality of language:
    Definition, measurement and behavioral determinants. Center "Leo
    Apostel", Free University of Brussels. Retrieved from
    [<http://pespmc1.vub.ac.be/Papers/Formality.pdf>](http://pespmc1.vub.ac.be/Papers/Formality.pdf)
-   Heylighen, F. & Dewaele, J.-M. (2002). Variation in the
    contextuality of language: An empirical measure. Foundations of
    Science, 7(3), 293-340.
    <a href="http://link.springer.com/article/10.1023%2FA%3A1019661126744">doi:10.1023/A:1019661126744</a>

Installation
============

To download the development version of **formality**:

Download the [zip
ball](https://github.com/trinker/formality/zipball/master) or [tar
ball](https://github.com/trinker/formality/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh(c(
        "trinker/termco", 
        "trinker/tagger", 
        "trinker/formality"
    ))

Contact
=======

You are welcome to: 
* submit suggestions and bug-reports at: <https://github.com/trinker/formality/issues> 
* send a pull request on: <https://github.com/trinker/formality/> 
* compose a friendly e-mail to: <tyler.rinker@gmail.com>


Examples
========

The following examples demonstrate some of the functionality of
**formality**.

Load the Tools/Data
-------------------

    library(formality)
    data(presidential_debates_2012)

Assessing Formality
-------------------

`formality` takes the text as `text.var` and any number of grouping
variables as `grouping.var`. Here we use the `presidential_debates_2012`
data set and look at the formality of the people involved. Note that for
smaller text Heylighen & Dewaele (2002) state:

> At present, a sample would probably need to contain a few hundred
> words for the measure to be minimally reliable. For single sentences,
> the F-value should only be computed for purposes of illustration" (p.
> 24).

    form1 <- with(presidential_debates_2012, formality(dialogue, person))
    form1

    ##       person noun adjective preposition article pronoun verb adverb
    ## 1:  QUESTION  155        70          91      38      77  112     26
    ## 2:    LEHRER  182        93         104      62     101  164     48
    ## 3: SCHIEFFER  347       176         209     102     211  342     69
    ## 4:    ROMNEY 4406      2346        3178    1396    2490 4676   1315
    ## 5:     OBAMA 3993      1935        2909    1070    2418 4593   1398
    ## 6:   CROWLEY  387       135         269     104     249  405    134
    ##    interjection formal contextual     n        F
    ## 1:            4    354        219   573 61.78010
    ## 2:            8    441        321   762 57.87402
    ## 3:            0    834        622  1456 57.28022
    ## 4:           25  11326       8506 19832 57.10972
    ## 5:           13   9907       8422 18329 54.05096
    ## 6:            0    895        788  1683 53.17885

Recycling the First Run
-----------------------

This will take ~20 seconds because of the part of speech tagging that
must be undertaken. The output can be reused as `text.var` cutting the
time to a fraction of the first run.

    with(presidential_debates_2012, formality(form1, list(time, person)))

    ##       time    person noun adjective preposition article pronoun verb
    ##  1: time 2  QUESTION  155        70          91      38      77  112
    ##  2: time 1    LEHRER  182        93         104      62     101  164
    ##  3: time 1    ROMNEY  950       483         642     286     504  978
    ##  4: time 3    ROMNEY 1766       958        1388     617    1029 1920
    ##  5: time 3 SCHIEFFER  347       176         209     102     211  342
    ##  6: time 2    ROMNEY 1690       905        1148     493     957 1778
    ##  7: time 3     OBAMA 1546       741        1185     432     973 1799
    ##  8: time 1     OBAMA  792       357         579     219     452  925
    ##  9: time 2     OBAMA 1655       837        1145     419     993 1869
    ## 10: time 2   CROWLEY  387       135         269     104     249  405
    ##     adverb interjection formal contextual    n        F
    ##  1:     26            4    354        219  573 61.78010
    ##  2:     48            8    441        321  762 57.87402
    ##  3:    240            4   2361       1726 4087 57.76853
    ##  4:    536           10   4729       3495 8224 57.50243
    ##  5:     69            0    834        622 1456 57.28022
    ##  6:    539           11   4236       3285 7521 56.32230
    ##  7:    522            4   3904       3298 7202 54.20716
    ##  8:    281            2   1947       1660 3607 53.97838
    ##  9:    595            7   4056       3464 7520 53.93617
    ## 10:    134            0    895        788 1683 53.17885