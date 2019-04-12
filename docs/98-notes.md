# Notes about future sessions {-}

## Maps {-}

- Draw ideas from [this tutorial](https://workshop.mhermans.net/thematic-maps-r/) and Machlis.
- Andrew Tran's [mapping session from NICAR](https://github.com/andrewbtran/NICAR/tree/master/2019/mapping)
- [Leaflet & datatable](https://privefl.github.io/mySO/link-map-DT.html) integration example.

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

## More graphics ideas
- RStudio add in [esquisse](https://github.com/dreamRs/esquisse) with UI for easy ggplot graphics.
- [Plotly](https://plot.ly/r/) for interactive charts with hovers. There is also a [ggplot port](https://plot.ly/ggplot2/) that makes ggplot graphics interactive. It appears use of the open source library is free. When you get into publishing embeddable graphics, there is cost. 
- [ggirafe](https://davidgohel.github.io/ggiraph/articles/offcran/using_ggiraph.html) is yet another port to make **ggplot** interactive.

## Matt Waite's class for ggplot ideas {-}

### 06 has these {-}

- reorder
- introduce scales (same)
- add themes for styling. [more themes in the ggplot documentation](https://ggplot2.tidyverse.org/reference/ggtheme.html)
- Save as an png

### 07 has {-}

- stacked bar chart
- uses fill

### 08 has {-}

- uses [cfbstats]((http://www.cfbstats.com/2018/leader/national/team/offense/split01/category25/sort01.html) for data
- line chart
- adding average, highlight and annotations to line chart
- changing size of graphics with `repr` library to change the size of the graphic, but I'm not sure why.

### 09 {-}

Scatterplots using sports data

- Uses ggrepel to move labels from on top of points
- Uses a join to combine data
- Uses Pearson coefficient to note predective stat.

### 10: waffle {-}

- Uses sports data to make a [waffle chart](https://github.com/hrbrmstr/waffle), which is pretty cool. A better way than a pie chart to compare two values, or even multiples of a whole.

### 11 Facet wrap {-}

- uses line charts of a cfb stat over time to separate by team. Might use sports data to show this. Or, if I had something like school enrollment over time? Alcohol sales of specific bars?

### 12 is animate {-}

I can't get this to work. Not sure it is essential. We'll see.

### 13 is about zscores {-}

I dont want to go here.

### 14 more zscors {-}

I skipped it.

### 15 was soccer {-}

missing the data. might be in the repo now.

### 16 was themes {-}

This is good. I can use this, though I'm skipping the Illustrator part.

### 17 is residuals {-}

This is over my head.

### 18 is simulations {-}

This could be useful. Or not.

### 19 is tables as in formattables {-}

this is good. Might be better than tabyl.

[a helpful guide](https://www.displayr.com/formattable/)

### Waffle iron fixes {-}

Making waffle irons to PDF for Illustrator. Not important to me.
