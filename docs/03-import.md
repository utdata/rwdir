# Importing data {#import}

## Goals of this section

- Learn a little about data types available to R.
- Practice organized project setup.
- Learn about R packages, how to install and import them.
- Learn how to import CSV files.
- Introduce the Data Frame/Tibble.

We are going to do this through working with well drilling reports from the Texas Water Development board. We'll pull reports from counties in the Austin MSA and be able to see the kinds of wells dug, where they are the pace of drilling.

## Data types

After installing and launching RStudio, the next trick is to import data. Depending on the data source, this can be brilliantly easy or a pain in the rear. It all depends on how well-formatted is the data.

In this class, we will primarily be importing Excel files, CSVs (Comma Separated Value) and APIs (Application Programming Interface).

- CSVs are a kind of lowest-common-denominator for data. Most any database or program can import or export them.
- Excel files are good, but are often messy because humans get involved. There are often multiple header rows, columns used in multiple ways, notes added, etc. Just know you might have to clean them up before using them.
- APIs are systems designed to respond to programming. In the data world, we often use the APIs by writing a query to ask a system to return a selection of data. By definition, the data is well structured. You can often determine the file type of the output as part of the API call, including ...
- JSON (or JavaScript Object Notation) is the data format preferred by JavaScript. R can read it, too. It is often the output format of APIs, and prevalent enough that you need to understand how it works. We'll get into it more later.

Don't get me wrong ... there are plenty of other data types and connections available through R, but those are the ones we'll deal with most in the class.

### What is clean data

The Checking Your Data section of this [DataCamp tutorial](https://www.datacamp.com/community/tutorials/r-data-import-tutorial) has a good outline of what makes good data, but in general it should:

- Have a single header row with well-formed column names.
    + Once column name for each column. No merged cells.
    + Short names are better than long ones.
    + Space are bad. Use and `_` or `.` between words.
- Remove notes or comments from the files.
- Each column should have the same kind of data: numbers vs words, etc.
- Each row should be an 

In our first lesson, we'll be using a CSV file that has several rows of description at the top. We'll be able to skip those description lines when we import.

## Create a new project

We did this in our first lesson, but here are the basic steps:

- Launch RStudio
- Use the `+R` button to create a **New Project** in a **New Directory**
- Name the project `yourfirstname-wells` and put it in your `~/Documents/rwd` folder.
- Use the `+` button to use **R Notebook** to start a new notebook.
- Change the title to "Wells drilled in Austin MSA".
- Delete the other boilerplate text.
- Save the file as `01-wells-import.Rmd`.

### The R Package environment

We have to back up from the step-by-step nature of this lesson and talk a little about the R programming language.

R is an open-source language, which means that other programmers can contribute to how it works. It is what makes R beautiful.

What happens is developers will find it difficult to do a certain task, so they will write an R "Package" of code that helps them with that task. They share that code with the community, and suddenly the R garage has an ["ultimate set of tools"](https://youtu.be/Y1En6FKd5Pk?t=24)" that would make Spicoli's dad proud. 

One set of these packages is Hadley Wickham's [Tidyverse](https://www.tidyverse.org/), a set of packages for data science. These are the tools we will use most in this course. While not required reading, I highly recommend Wickham's book [R for data science](https://r4ds.had.co.nz/index.html), which is free. We'll use some of Wickham's lectures in the course.

### Installing and using packages

There are two steps to using an R package:

- **Install the package** using `install.packages("package_name")`. You only have to do this once, so I usually do it using the R Console instead of a script.
- **Include the library** using `library(package_name)`. This has to be done for each Notebook or script that uses it, so it is usually one of the first things.

We're going to install several packages we will use in the Wells project. To do this, we are going to use the **Console**, which we haven't talked about much.

![The Console and Terminal](images/import-console.png){width=600px}

- Use the image above to orient yourself to the R Console and Terminal.
- In the console, type in `install.packages("tidyverse")` and hit return.

You'll a bunch of commands work through your Console. Remember that you only have to install a package to your computer once.

We'll need another package, so also do:

```r
install.packages("janitor")
```

We'll use some commands from janitor to clean up our data column names.


### Load the libraries

Next, we're going to tell our R Notebook to use these two libraries.

- After the metadata at the top of your notebook, use *Cmd+option+i* to insert an R code chunk.
- In that chunk, type in the two libraries and run the code block with *Cmd+shift+Return*.

It will look like this:

![Libraries imported](images/import-libraries.png){width=600px}


## Let's get some data

I could've supplied you with the raw data, but it is not hard to find and grab yourself, so let's do that.

Because I want you to teach you good data project skills, I want you first to make a folder to store your raw data. It's good practice to separate your raw data from any other output or data. It make it easy for others to find, and can help you avoid overwriting that raw data, which should remain a pristine copy.

- In the **Files** pane, use the **New Folder** button to create a folder called `data-raw`. (I typically make a `data-out` or similar folder for any files that I create.)
- In a web browser, go to the [Texas Water Development Board Driller Reports](http://www.twdb.texas.gov/groundwater/data/drillersdb.asp) page and then click on the **Well Reports Search by County and Use** link.
- In the **County** drop down, choose: Bastrop, Caldwell, Hays, Travis and Williamson counties.
- In the **Proposed Use** column, choose **Select All*.
- Click **View Reports**. You get 400+ returns.
- Look for the floppy disk/arrow icon that is the download button. Choose **CSV (comma delimited)**.

That file should end up in your Downloads folder. Use your finder to move this into your project folder in the `data-raw` folder you created.

[This document](http://www.twdb.texas.gov/groundwater/data/doc/TWRSRS_UserManual.pdf?d=43539.49999999895) has some descriptions of fields we may need later.

### Inspect the data

We want to look at the data so we understand it.

- In the **Files** pane, click on the `data-raw` folder to open in.
- Click on the `WellsRpts_County_Use.csv` file until you get the drop down that says View Files.

![View file](images/import-inspectdata.png){width=400px}

- When you choose that, you'll get a warning that it is a big file. It _should_ open it just fine, into a new window. It will look like this:

![Wells file](images/import-wellsfile.png){width=600px}

The numbers on the left are row numbers in the file. Because lines will wrap in your window, those numbers let you know where each line starts.

Note that the real header for this file starts as line `5`, which means when we import this file, we need to skip the first four lines.

You can close this file now.

## Import csv

- Now we need to start adding some text to indicate what we are doing, which right now we are importing the file. So, write some text in Markdown that describes where the data came from and what it is.
    + Write where the data came from. Include the link to the web page.
    + Include which counties were included, and which 
- After your descriptions, add a new code chunk (*Cmd+option+i*).
- Inside the chuck, add the following and hit return, then I'll explain:

```r
wells_raw <- read_csv("data-raw/WellRpts_County_Use.csv")
wells_raw
```

- `wells_raw` is the data frame we are creating. It is the object that holds our data. We can call the variable whatever we want, but you should always use words that make sense. They can't have spaces, which is why we are using the underscore `_` character between words.
- `<-` is the operator that says we are putting the stuff on the right (our data) into the variable. It's like we are pointing the stuff from the right into the left.
- `read_csv` is the function we are using the load the data. This version from the **readr** package in the tidyverse is different from `read.csv` that comes with R. It is mo betta.
- Inside the parenthesis is the path to our data, inside quotes. If you start typing in that path and hit tab, it will complete the path. (Easier to show than explain).
- The last line is printing out the data frame, which is a bit of a trash fire at the moment.

What went wrong? Remember that our data doesn't really start until line five. We need to modify our import to skip the first for lines. But how does we find out how to do that? Help is on the way!!

### Help files

Another tab over by your **Files** pane is the **Help** pane.

- Click on the **Help** pane
- In the search box, type in `read_csv` and hit Return.

What you get in return is information about that function. Any function loaded into RStudio also comes with these help files. The documentation style might look foreign at first, but you'll get used to reading them.

If we look through this one, we can see there is a `skip = x` option we can add to our import to skip lines.

- Modify the import line to this and then rerun the entire chunk with *Cmd+shift+Return*:

```r
wells_raw <- read_csv("data-raw/WellRpts_County_Use.csv", skip = 3)
```

I first tried `skip = 4`, but then it didn't properly use the header row, perhaps because the readr package skips empty rows by default.

Because there are two types of output in this code chunk, the notebook returns two square icons to choose between them.

- The first result shows what columns were imported and the data types. It's important to review these to make sure things happened the way that you want. Some things to watch for:
    + Are numbers actually numbers or characters?
    + Have integers been imported as double numbers or vice verse?
    + Are there numbers that should be strings, like ZIP codes?
    + Are dates imported properly?
- The second result prints out the data like a table. The data object is called a [Tibble](https://tibble.tidyverse.org/), which is a fancy version of a data frame that is part of the tidyverse. I will often call a tibble a "data frame", which is the generic R from of this data structure. Think of data frames and tibbles like a well-structured table in a spreadsheet. They are organized rows of data with columns where every item in the column is of the same data type.

In short, it is our data. Take a look at the columns and inspect them. Note the column type is listed there. Are they all correct?

In text below the table, write out a list of all the things you might have to fix in this data frame.

We'll fix them in the next lesson, as well as start looking more closely at the data.

## Turn in your project

Congratulations! You have created a new project in R and imported data. That is a feat in itself, so we will turn in this in.

- Save your `.Rmd` file.
- Use the **Preview/Knit** button to Knit your report to HTML. Look your report over and make sure you like it.
- If you need to, edit your `.Rmd` file, save, reKnit.
- When you are ready, go under the **File** menu to **Close project**.
- Go into your computers finder and locate your `firstnanme-wells` project.
- Create a `.zip` file of the folder
- Upload it to the Assignment in Canvas.

## Resources

- This [DataCamp tutorial on imports](https://www.datacamp.com/community/tutorials/r-data-import-tutorial) covers a ton of different data types and connections.