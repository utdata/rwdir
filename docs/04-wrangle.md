# Wrangle {#wrangle}

This chapter continues the Billboard Hot 100 project. In the previous chapter we downloaded, imported and cleaned the data. We'll be working in the same project.

## Goals of this lesson

- Dive deeper into dplyr functions to filter and summarize data.

## About the story

Now that we have the Billboard Hot 100 charts data in our project it's time to find the answers to the following questions:

- Who are the 10 Artists with the most appearances on the Hot 100 chart at any position?
- Which performer had the most songs reach No. 1?
- Which performer had the most songs reach No. 1 in the most recent five years?
- Which performer had the most Top 10 hits overall?
- Which performer/song combination has been on the charts the most number of weeks at any position?
- Which performer/song combination was No. 1 for the most number of weeks?

> What are your guesses for the questions above? No peeking!

Before we can get into the analysis, we need to set up a new notebook.

## Setting up an analysis notebook

At the end of the last notebook we exported our clean data as an `.rds` file. We'll now create a new notebook and import that data. It will be much easier this time.

1. If you don't already have it open, go ahead and open your Billboard project.
1. If your import notebook is still open, go ahead and close it.
1. Use the `+` menu to start a new **RNotebook*.
1. Update the title as "Billboard analysis" and then remove all the boilerplate text below the YAML metadata.
1. Save the file as `02-analysis.Rmd` in your project folder.
1. Check your Environment tab (top right) and make sure the Data pane is empty. We don't want to have any leftover data. If there is, then go under the **Run** menu and choose **Restart R and Clear Output**.

Since we are starting a new notebook, we need to set up a few things. First up we want to list our goals.

1. Add a headline and text describing the goals of this notebook. You are exploring the Billboard Hot 100 charts data.
1. Go ahead and copy all the questions outlined above into your notebook.
1. Start each line with a `-` or `*` followed by a space.
1. Now add a headline (two hashes) called Setup
1. Add a chunk, also name it "setup" and add the tidyverse library.
1. Run the chunk to load the library.


```r
library(tidyverse)
```

### Import the data on your own

In this next part I want you to think about how you've did the import in the last notebook and I want you to:

1. Write a section to import the data using `read_rds()` and put it into a tibble called `hot100`.

Yes, it is true that we haven't talked about [`read_rds()`](https://readr.tidyverse.org/reference/read_rds.html) yet but it works exactly the same way as `read_csv()`, so you should try to figure it out.

Here are some hints and guides:

- Start a new section with a headline and text to say what you are doing
- Don't forget to name your code chunk (this should all be getting familiar).
- `read_rds()` works the same was as `read_csv()`. The path _should_ be `data-processed/01-hot100.rds` if you did the previous notebook properly.
- Remember the tibble needs to be named first and read data pushed into it.
- Add a glimpse to the chunk so you can refer to the data.

<details>
  <summary>Try real hard first before clicking here for the answer</summary>


```r
hot100 <- read_rds("data-processed/01-hot100.rds")

# peek at the data
hot100 %>% glimpse()
```

```
## Rows: 327,895
## Columns: 7
## $ week_id                <date> 1958-08-02, 1958-08-02, 1958-08-02, 1958-08-02…
## $ week_position          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, …
## $ song                   <chr> "Poor Little Fool", "Patricia", "Splish Splash"…
## $ performer              <chr> "Ricky Nelson", "Perez Prado And His Orchestra"…
## $ previous_week_position <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
## $ peak_position          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, …
## $ weeks_on_chart         <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
```

</details>

## Introducing dplyr

One of the packages within the tidyverse is [dplyr](https://dplyr.tidyverse.org/). Dplyr allows us to transform our data frames in ways that let us explore the data and prepare it for visualizing. It's the R equivalent of common Excel functions like sort, filter and pivoting.

> There is a cheatsheet on the [dplyr](https://dplyr.tidyverse.org/) that you might find useful. 

![dplyr. Images courtesy Hadley and Charlotte Wickham](images/transform-dplyractions.png){width=600px}

We've used `select()`, `mutate()` and `arrange()` already, but we'll introduce more dplyr functions in this chapter.

## Most appearances

Our first question: Who are the 10 performers with the most appearances on the Hot 100 chart at any position?

### Group & Aggregate

Before we dive into the code, let's review this video about "Group and Aggregate" to get a handle on the concept.

> If it doesn't play in the book then click on title linked below it.

<iframe src="https://player.vimeo.com/video/435910349?h=ea9a75f967" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
<p><a href="https://vimeo.com/435910349">Group &amp; Aggregate - Basic Data Journalism Functions</a> from <a href="https://vimeo.com/user116130073">Christian McDonald</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

<!-- in case this vimeo doesn't work online
<iframe width="560" height="315" src="https://www.youtube.com/embed/a3VNWYJoy5A" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
-->

Let's work through the logic of what we need to do to get our answer before I explain exactly how.

- Each row in the data is one song on the chart.
- Each of those rows has the `performer` which is the person(s) who performed it.
- To figure out how many times a performer is in the data, we need to count the rows with the same performer.

We'll use the tidyverse's version of Group and Aggregate to get this answer. It is actually two different functions within dplyr that often work together: `summarize()` and it's companion `group_by()`.

### Summarize

> `summarize()` and `summarise()` are the same function, as R supports both the American and UK spelling of summarize. I don't care which you use.

We'll start with [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) first because it can stand alone.

The `summarize()` function computes tables _about_ your data. Our logic above has us wanting a "summary" of how many times certain performers appear in data, hence we use this function.

Here is an example in a different context:

![Learn about your data with summarize()](images/transform-summarise.png){width=500px}

Much like the `mutate()` function we used earlier, we list the name of the new column first, then assign to it the function we want to accomplish using `=`.

The example above is giving us two summaries: It is applying a function `mean()` on all the values in the `lifeExp` column, and then again with `min()`.

Let me show you a similar example with our data answer this question:

Let's find the average "peak_position" of all songs on the charts through history: 


```r
hot100 %>% 
  summarize(mean_position = mean(peak_position))
```

```
## # A tibble: 1 × 1
##   mean_position
##           <dbl>
## 1          41.4
```

Meaning the average song on the charts tops out at No. 41.

But in our case we want to **count** the number of rows, and there is a function for that: `n()`. (Think "number of observations or rows".)

Let's write the code and run it on our code, then I'll explain:

1. Set up a new section with a headline, text and empty code chunk.
1. Inside the code chunk, add the following:


```r
hot100 %>% 
  summarize(appearances = n())
```

```
## # A tibble: 1 × 1
##   appearances
##         <int>
## 1      327895
```

- We start with the tibble first and then pipe into `summarize()`.
- Within the function, we define our summary:
  + We name the new column "appearances" because that is a descriptive column name for our result.
  + We set that new column to count the **n**umber of rows.
  
Basically we are summarizing the total number of rows in the data.

AN ASIDE: I often break up the inside a `summarize()` into new lines so they are easier to read.

```r
# you don't have to do this here, but know
# it is helpful when you have more than one summary
hot100 %>% 
  summarize(
    appearances = n()
  )

```

But your are asking: Professor, we want to count the performers, right?

This is where `summarize()`'s close friend `group_by()` comes in.

### Group by

Here is a weird thing about [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html): It is always followed by another function. It really just pre-sorts data into groups so that whatever function is applied after happens within each individual group.

If add a `group_by()` on our performers before our summarize function, it will put all of the "Aerosmith" rows together, then all the "Bad Company" rows together, etc. and then we count the rows _within_ those groups.
 
1. Modify your code block to add the group_by:


```r
hot100 %>%
  group_by(performer) %>% 
  summarize(appearances = n())
```

```
## # A tibble: 10,061 × 2
##    performer                            appearances
##    <chr>                                      <int>
##  1 "? (Question Mark) & The Mysterians"          33
##  2 "'N Sync"                                    172
##  3 "'N Sync & Gloria Estefan"                    20
##  4 "'N Sync Featuring Nelly"                     20
##  5 "'Til Tuesday"                                53
##  6 "\"Groove\" Holmes"                           14
##  7 "\"Little\" Jimmy Dickens"                    10
##  8 "\"Pookie\" Hudson"                            1
##  9 "\"Weird Al\" Yankovic"                       91
## 10 "(+44)"                                        1
## # … with 10,051 more rows
```

What we get in return is a **summarize**d table that shows all 10,000+ different performers that have been on the charts, and **n**umber of rows in which they appear in the data.

That's great, but who had the most?

### Arrange the results

Remember in our last notebook when we had to sort the songs by date. We'll use the same `arrange()` function here, but we'll change the result to **desc**ending order, because journalists almost always want to know the _most_ of something.

1. Add the pipe and arrange function below and run it, then I'll explain.


```r
hot100 %>%
  group_by(performer) %>% 
  summarize(appearances = n()) %>% 
  arrange(appearances %>% desc())
```

```
## # A tibble: 10,061 × 2
##    performer     appearances
##    <chr>               <int>
##  1 Taylor Swift         1022
##  2 Elton John            889
##  3 Madonna               857
##  4 Kenny Chesney         758
##  5 Drake                 746
##  6 Tim McGraw            731
##  7 Keith Urban           673
##  8 Stevie Wonder         659
##  9 Rod Stewart           657
## 10 Mariah Carey          621
## # … with 10,051 more rows
```

- We added the `arrange()` function and fed it the column of "appearances". If we left it with just that, then it would list the smallest values first.
- Within the arrange function we piped the "appearances" part into another function: `desc()` to change the order.

So if you read that line in English it would be "arrange by (appearances AND THEN descending order)".

### Get the top of the list

We've printed 10,000 rows of data into our notebook when we really only wanted the Top 10 or so. You might think it doesn't matter, but your knitted HTML file will store all that data and can make it a big file (like in megabytes), so I try to avoid that when I can.

We can use the `slice_head()` command again to get our Top 10.

1. Pipe the result into `head()` function set to 10 rows.


```r
hot100 %>%
  group_by(performer) %>% 
  summarize(appearances = n()) %>% 
  arrange(appearances %>% desc()) %>% 
  head()
```

```
## # A tibble: 6 × 2
##   performer     appearances
##   <chr>               <int>
## 1 Taylor Swift         1022
## 2 Elton John            889
## 3 Madonna               857
## 4 Kenny Chesney         758
## 5 Drake                 746
## 6 Tim McGraw            731
```

If I was to explain the code above in English, I would descibe it as this:

- We start with the hot100 data AND THEN
- we group the data by performer AND THEN
- we summarize it by counting the number of rows in each group, calling the count "appearances" AND THEN
- we arrange the result by appearances in descending order AND THEN
- we kept just the first 10 rows

Since we have our answer here and we're not using the result later, we don't need to create a new tibble or anything.

### A shortcut: count()

You are going to think I'm a horrible person, but there is an easier way to do this ...

We count stuff in data science (and journalism) all the time. Because of this tidyverse has a shortcut to group and count rows of data. I needed to show you the long way because a) we will use `group_by()` and `summarize()` with other math that isn't just counting row, and b) you need to understand what is happening when you use `count()`, which is really just using group_by/summarize underneath.

The [`count()`](https://dplyr.tidyverse.org/reference/count.html) function takes the columns you want to group and then does the summarize on `n()` for you:


```r
hot100 %>% 
  count(performer)
```

```
## # A tibble: 10,061 × 2
##    performer                                n
##    <chr>                                <int>
##  1 "? (Question Mark) & The Mysterians"    33
##  2 "'N Sync"                              172
##  3 "'N Sync & Gloria Estefan"              20
##  4 "'N Sync Featuring Nelly"               20
##  5 "'Til Tuesday"                          53
##  6 "\"Groove\" Holmes"                     14
##  7 "\"Little\" Jimmy Dickens"              10
##  8 "\"Pookie\" Hudson"                      1
##  9 "\"Weird Al\" Yankovic"                 91
## 10 "(+44)"                                  1
## # … with 10,051 more rows
```

To get the same pretty table you still have to rename the new column and reverse the sort, you just do it differently as arguments within the `count()` function. You must still pipe into `head()` to limit the output.


```r
hot100 %>% 
  count(performer, name = "appearances", sort = TRUE) %>%
  head(10)
```

```
## # A tibble: 10 × 2
##    performer     appearances
##    <chr>               <int>
##  1 Taylor Swift         1022
##  2 Elton John            889
##  3 Madonna               857
##  4 Kenny Chesney         758
##  5 Drake                 746
##  6 Tim McGraw            731
##  7 Keith Urban           673
##  8 Stevie Wonder         659
##  9 Rod Stewart           657
## 10 Mariah Carey          621
```

So you have to do the same things get the nice Top 10 table, but when you just need a quick count to get an answer, then `count()` is brilliant. 

> AN IMPORTANT NOTE: The list we've created here is based on unique `performer` names, and as such considers collaborations separately. For instance, Drake is near the top of the list but those are only songs he performed alone and not the many, many collaborations he has had with other performers. So, songs by "Drake" are counted separately than "Drake featuring Future" and "Future featuring Drake". You'll need to make this clear when you write your data drop in a later assignment.

So, **Taylor Swift** ... is that who you guessed? A little history here, Swift past Elton John in the summer of 2019. Elton John has been around a long time, but Swift's popularity at a young age, plus changes in how Billboard counts plays in the modern era (like streaming) has rocketed her to the top. (Sorry, Rocket Man).


## Most songs to reach No. 1

Our second quest is to find "Which performer has the most No. 1 hits?" The answer might be easier to guess, but perhaps not.

Again, let's think through the logic of what we have to do to get our answer:

- We need to consider only No. 1 songs.
- Because a song could be No. 1 for more than one week, we need to consider the same song/performer combination only once.
- Once we have all the unique No. 1 songs in a list, then we can count how many times a performer is on the list.

To solve our first criteria, we need to learn a new function: [`filter()`](https://dplyr.tidyverse.org/reference/filter.html).

### Filter

Filtering is one of those Basic Data Journalism Functions:

<iframe src="https://player.vimeo.com/video/435910359?h=4b0d45c9b7" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
<p><a href="https://vimeo.com/435910359">Filter - a Basic Data Journalism Function</a> from <a href="https://vimeo.com/user116130073">Christian McDonald</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

<!-- youtube version
<iframe width="560" height="315" src="https://www.youtube.com/embed/ckojM4rtlMc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
-->

<br>
The `filter()` function of dplyr reduces the number of rows in our data based on one or more criteria.

The syntax works like this:

```r
# this is psuedo code. don't run it
data %>% 
  filter(variable comparison value)

# example
hot100 %>% 
  filter(performer == "Judas Priest")
```

The `filter()` function works in this order:

- What is the variable (or column) you are searching in.
- What is the comparison you want to do. Equal to? Greater than?
- What is the observation (or value in the data) you are looking for?

Note the two equals signs `==` there. It's important two use two of them when you are looking for "equals", as a single `=` will not work, as that means something else in R.

### Comparisons: Logical tests

There are a number of these logical test for the comparison:

| Operator          | Definition               |
|:------------------|:-------------------------|
| x **<** y         | Less than                |
| x **>** y         | Greater than             |
| x **==** y        | Equal to                 |
| x **<=** y        | Less than or equal to    |
| x **>=** y        | Greater than or equal to |
| x **!-** y        | Not equal to             |
| x **%in%** c(y,z) | In a group               |
| **is.na(**x**)**  | Is NA                    |
| **!is.na(**x**)** | Is not NA                |

### Filter for week_position

Now that we've seen how filter works, let's see it in action:

1. Start a new section with a headline and readout of what you are doing.
1. Add a code chunk and add the following:


```r
hot100 %>% 
  filter(week_position == 1)
```

```
## # A tibble: 3,279 × 7
##    week_id    week_position song      performer   previous_week_p… peak_position
##    <date>             <dbl> <chr>     <chr>                  <dbl>         <dbl>
##  1 1958-08-02             1 Poor Lit… Ricky Nels…               NA             1
##  2 1958-08-09             1 Poor Lit… Ricky Nels…                1             1
##  3 1958-08-16             1 Nel Blu … Domenico M…                2             1
##  4 1958-08-23             1 Little S… The Elegan…                2             1
##  5 1958-08-30             1 Nel Blu … Domenico M…                2             1
##  6 1958-09-06             1 Nel Blu … Domenico M…                1             1
##  7 1958-09-13             1 Nel Blu … Domenico M…                1             1
##  8 1958-09-20             1 Nel Blu … Domenico M…                1             1
##  9 1958-09-27             1 It's All… Tommy Edwa…                3             1
## 10 1958-10-04             1 It's All… Tommy Edwa…                1             1
## # … with 3,269 more rows, and 1 more variable: weeks_on_chart <dbl>
```

Since we are filtering on a number `1` and not the text character "1" we don't put the value in quotes. If you are looking for text, you need to put it in quotes: `performer == "Robert Plant"`.

### Complex filters

Don't do these yet, but you'll need them for reference later:

If you want single expression with multiple criteria, you write two equations and combine with `&`. Only rows with both sides are true are returned.

```r
# gives you only Poor Little Fool rows where song is No. 1, but not any other position
filter(song == "Poor Little Fool" & week_position == 1)
```

If you want an "or" filter, then you write two equations with a `|` between them.

> `|` is the _Shift_ of the _\_ key above Return on your keyboard. That `|` character is also sometimes called a "pipe", which gets confusing in R with ` %>% `.)

```r
# gives you Taylor or Drake songs
filter(performer == "Taylor Swift" | performer == "Drake")
```

If you have multiple criteria, you separate them with a comma `,`. Note I've also added returns to make it more readable.

```r
# gives us rows with either Taylor Swift or Drake, but only those at No. 1
filter(
  performer == "Taylor Swift" | performer == "Drake",
  week_position == 1
)
```

Getting back to our quest to find the artist with the most No. 1 hits ...

If you look at our original filter result, you now only have No. 1 songs. But also note that Ricky Nelson's _Poor Little Fool_ is listed more than once (as are other songs.) That's because it was No. 1 on more than one week.

### Using distinct()

Our next challenge in our logic is to show only unique song and performer combinations. We do this with [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html).

We feed the `distinct()` function with the variables we want to consider together, in our case the `song` and `performer`. All other columns are dropped since including them would mess up their distinctness.

1. Add the distinct() function to your code chunk.


```r
hot100 %>% 
  filter(week_position == 1) %>% 
  distinct(song, performer)
```

```
## # A tibble: 1,124 × 2
##    song                            performer                       
##    <chr>                           <chr>                           
##  1 Poor Little Fool                Ricky Nelson                    
##  2 Nel Blu Dipinto Di Blu (Volaré) Domenico Modugno                
##  3 Little Star                     The Elegants                    
##  4 It's All In The Game            Tommy Edwards                   
##  5 It's Only Make Believe          Conway Twitty                   
##  6 Tom Dooley                      The Kingston Trio               
##  7 To Know Him, Is To Love Him     The Teddy Bears                 
##  8 The Chipmunk Song               The Chipmunks With David Seville
##  9 Smoke Gets In Your Eyes         The Platters                    
## 10 Stagger Lee                     Lloyd Price                     
## # … with 1,114 more rows
```

Now we have a list of just No. 1 songs!

### Summarize the performers

Now that we have our list of No. 1 songs, we can "count" the number of times a performer is in the list to know how many No. 1 songs they have.

We'll use the group_by/summarize combination for this. We `group_by()` the `performer`, and then we find the number `n()` of rows in each group. Lastly, we need to `arrange()` to get the most on the top.

1. Add the steps for the group_by, summarize and arrange functions:


```r
hot100 %>% 
  filter(week_position == 1) %>%
  distinct(song, performer) %>%
  group_by(performer) %>%
  summarize(no1_hits = n()) %>%
  arrange(no1_hits %>% desc())
```

```
## # A tibble: 744 × 2
##    performer          no1_hits
##    <chr>                 <int>
##  1 The Beatles              19
##  2 Mariah Carey             16
##  3 Madonna                  12
##  4 Michael Jackson          11
##  5 Whitney Houston          11
##  6 The Supremes             10
##  7 Bee Gees                  9
##  8 The Rolling Stones        8
##  9 Janet Jackson             7
## 10 Stevie Wonder             7
## # … with 734 more rows
```

### Filter after summary

OK, we're going to do one last thing here ... we don't need all 744 rows of our summary We could use `head()` to include just the top 10 rows, but what if our "break" is in the middle of tied records? (i.e., if the 11th record "Daryl Hall John Oates" also had 7 chart toppers. They didn't, but we'll have to deal with other ties like this later.)

Instead of taking the Top 10 rows, we are instead going to filter the rows to those that have 7 hits or more. We are doing this to show you can not only filter your data _before_ your group, but you can also filter on the _result_ after your summary.

1. Modify your code to add the last filter. I've commented all the lines to explain what they do. You should do the same in your own words.


```r
hot100 %>% 
  filter(week_position == 1) %>% # filters to no 1 songs
  distinct(song, performer) %>% # gets a unique list
  group_by(performer) %>% # groups by the performer
  summarize(no1_hits = n()) %>% # gets number or rows in groups, names new column
  arrange(no1_hits %>% desc()) %>%  # sorts by highest no_hits
  filter(no1_hits >= 7) # filters the result to 7+
```

```
## # A tibble: 10 × 2
##    performer          no1_hits
##    <chr>                 <int>
##  1 The Beatles              19
##  2 Mariah Carey             16
##  3 Madonna                  12
##  4 Michael Jackson          11
##  5 Whitney Houston          11
##  6 The Supremes             10
##  7 Bee Gees                  9
##  8 The Rolling Stones        8
##  9 Janet Jackson             7
## 10 Stevie Wonder             7
```

### Try count on your own

OK, in the first challenge I also showed you how you can get this same result using `count()`. I want you to try and do this on your own.

1. Create a new code block and find the same answer using `count()` instead of group_by, summarize and arrange.

<details>
  <summary>Try real hard first before clicking here for the answer</summary>


```r
hot100 %>% 
  filter(week_position == 1) %>% 
  distinct(song, performer) %>% 
  count(performer, sort = T, name = "no1_hits") %>% 
  filter(no1_hits >= 7)
```

```
## # A tibble: 10 × 2
##    performer          no1_hits
##    <chr>                 <int>
##  1 The Beatles              19
##  2 Mariah Carey             16
##  3 Madonna                  12
##  4 Michael Jackson          11
##  5 Whitney Houston          11
##  6 The Supremes             10
##  7 Bee Gees                  9
##  8 The Rolling Stones        8
##  9 Janet Jackson             7
## 10 Stevie Wonder             7
```

<details>

## No. 1 hits in last five years

Which performer had the most songs reach No. 1 in the most recent five years?

This time I'll have you try the `count()` method on your own with some hints, but you'll need to do the group/summarize method all on your own.

Let's talk through the logic. This is very similar to the No. 1 hits above but with two differences:

- In addition to filtering for no. 1 songs, we also want to filter for songs in 2016-2020.
- We might need to adjust our last filter for a better "break point".

We haven't talked about filtering dates, so let me tell you this: You can use filter operations on dates just like you do any other text. This will give you rows _after_ 2015.

```r
filter(week_id > "2015-12-31")
```

Go back and review the "Complex filters" section where I showed how to combine more than one filter and apply that logic here. There is more than one correct answer. Here's the task:

1. Build a summary table that gets the most No. 1 hits in the last five years. Exclude results with a single No. 1 hit. Use the `count()` method.

<details>
  <summary>No, really. Try it on your own first.</summary>


```r
hot100 %>% 
  filter(
    week_position == 1,
    week_id > "2015-12-31"
  ) %>% 
  distinct(song, performer) %>% 
  count(performer, sort = T, name = "top_hits") %>% 
  filter(top_hits > 1)
```

```
## # A tibble: 10 × 2
##    performer      top_hits
##    <chr>             <int>
##  1 Drake                 5
##  2 Ariana Grande         3
##  3 Taylor Swift          3
##  4 BTS                   2
##  5 Cardi B               2
##  6 Ed Sheeran            2
##  7 Justin Bieber         2
##  8 Olivia Rodrigo        2
##  9 The Weeknd            2
## 10 Travis Scott          2
```

</details>

### Group on your own

1. Find the same results as above, but using the `group_by()` and `summarize()` method instead of count.

No hints this time ;-).

## Top 10 hits overall

Which performer had the most Top 10 hits overall?

This time we'll talk through the logic, but you have to figure out the answer on your own using the group_by/summarize method.

The logic is very similar to the "most No. 1 hits" quest you did above, but you need to adjust your filter to find songs within position 1 through 10. Don't overthink it, but do recognize that the "top" of the charts are smaller numbers.

1. Make a new section
1. Describe what you are doing
1. Do it using the group_by/summarize method and have a logical number or rows. (i.e., don't stop at a tie)

## Most appearances at any position

Which performer/song combination has been on the charts the most number of weeks at any position?

OK, this time we'll talk through the logic, but you have to give your own answer using the count() method.

The logic is actually straightforward:

- We wan to count combinations over two columsn: `song, performer`. When you give a count (or group_by) more then one column, it will group rows where the values are the same in all columns. i.e. all rows with both "Rush" as a performer and _Tom Sawyer_ as a song.
- Once you have a summary table, sort it with the most appearances on the top and then filter it to a logical stopping place.

So, here's the quest:

1. Start a new section with a proper headline and description
1. Use the `count()` method to find the song/performer combination with the most rows, sorting it properly within count.
1. Filter the summary table to a logical end.

## Most weeks at No. 1

This last quest is all on your own. You need to figure out the logic and then execute it. You can use any method you want (group_by/summarize or count), but make sure the table is sorted correctly and ends logically.

1. Start a section and describe it
2. Make a list of songs counting the number of weeks at No. 1. Sort by the most at top and end the table logically.

## Review of what we've learned

We introduced a number of new functions in this lesson, most of them from the [dplyr](https://dplyr.tidyverse.org/) package. Mostly we filtered and summarized our data. Here are the functions we introduced in this chapter:

- [`filter()`](https://dplyr.tidyverse.org/reference/filter.html) returns only rows that meet logical criteria you specify.
- [`summarize()`](https://dplyr.tidyverse.org/reference/summarise.html) builds a summary table _about_ your data. You can count rows [`n()`](https://dplyr.tidyverse.org/reference/n.html) or do math on numerical values, like `mean()`.
- [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) is often used with `summarize()` to put data into groups before building a summary table based on the groups.
- [`count()`](https://dplyr.tidyverse.org/reference/count.html) is a shorthand for the group_by/summarize operation to count rows based on groups. You can name your summary columns and sort the data within the same function.
- [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html) returns rows based on unique values in columns you specify. i.e., it deduplicates data.

## Turn in your project

1. Make sure everything runs properly (Restart R and Run All Chunks) and then Knit to HTML.
1. Zip the folder.
1. Upload to the Canvas assignment.

## Soundtrack for this assignment

This lesson was constructed with the vibes of [The Bright Light Social Hour](https://www.thebrightlightsocialhour.com/home). They've never had a song on the Hot 100 (at least not through 2020).