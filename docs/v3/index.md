--- 
title: "Reporting with Data in R"
author: "Christian McDonald and Josephine Lukito"
date: "2022-10-18"
site: bookdown::bookdown_site
output: bookdown::gitbook
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: utdata/rwdir
description: "Reporting with Data in R is a series of lessons and instructions used in courses in the School of Journalism and Media, Moody College of Communication at the University of Texas at Austin. The course is taught by Christian McDonald and Jo Lukito."
---

# About this book {-}

Reporting with Data in R is a series of lessons and instructions used for courses in the School of Journalism and Media, Moody College of Communication at the University of Texas at Austin. The first two versions of the book were written by Assistant Professor of Practice [Christian McDonald](https://moody.utexas.edu/faculty/christian-mcdonald). Assistant Professor [Jo Lukito](https://moody.utexas.edu/faculty/jo-lukito) joined in teaching sections of the Reporting with Data in spring 2022.

This means the book is morphing from the voice of a single author and that might get confusing at times. In addition, Prof. McDonald uses a Mac and Prof. Lukito uses a PC, so keyboard commands and screenshot examples may flip back and forth. We'll try to note the author and platform at the beginning of each chapter.

> **This work is under constant revision**. It is written in [bookdown](https://bookdown.org/) and the source is available on [Github](https://github.com/utdata/rwdir).

We are currently updating for the fall 2022 semester. Earlier versions are linked below.

## A word from Prof. McDonald {-}

I'm a strong proponent of what I call Scripted Journalism, a method of committing data-centric journalism in a programmatic, repeatable and transparent way. There are a myriad of programming languages that further this, including Python ([pandas](https://pandas.pydata.org/) using [Jupyter](https://jupyter.org/)) and JavaScript ([Observable](https://beta.observablehq.com/)), but we'll be using [R](https://www.r-project.org/), [RMarkdown](https://rmarkdown.rstudio.com/) and [RStudio](https://www.rstudio.com/).

R is a super powerful, open-source programming language for data that is deep with features and an awesome community of users who build upon it. No matter the challenge before you in your data storytelling, there is probably a package available to help you solve that challenge. Probably more than one.

There is always more than one way to do things in R. This book is a [Tidyverse](https://www.tidyverse.org/)-oriented, opinionated collection of lessons intended to teach students new to programming and R for the expressed act of committing journalism. As a beginner course, we strive to make it as simple as possible, which means we may not go into detail about alternative (and possibly better) ways to accomplish tasks in favor of staying in the Tidyverse and reducing options to simplify understanding. We rarely even discuss differences from base R; Tidyverse is our default.

## Tips on the book style {-}

We will try to be consistent in the way we write documentation and lessons. But we are human, so sometimes we break our own rules, but in general keep the following in mind.

### Things to do {-}

Things to DO are in ordered lists:

1. Do this thing.
2. Then do this thing.

Explanations are usually in text, like this very paragraph.

Sometimes details will be explained in lists:

- This is the first thing I want you to know.
- This is the second. You don't have to DO these things, just know about them.

### Notes, some important {-}

We will use the blockquote syntax to set off a less important aside:

> Markdown was developed by JOHN GRUBER, as outlined on his [Daring Fireball blog](https://daringfireball.net/projects/markdown/).

But sometimes those asides are important. We usually indicate that:

> **IMPORTANT:** You really should learn how to use [Rmarkdown](https://rmarkdown.rstudio.com/) as you will use it the whole semester, and hopefully for the rest of your life.

### Copy code blocks {-}

When you see R code in the instructions, you can roll your cursor over the right-corner and **click on the copy icon** to copy the code to your clipboard:

![](images/index-copy-clipboard.png)

You can then paste the code inside your R chunk.

That said, typing code yourself has many, many benefits. You learn better when you type yourself, make mistakes and have to fix them. **We encourage you to always type short code snippets.** Leave the copying to long ones.

## About the authors {-}

### Christian McDonald {-}

I'm a career journalist who most recently served as data and projects editor at the Austin American-Statesman before joining the University of Texas at Austin faculty full-time in fall 2018 as an assistant professor of practice. I've taught data-related course at UT since 2013. I also serve as the innovation director of the [Dallas Morning News Journalism Innovation Endowment](https://journalism.utexas.edu/innovation).

- The UT Data Github: [utdata](https://github.com/utdata)
- Twitter: [crit](https://twitter.com/crit)
- Email: <christian.mcdonald@utexas.edu>

### Jo Lukito {-}

I'm an aspiring-journalist-turned-academic who studies journalism and digital media. To make a long story short (tl;dr): I trained to be a journalist as an undergraduate student, but just fell in love with **researching and supporting** journalism. I completed my Ph.D in 2020, and my dissertation focused on international trade reporting (which relies on plenty o' data). I also do a ton of social media research (especially in politics and disinformation), so if you're interested in the social media beat, I'm your gal!

- Prof. Jo Lukito's git: [jlukito](https://github.com/jlukito)
- Twitter: [JosephineLukito](https://twitter.com/JosephineLukito)
- Email: <jlukito@utexas.edu>
- Website: [https://www.jlukito.com/](https://www.jlukito.com/)

## Versions {-}

The first version of this book from spring 2019 is buried somewhere in the commit history, but we've archived other recent editions:

- [Fall 2021](https://utdata.github.io/rwdir/v1/)
- [Spring 2022](https://utdata.github.io/rwdir/v2/)

## License {-}

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

Let's just say this is free on the internet. We don't make any money from it and you shouldn't either.

## Other resources {-}

This text stands upon the shoulders of giants and by design does not cover all aspects of using R. Here are some other useful books, tutorials and sites dedicated to R. There are other task-specific tutorials and articles sprinkled throughout the book in the Resources section of select chapters. 

- [R for Data Science](https://r4ds.had.co.nz/index.html) by Hadley Wickham and Garrett Grolemund.
- The [Tidyverse](https://www.tidyverse.org/) site, which has tons of documentation and help.
- The [RStudio Cheatsheets](https://www.rstudio.com/resources/cheatsheets/).
- [R Graphics Cookbook](https://r-graphics.org/index.html)
- [The R Graph Gallery](https://www.r-graph-gallery.com/) another place to see examples.
- [Practical R for Journalism](https://www.crcpress.com/Practical-R-for-Mass-Communication-and-Journalism/Machlis/p/book/9781138726918) by Sharon Machlis, an editor with PC World and related publications. Sharon is a longtime proponent of using R in journalism.
- [Sports Data Analysis and Visualization](http://mattwaite.github.io/sports/) and [Data Journalism with R and the Tidyverse](http://mattwaite.github.io/datajournalism/) by Matt Waite, a professor at the University of Nebraska-Lincoln.
- [R for Journalists](http://learn.r-journalism.com/en/) site by Andrew Tran, a reporter at the Washington Post and University of Texas alum. A series of videos and tutorials on using R in a journalism setting.