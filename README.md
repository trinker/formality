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
*formal* language is. Language is considered formal when it contains
much of the information directly in the text, whereas, contextual
language relies on shared experiences to more eficiently dialogue with
others. The *F-measure* is defined formally as:

*F* = 50(((*n*<sub>*f*</sub> − *n*<sub>*c*</sub>)/*N*) + 1)

Where:

*f* = {*n**o**u**n*, *a**d**j**e**c**t**i**v**e*, *p**r**e**p**o**s**i**t**i**o**n*, *a**r**t**i**c**l**e*}
  
*c* = {*p**r**o**n**o**u**n*, *v**e**r**b*, *a**d**v**e**r**b*, *i**n**t**e**r**j**e**c**t**i**o**n*}
  
*N* = *n*<sub>*f*</sub> + *n*<sub>*c*</sub>

-   Heylighen, F. (1999). Advantages and limitations of formal
    expression. Foundations of Science, 4, 25â<U+0080><U+0093>56.
    [<doi:10.1023/A:1009686703349>](http://link.springer.com/article/10.1023%2FA%3A1009686703349)
-   Heylighen, F. & Dewaele, J.-M. (1999). Formality of language:
    Deï¬nition, measurement and behavioral determinants. Center
    â<U+0080><U+009C>Leo Apostelâ<U+0080>, Free University of Brussels.
    Retrieved from
-   Heylighen, F. & Dewaele, J.-M. (2002). Variation in the
    contextuality of language: An empirical measure. Foundations of
    Science, 7(3), 293â<U+0080><U+0093>340.
    [<doi:10.1023/A:1019661126744>](http://link.springer.com/article/10.1023%2FA%3A1019661126744)


Table of Contents
============

-   [Installation](#installation)
-   [Contact](#contact)

Installation
============


To download the development version of **formality**:

Download the [zip
ball](https://github.com/trinker/formality/zipball/master) or [tar
ball](https://github.com/trinker/formality/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("trinker/formality")

Contact
=======

You are welcome to: 
* submit suggestions and bug-reports at: <https://github.com/trinker/formality/issues> 
* send a pull request on: <https://github.com/trinker/formality/> 
* compose a friendly e-mail to: <tyler.rinker@gmail.com>
