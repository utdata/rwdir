# Importing data {#import}

> DRAFT FOR v1.0

## Goals for this section

- Learn a little about data types available to R.
- Practice organized project setup.
- Learn about R packages, how to install and import them.
- Learn how to import CSV files.
- Introduce the Data Frame/Tibble.
- Introduce the tidyverse ` %>% `.

## Our project data

We achieve these goals while working with same Texas Education Agency school ratings data we used with the [Google Sheets lesson](https://github.com/utdata/rwd-mastery-assignments/tree/master/ed-school-ratings).

I'm not gonna lie ... Sheets is much easier to learn and getting the answers we wanted about the school ratings is difficult to do in R because you are learning a programming language. Using R is a trade off ... there is a lot more to learn, but it is much more powerful in the end.

> “If you’re doing data analysis every day, the time it takes to learn a programming language pays off pretty quickly because you can automate more and more of what you do.” --Hadley Wickham, chief scientist at RStudio

I choose to start with school ratings because if you are in the class, you are already familiar with the data. That said, you can still dive in if you haven't done the Sheets lesson.

## Data sources

After installing and launching RStudio, the next trick is to import data. Depending on the data source, this can be brilliantly easy or a pain in the rear. It all depends on how well-formatted is the data.

In this class, we will primarily be using data from Excel files, CSVs (Comma Separated Value) and APIs (Application Programming Interface).

- **CSVs** are a kind of lowest-common-denominator for data. Most any database or program can import or export them.
- **Excel** files are good, but are often messy because humans get involved. There often have multiple header rows, columns used in multiple ways, notes added, etc. Just know you might have to clean them up before using them.
- **APIs** are systems designed to respond to programming. In the data world, we often use the APIs by writing a query to ask a system to return a selection of data. By definition, the data is well structured. You can often determine the file type of the output as part of the API call, including ...
- **JSON** (or JavaScript Object Notation) is the data format preferred by JavaScript. R can read it, too. It is often the output format of APIs, and prevalent enough that you need to understand how it works. We'll get into that later in semester.

Don't get me wrong ... there are plenty of other data types and connections available through R, but those are the ones we'll deal with most in this book.

### What is clean data

The Checking Your Data section of this [DataCamp tutorial](https://www.datacamp.com/community/tutorials/r-data-import-tutorial) has a good outline of what makes good data, but in general it should:

- Have a single header row with well-formed column names.
    + One column name for each column. No merged cells.
    + Short names are better than long ones.
    + Spaces in names make them harder to work with. Use and `_` or `.` between words.
- Remove notes or comments from the files.
- Each column should have the same kind of data: numbers vs words, etc.
- Each row should be a single thing called an "observation". The columns should describe that observation.

Data rarely comes clean like that. There can be many challenge in importing and cleaning data. We'll face some of those challenges here.

## Create a new project

We did this in our first lesson, but here are the basic steps:

- Launch RStudio
- Use the `+R` button to create a **New Project** in a **New Directory**
- Name the project `yourfirstname-school-ratings` and put it in your `~/Documents/rwd` folder.
- Use the `+` button to use **R Notebook** to start a new notebook.
- Change the title to "TEA School Ratings".
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

## Downlaoding raw data

### Create a directory for your data

I want you to create a folder called `data-raw` in your project folder. We are creating this folder because we want to keep a pristine version of it our original data that we never change or overwrite. This is a basic data journalism principle: Thou shalt not change raw data.

In your Files pane at the bottom-right of Rstudio, there is a **New Folder** icon.

- Click on the **New Folder** icon.
- Name your new folder `data-raw`.

Once you've done that, it should show up in the file explorer in the Files pane.

![Directory made](images/terminal-mkdir-done.png){width=300px}

### Let's get some data

Now that we have a folder for our data, we can download our data into it. I have a copy of the data in the class Github repo.

The process to acquire this data is explained in the [School Ratings](https://github.com/utdata/rwd-mastery-assignments/blob/master/ed-school-ratings/README.md) assignment in the RWD Mastery Assignments Github repository. Since we did that in an earlier assignment I won't make you do that again here. You can just download my copy using the `download.file` function in R.

- Add a Markdown headline and text that indicates you are downloading data. You would typically include a link and explain what it is, etc. You can build a link in Markdown with `[name of the site](url-to-the-site.html)`.
- Create an R chunk and include the following:

```r
download.file("https://github.com/utdata/rwd-mastery-assignments/blob/master/ed-school-ratings/data/CAMPRATE_2019.csv?raw=true", "data-raw/camprate_2019.csv")
```

This function takes at least two arguments: The URL of the file you are downloading, and then the path and name of where you want to save it.

When you run this, it should save the file and then give you output like this:

```text
trying URL 'https://github.com/utdata/rwd-mastery-assignments/blob/master/ed-school-ratings/data/CAMPRATE_2019.csv?raw=true'
Content type 'text/plain; charset=utf-8' length 1326537 bytes (1.3 MB)
==================================================
downloaded 1.3 MB
```

### Peek at the data file

You can inspect the data before you import it into your RNotebook.

- In the **Files** pane, click on the `data-raw` folder to open in.
- Click on the `camprate_2019.csv` file until you get the drop down that says View Files.

![View file](images/import-inspectdata.png){width=300}

- The file _should_ open into a new window. It will look like this:

![ratings file](images/import-ratingsfile.png){width=600}

The numbers on the left are row numbers in the file. Because lines will wrap in your window, those numbers let you know where each line starts.

We can see first row is our column headers and the first column is our `CAMPUS` ID. This ID identifies our campus.

At this point the data is only on our computer in a folder within our project. It has not been imported into our RNotebook yet.

- Close this file now by clicking on the small `x` next to the file name.

### Import csv as data

Since we are doing a new thing, we should note that with a Markdown headline and text. 

- A a Markdown headline: `## Import data`
- Add some text to explain  that we are importing the school ratings data.
- After your description, add a new code chunk (*Cmd+Option+i*).

We'll be using the `read_csv()` function from the tidyverse [readr](https://readr.tidyverse.org/) package, which is different from `read.csv` that comes with R. It is mo betta.

Inside the function we put in the path do our data, inside quotes. If you start typing in that path and hit tab, it will complete the path. (Easier to show than explain).

- Add the follow code into your chunk and run it.

```r
read_csv("data-raw/CAMPRATE_2019.csv")
```

This prints two things to our notebook, which are shown as tabs in the R output.

The first result called "R Console" shows what columns were imported and the data types. It's important to review these to make sure things happened the way that expected. In this case it looks like it imported most everything as a character (the default) but set one column `CALL_UPDATE` as `col_double`, which is a number.

Note: **Red** colored text in this output is NOT an indication of a problem.

![RConsole output](images/import-show-cols.png){width=500}

The second result **spec_tbl_df** prints out the data like a table. The data object is called a data frame or [tibble](https://tibble.tidyverse.org/), which is a fancy tidyverse version of a data frame that is part of the tidyverse.

> I will use the term tibble and data frame interchangably. Think of data frames and tibbles like a well-structured spreadsheet. They are organized rows of data (called observations) with columns (called variables) where every item in the column is of the same data type.

![Data output](images/import-show-data.png){width=500}

When we look at the data output into RStudio, there are several things to note:

- Below the column name is an indication of the data type. This is important.
- You can use the arrow icon on the right to page through the additional columns.
- You can use the paging numbers and controls at the bottom to page through the rows of data.
- The number of rows and columns is displayed at the bottom.

The [data dictionary](https://rptsvr1.tea.texas.gov/perfreport/account/2019/download/camprate.html) is especially helpful in understanding what the data is, since the column names are not very telling.

### Clean names and the pipe

A good trait for data journalist is to be ~~anal retentive~~ obsessive. One thing I almost always do is run my data through a function called `clean_names()` which makes all the column names lowercase, removes spaces and fixes other things that can cause problems later. `clean_names()` is part of the [janitor vignette](https://cran.r-project.org/web/packages/janitor/vignettes/janitor.html) package we installed above.

- Edit your code chunk to look like the code below and run it.

```r
read_csv("data-raw/CAMPRATE_2019.csv") %>% 
  clean_names()
```

### About the pipe %>%

The code ` %>% ` we added at the end of the `read_csv()` function is called a pipe. It is a tidyverse tool that allows us to take the **results** of an object or function and pass into another function. Think of it "AND THEN" the next thing.

We are using **read_csv** to import the data **and then** we run **clean_names** on that data.

It might look like there are to arguments inside `clean_names()`, but remember because of the pipe we are passing the result of the previous function into it.

For readability we often put the "next" function an indented new line, though it does work on a single line. If you do add the return, it must come **after** the ` %>% `.

> IMPORTANT: There is a keyboard command for the pipe ` %>% `: **Cmd+Shift+m**. Learn that one.

## Inspecting and adjusting imports

When we page through our data, we should notice that the `cdalls` column is a numerical value. If we review our [data dictionary](https://rptsvr1.tea.texas.gov/perfreport/account/2019/download/camprate.html) this is the "Campus 2019 Overall Scaled Score", or the number grade that corresponds to the letter grade the school received.

You might notice that "ELKHART DAEP" has a `.` for a grade. A DEAP school is a "disciplinary alternative education program" and the often are exempt from ratings. There are some other schools like this, too. Because of the `.`, R though this column was supposed to be text (or `col_character()` in R-speak). These are suppose to be whole numbers, or `col_integer()`.

At this point we have a decision to make. We can fix this as we import the data, or fix it afterward.

The "pros" for fixing on import is it is done and we don't have to worry about it later. Any value that is not a number is not useful to us. (We can't get an average of text.)

The "pros" for fixing after import is we compare the original values to the new values. Sometimes this is very important when you are changing data.

That all said, we are going to fix on import because that it is importing that we are learning. We have a good handle on why the data came in as it did and fixing is a safe thing to do.

### Fix `cdalls`: Assign data type upon import

We have to do some more editing to our import statement to set `cdalls` as an interger on import.  

The [usage](https://readr.tidyverse.org/#usage) section of the readr documentation shows There is an "argument" in the `read_csv()` function that will allow this. After our first argument of the "path" to the document, we can add a `col_types = cols()` argument and identify which colunns and data types to use inside `cols()`.

To do this, we will edit the `read_csv()` part of our chunk. When I have multiple arguments in a function, I like to put them on separate lines so they are more readable. This is a bit tricky to explain in prose, but I'm adding returns after the opening `(` for both the `read_csv()` function and the `cols()` function so the internals are on separate lines.

RStudio will try to help you with the indentation. If you are "inside" a function, the next line is indented.

- Adjust your code to look like that below and run it:

```r
read_csv(
  "data-raw/camprate_2019.csv",
  col_types = cols(
    CDALLS = col_integer()     
  )
) %>% 
  clean_names()
```

Look at the data that is returned. The data type indication under the `cdalls` column should now be **<int>**, for integer. You might also notice that the value for "ELKHART DAEP" is now **NA**, which means not available. i.e, it is missing.

If you look at the R Console tab, it shows this:

```text
41 parsing failures.
row    col   expected actual                         file
  5 CDALLS an integer      . 'data-raw/camprate_2019.csv'
 55 CDALLS an integer      . 'data-raw/camprate_2019.csv'
 56 CDALLS an integer      . 'data-raw/camprate_2019.csv'
 63 CDALLS an integer      . 'data-raw/camprate_2019.csv'
 71 CDALLS an integer      . 'data-raw/camprate_2019.csv'
... ...... .......... ...... ............................
See problems(...) for more details.
```

There wer parse errors each time it hit a `.` instead of a number. We are OK with this because we know why!

## Assign our import to a data frame

As of right now, we've only printed the data to our screen. We haven't "saved" it at all. Next we need to assign it to an **object** so it can be named thing in our project environment so we can reuse it. We don't want to re-import the data every time we use the data.

The syntax to create and object in R can seem weird at first, but the convention is to name the object first, then insert stuff into it. So, to create an object, the structure is this:

```r
# this is pseudo code. don't run it.
new_object <- stuff_going_into_object
```

Let's make a object called `ratings` and fill it with our ratings tibble.

- Edit your existing code chunk to look like this. You can add the `<-` by using **Option+-** as in holding down the Option key and then pressing the hyphen:


```r
ratings <- read_csv(
  "data-raw/camprate_2019.csv",
  col_types = cols(
    CDALLS = col_integer()     
  )
) %>% 
  clean_names()
```

Run that chunk and two things happen:

- We no longer see the result printed to the screen. That's because we created a tibble instead of printing it to the screen.
- In the **Environment** tab at the top-right of RStudio, you'll see the `ratings` object listed.
    + Click on the blue play button next to ratings and it will expand to show you a summary of the columns.
    + Click on the name and it will open a "View" of the data in another window, so you can look at itin spreadsheet form. You can even sort and filter it.
- Close the data view once you've looked at it.

Since `ratings` is a data frame object, we'll just call it a data frame henceforth.

### Print a peek to the screen

After assigning my data to an object, I like to pring the object to the screen so I can go back and refer to it. We will again edit the chunk, adding this to the end.

- Edit your import chunk to add the last two lines of this, including the one with the `#`:

```r
ratings <- read_csv(
  "data-raw/camprate_2019.csv",
  col_types = cols(
    CDALLS = col_integer()     
  )
) %>% 
  clean_names()
  
# peek at the data
ratings
```

The line with the `#` is a comment within the code chunk. Commenting what your code does is important to your future self, and sometimes we do that within the code chunk instead of markdown if it will be more clear.

## Glimpse the data

While we were able to page through our printed data to see columns, that can be a hassle if we have lots of columns. There is a way to take a "glimpse" at all at once.

- Add a new chunk
- Add the code to the chunk and run it.

I'm showing the return here as well.


```r
ratings %>% glimpse()
```

```
## Rows: 8,838
## Columns: 24
## $ campus            <chr> "001902001", "001902041", "001902103", "001903001",…
## $ call_update       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ campname          <chr> "CAYUGA H S", "CAYUGA MIDDLE", "CAYUGA EL", "ELKHAR…
## $ cdalls            <int> 95, 83, 91, 89, NA, 86, 92, 92, 86, 84, 78, 96, 77,…
## $ cflaeatype        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ cflaec            <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ cflalted          <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ cflchart          <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ cfldaep           <chr> "N", "N", "N", "N", "Y", "N", "N", "N", "N", "N", "…
## $ cfleek            <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ cfljj             <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ cflnewcamp        <chr> "N", "N", "N", "N", "Y", "N", "N", "N", "N", "N", "…
## $ cflrtf            <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "…
## $ cntyname          <chr> "ANDERSON", "ANDERSON", "ANDERSON", "ANDERSON", "AN…
## $ county            <chr> "001", "001", "001", "001", "001", "001", "001", "0…
## $ c_appeal_decision <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ c_rating          <chr> "A", "B", "A", "B", "Not Rated", "B", "A", "A", "B"…
## $ c_yrs_ir          <chr> ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "…
## $ distname          <chr> "CAYUGA ISD", "CAYUGA ISD", "CAYUGA ISD", "ELKHART …
## $ district          <chr> "001902", "001902", "001902", "001903", "001903", "…
## $ grdhigh           <chr> "12", "08", "05", "12", "10", "08", "02", "05", "12…
## $ grdlow            <chr> "09", "06", "PK", "09", "08", "06", "PK", "03", "09…
## $ grdspan           <chr> "09 - 12", "06 - 08", "PK - 05", "09 - 12", "08 - 1…
## $ grdtype           <chr> "S", "M", "E", "S", "S", "M", "E", "E", "S", "M", "…
```

This also shows there are 8,838 rows and 24 columns in our data. Each column is then listed out with its datatype and the first several values in that column.

## Exporting data

### Single-notebook philosphy

I have a pretty strong opinion that you should be able to open any RNotebook in your project and run it from top to bottom without it breaking. In short, one notebook should not be dependent on the previous running of another notebook, unless it is to provide an output file that can be accessed later by another notebook.

This is why I had you name this notebook `01-import.Rmd` with a number 1 at the beginning. We'll number our notebooks in the order they should be run. It's an indication that before we can use the notebook `02-analysis.Rmd` (next lesson!) that the `01-import.Rmd` notebook has to be run first.

But what is important is we will create an exported file from our first notebook that can be used in the second one. Once we create that file, the second notebook can be opened and run at any time.

Why make this so complicated? It might seem like overkill for this project ... after all, the csv file imported cleanly and we don't need to do anything further to it except lowercase column names.

The answer is **consistency**. When you follow the same project structure each, you quickly know how to dive into that project at a later date. If everyone on your team uses the same structure, you can dive into your teammates code because you already know how it is organized. If we separate our importing and cleaning into it's own file to be used by many other notebooks, we can fix future cleaning problems in ONE place instead of many places. 

One last example to belabor the point: It can save time. I've had import/cleaning notebooks that took 20 minutes to process. Imagine if I had to run that every time I wanted to rebuild my analysis notebook. Instead, the import notebook spits out clean file that can be imported in a fraction of that time.

This was all a long-winded way of saying we are going to export our data now.

### Exporting as rds

We are able to pass cleaned data between notebooks because of a native R data format called `.rds`. When we export in this format it saves not only rows and columns, but also the data types. (If we exported as CSV, we would potentially have to re-fix data types when we imported again.)

We will use another readr function called `write_rds()` to create our file to pass along to the next notebook, but first we need to create a folder to put it in. We will create `data-processed` where we will put our output files. We are separating it from our data-raw folder because "Thou shalt not change raw data" even by accident. By always writing data to this different folder, we help avoid accidentally overwriting our original data.

- Make sure your Files pane explorer is situated in your project folder and not inside some other folder like data-raw. If you need to climb out of a folder, you can click on the double dot `..` listed at the top of the folder.
- Once at your project folder, use the **New Folder** icon in the Files pane to create a new folder and call it `data-processed`.
- Create a Markdown headline `## Exports` and write a description that you are exporting files to .rds.
- Add a new code chunk and add the following code:

<!-- running this code to get output for future chapter -->


```r
ratings %>% 
  write_rds("data-processed/01_ratings.rds")
```

So, we are starting with the ratings data frame that we saved earlier. We then pipe ` %>% ` the result of that into a new function `write_rds()`. In addition to the data, the function needs to who where to save the file, so in quotes we give the path to where and what we want to call the file: `data-processed/01_ratings.rds`.

Remember, we are saving in data-processed because we never export into data-raw. We are naming the file starting with `01_` to indicate to our future selves that this output came from our first notebook. We then name it, and use the `.rsd` extension.

## Turn in your project

Congratulations! You have created a new project in R, imported data and then exported it. That is a feat of skill worth celebrating, so we will turn in waypoint as an assignment.

- Save your `.Rmd` file.
- Use the **Preview/Knit** dropdown to _Knit to HTML_. Look your report over and make sure you are happy with headlines, text, spacing, etc.
  - If you need to, edit your `.Rmd` file, save, reKnit.
- When you are ready, go under the **File** menu to **Close project**.
- Go into your computer's finder and locate your `firstnanme-school-ratings` project.
- Create a `.zip` file of the folder.
  - If you find you need to make changes after you have zipped, it is best to delete the old one, then re-zip.
- Upload the zip file to the proper assignment in Canvas.

## Resources

- This [DataCamp tutorial on imports](https://www.datacamp.com/community/tutorials/r-data-import-tutorial) covers a ton of different data types and connections.
