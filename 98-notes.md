# Notes about future sessions {-}

## Maps {-}

- Andrew Tran's [mapping session from NICAR](https://github.com/andrewbtran/NICAR/tree/master/2019/mapping)
- [Geocoding package](https://github.com/trinker/mapit/blob/master/R/geo_code.R)

## Joins {-}

Add this as a short lesson on joining and merging files.

## Data packages {-}

Add a chapter that lists various data packages and such.

- [googledrive](https://googledrive.tidyverse.org/) to get data from Google Drive. Could do the perhaps do the ice cream and princess graphics.

### Twitter {-}

- [Slides](https://rtweet-workshop.mikewk.com/#1) from a [rtweets](https://github.com/mkearney/rtweet-workshop) package workshop. 

## Tools for PDFs {-}

`@abtran` says: In R, there are a handful of packages I cycle through depending on the quality of the PDFs:

- [tabulizer](https://cran.r-project.org/web/packages/tabulizer/vignettes/tabulizer.html) will detect tables, will let you set parameters for where to find the tables, or lets you interactively set the parameters. [Another example](https://rpubs.com/gd6/291026).
- sometimes the PDFs need to be OCR'd first, then I use [Tesseract's R bindings](https://cran.r-project.org/web/packages/tesseract/vignettes/intro.html).
- and finally there's [pdftools](https://ropensci.org/technotes/2018/12/14/pdftools-20/), which also extracts tables.
- here's a [video of Hadley Wickham](https://www.youtube.com/watch?v=tHszX31_r4s&feature=youtu.be&t=1298) scraping pdfs and turning the data into dataframes

## More graphics ideas {-}

- RStudio add in [esquisse](https://github.com/dreamRs/esquisse) with UI for easy ggplot graphics.
- [Plotly](https://plot.ly/r/) for interactive charts with hovers. There is also a [ggplot port](https://plot.ly/ggplot2/) that makes ggplot graphics interactive. It appears use of the open source library is free. When you get into publishing embeddable graphics, there is cost. 
- [ggirafe](https://davidgohel.github.io/ggiraph/articles/offcran/using_ggiraph.html) is yet another port to make **ggplot** interactive.

## Matt Waite ideas yet to incorporate {-}

- Uses sports data to make a [waffle chart](https://github.com/hrbrmstr/waffle), which is pretty cool. A better way than a pie chart to compare two values, or even multiples of a whole.
- [formattable](https://www.displayr.com/formattable/) could be useful. More features than tabyl.

