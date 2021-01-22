--- 
title: "Reporting with Data in R"
author: "Christian McDonald"
date: "2021-01-21"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: utdata/rwdir
description: "Reporting with Data in R is a series of lessons and instructions used in courses in the School of Journalism, Moody College of Communication at the University of Texas at Austin. It is taught by Christian McDonald, assistant professor of practice."
---

# About this class {-}

> NOTE: This class is in the middle of a rewrite. The course is changing, as well as the pubished URL. Thing will break.

Reporting with Data in R is a series of lessons and instructions used in courses in the School of Journalism, Moody College of Communication at the University of Texas at Austin. It was taught by me, Christian McDonald.

There is a [companion Github repository](https://github.com/utdata/rwd-r-assignments) of mastery lessons that goes along with this book.

I'm a strong proponent of Scripted Journalism, a method of committing data-centric journalism in a programmatic, repeatable and transparent way. There are a myriad of programming languages that further this, including Python ([pandas](https://pandas.pydata.org/) and [Jupyter](https://jupyter.org/)) and JavaScript ([Observable](https://beta.observablehq.com/)), but we'll be using [R](https://www.r-project.org/), [RMarkdown](https://rmarkdown.rstudio.com/) and [RStudio](https://www.rstudio.com/).

R is a super powerful, open-source programming language for data that is deep with features and an awesome community of users who build upon it. No matter the challenge before you in your data storytelling, there is probably a package available to help you solve that challenge. Probably more than one.

## About this book {-}

There is always more than one way to do things in R. This book is a [Tidyverse](https://www.tidyverse.org/)-oriented opinionated collection of lessons intended to teach students new to progamming and R for the expressed act of committing journalism. As a beginner course, I strive to make it as simple as possible, which means I may not go into detail about alternative (and possibly better) ways to accomplish tasks in favor of staying in the Tidyverse and reducing options to simplify understanding.

This is the second version of this book. The first version was used in Spring 2019, and it was my first time to introduce R to beginning students. While the experience went well, there were pros and cons to using R in a beginning data class and I continue to experiment with material. I hope there learnings from that first attempt included in this book.

Since that class I've chosen to use a different web-based tool — [Workbench](http://workbenchdata.com/) — which allows for a similar scripted workflow but without the same level of coding. I still love that tool, but this is an attempt to get back into R at a beginner level.

## About the author {-}

I'm a career journalist who most recently served as Data and Projects Editor at the Austin American-Statesman before joining the University of Texas at Austin faculty full-time in Fall 2018. I've taught data-related course at UT since 2013.

- My UT Github: [utdata](https://github.com/utdata)
- My Personal Github: [critmcdonald](https://github.com/critmcdonald?tab=repositories)
- Twitter: [crit](https://twitter.com/crit)
- Email: <christian.mcdonald@utexas.edu>

## Other resources {-}

This text stands upon the shoulders of giants and by design does not cover all aspects of using R. Here are some other useful books, tutorials and sites dedicated to R. There are other task-specific tutorials and articles sprinkled throughout the book in the Resources section of select chapters. 

- [R Journalism Examples](https://utdata.github.io/r-journalism-examples/), a companion piece of sorts to this book with example code to accomplish specific tasks. It is a work-in-progress, and quite nascent at that.
- [R for Data Science](https://r4ds.had.co.nz/index.html) by Hadley Wickham and Garrett Grolemund.
- The [Tidyverse](https://www.tidyverse.org/) site, which has tons of documentation and help.
- The [RStudio Cheatsheets](https://www.rstudio.com/resources/cheatsheets/).
- [R Graphics Cookbook](https://r-graphics.org/index.html)
- [The R Graph Gallery](https://www.r-graph-gallery.com/) another place to see examples.
- [R for Journalists](http://learn.r-journalism.com/en/) site by Andrew Tran, a reporter at the Washington Post. A series of videos and tutorials on using R in a journalism setting.
- [Practical R for Journalism](https://www.crcpress.com/Practical-R-for-Mass-Communication-and-Journalism/Machlis/p/book/9781138726918) by Sharon Machlis, an editor with PC World and related publications, she is a longtime proponent of using R in journalism.
