# Import {#import}

> Draft

## Goals of this lesson

- Practice organized project setup.
- Learn a little about data types available to R.
- Learn about R packages, how to install and import them.
- Learn how to download and import CSV files using the [readr]() package.
- Introduce the Data Frame/Tibble.
- Introduce the tidyverse ` %>% `.

We'll be exploring the Billboard Hot 100 charts along the way. Eventually you will filter, select, group_by and summarize. We'll also have have a short writing assignment.

## Create a new project

We did this in our first lesson, but here are the basic steps:

- Launch RStudio
- Use the `+R` button to create a **New Project** in a **New Directory**
- Name the project `yourfirstname-special-ed` and put it in your `~/Documents/rwd` folder.
- Use the `+` button to use **R Notebook** to start a new notebook.
- Change the title to "Billboard Hot 100".
- Delete the other boilerplate text.
- Save the file as `01-import.Rmd`.

### The R Package environment

We have to back up from the step-by-step nature of this lesson and talk a little about the R programming language.

R is an open-source language, which means that other programmers can contribute to how it works. It is what makes R beautiful.

What happens is developers will find it difficult to do a certain task, so they will write an R "Package" of code that helps them with that task. They share that code with the community, and suddenly the R garage has an ["ultimate set of tools"](https://youtu.be/Y1En6FKd5Pk?t=24) that would make Spicoli's dad proud. 

One set of these tools is Hadley Wickham's [Tidyverse](https://www.tidyverse.org/), a set of packages for data science. These are the tools we will use most in this course. While not required reading, I highly recommend Wickham's book [R for data science](https://r4ds.had.co.nz/index.html), which is free. We'll use some of Wickham's lectures in the course.

There are also a series of useful [cheatsheets](https://www.rstudio.com/resources/cheatsheets/) that can help you as you use the packages and functions from the tidyverse. We'll refer to these throughout the course.

### Installing and using packages

There are two steps to using an R package:

- **Install the package** using `install.packages("package_name"). You only have to do this once for each computer, so I usually do it using the R Console instead of in notebook.
- **Include the library** using `library(package_name)`. This has to be done for each Notebook or script that uses it, so it is usually one of the first things in the notebook.

We're going to install several packages we will use in the ratings project. To do this, we are going to use the **Console**, which we haven't talked about much yet.

![The Console and Terminal](images/import-console.png){width=600px}

- Use the image above to orient yourself to the R Console and Terminal.
- In the Console, type in:

```r
install.packages("tidyverse")
```

As you type into the Console, you'll see some type-assist hints on what you need. You can use the arrow keys to select one and hit Tab to complete that command, then enter the values you need.

- If it asks you to install "from source", type `Yes` and hit return.

You'll see a bunch of response in the Console.

We'll need another package, so also do:

```r
install.packages("janitor")
```

We'll use some commands from janitor to clean up our data column names, among other things. A good reference to learn more is the [janitor vignette](https://cran.r-project.org/web/packages/janitor/vignettes/janitor.html).

You only have to install the packages once on your computer (though you have to load them every time, which is explained below).

### Load the libraries

Next, we're going to tell our R Notebook to use these two libraries.

- After the metadata at the top of your notebook, use *Cmd+option+i* to insert an R code chunk.
- In that chunk, type in the two libraries and run the code block with *Cmd+Shift+Return*.

This is the code you need:


```r
library(tidyverse)
library(janitor)
```

Your output will look something like this:

![Libraries imported](images/import-libraries.png){width=600px}



## Overview of the assignment

We'll be using the Billboard Hot 100 charts data to find the answers to the following questions:

1. Who are the 10 Artists with the most appearances on the Hot 100 chart at any position?
2. Which Artist had the most Titles to reach No. 1?
3. Which Artist had the most Titles to reach No. 1 in the most recent five years?
4. Who had the most Top 10 hits overall?
5. Which Artist/Title combination has been on the charts the most number of weeks at any position?
6. Which Artist/Title combination was No. 1 for the most number of weeks?

FOOD FOR THOUGHT: What are your guesses for the questions above? No peeking!

## Our project data

Billboard's Weekly Hot 100 singles chart between 8/2/1958 through 2020. It is a modified version of data compiled by SEAN MILLER and posted on data.world. Some columns were removed to reduce file size, and columns were renamed.

You should source the data the Billboard Hot 100 from Billboard Media, since that is where the data comes from via an API.

## Data dictionary

This dataset contains every weekly Hot 100 singles chart from Billboard.com. **Each row of data represents a song and the corresponding position on that week's chart.** Included in each row are the following elements:

- date: Date of chart release
- current: Position on chart for the week
- title: The song name
- artist: The performer name
- previous: The previous week's position as of the chart date
- peak: Top position on chart as of the chart date
- weeks: Number of weeks on chart as of the chart date

