# Summarize {#summarize}

This chapter continues the Billboard Hot 100 project. In the previous chapter we downloaded, imported and cleaned the data. We'll be working in the same project.

## Goals of this lesson

- Work more with or introduce select, filter and arrange.
- Introduce group_by and summarize.

## About the story

Now that we have the Billboard Hot 100 charts data in our project it's time to find the answers to the following questions:

1. Who are the 10 Artists with the most appearances on the Hot 100 chart at any position?
2. Which Artist had the most Titles to reach No. 1?
3. Which Artist had the most Titles to reach No. 1 in the most recent five years?
4. Who had the most Top 10 hits overall?
5. Which Artist/Title combination has been on the charts the most number of weeks at any position?
6. Which Artist/Title combination was No. 1 for the most number of weeks?

FOOD FOR THOUGHT: What are your guesses for the questions above? No peeking!

Before we can get into the analysis, we need to set up a new notebook.

## Setting up new notebook

At the end of the last notebook we exported our clean data as an `.rds` file. We'll now create a new notebook and import that data. It will be much easier this time.

- If you don't already have it open, go ahead and open your Billboard project.
- If your import notebook is still open, go ahead and close it.
- Use the `+` menu to start a new **RNotebook*.
- Update the title as "Billboard analysis" and then remove all the boilerplate text below the YAML metadata.
- Check your Environment tab (top right) and make sure the Data pane is empty. We don't want to have any leftover data. If there is, then go under the **Run** menu and choose **Restart R and Clear Output**.

Since we are starting a new notebook, we need to set up a view things. First up we want to list our goals.

- Add a headline and text describing the goals of this notebook. You are exploring the BillBoard Hot 100 charts data.
- Go ahead and copy all the questions outlined above into your notebook. If the numbers don't come over, go ahead and add them where the number is at the beginning of the line with a period after it followed by a space.

> Fun fact: It doesn't matter what numbers you use, it will change them to them to start with 1, etc when you preview/knit it.

- Now add a headline (two hashes) called Setup
- Add a chunk, also name it "setup" and add the tidyverse library.
- Run the chunk to load the library.


```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.3     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   2.0.1     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```


### Import the data

In this next part I want you to think about how you've did the import in the last notebook and I want you to **on your own** write a section to import the data using `read_rds()` and put it into a tibble called `hot100`. Yes, it is true that we haven't talked about `read_rds()` yet but it works exactly the same way as `read_csv()`, so you should try it out.

Here are some hints and guides:

- Start a new section with a headline and text to say what you are doing
- Don't forget to name your code chunk (this should all be getting familiar).
- `read_rds()` works the same was as `read_csv()`. The path _should_ be `data-processed/01-hot100.rds` if you did the previous notebook properly.
- Remember the tibble needs to be named first and read data pushed into it.
- Add a glimpe to the chunk so you can refer to the data.

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

## Most appearances

Our first question: Who are the 10 Artists with the most appearances on the Hot 100 chart at any position?

- Go ahead and set up a new section with a headline, text and empty code block.

Before we dive into the code, let's rewatch this video about "Group and Aggregate" to get a handle on the concept.

> If it doesn't play in the book then click on title linked below it.

<iframe src="https://player.vimeo.com/video/435910349?h=ea9a75f967" width="640" height="360" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
<p><a href="https://vimeo.com/435910349">Group &amp; Aggregate - Basic Data Journalism Functions</a> from <a href="https://vimeo.com/user116130073">Christian C McDonald</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

<!-- in case this vimeo doesn't work online
<iframe width="560" height="315" src="https://www.youtube.com/embed/a3VNWYJoy5A" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
-->

Let's work through the logic of what we need to do to get our answer before I explain exactly how.

1. Each row in the data is one song on the chart.
2. Each of those rows has the `performer` which is the person(s) who performed it.
3. To figure out how many times a performer is in the data, we need to count the rows with the same performer.

We'll use the tidyverse's version of Group and Aggregate to get this answer. It is actually two different functions within dplyr that often work together: `summarize()` and it's companion `group_by()`.

### Summarize

We'll start with `summarize()` first because it can stand alone. We'll get to `group_by()` in a minute.

> `summarize()` and `summarise()` are the same function, as R supports both the American and UK spelling of summarize. I don't care which you use.

The `summarize()` function computes tables _about_ your data. Our logic above has us wanting a "summary" of how many times certain performers appear in data, hence we use this function.

Here is an example in a different context:

![Learn about your data with Summarize()](images/transform-summarise.png){width=500px}

Much like the `mutate()` function we used earlier, we list the name of the new column first, then assign to it the function we want to accomplish using `=`.

The example above is giving us two summaries: It is applying a function `mean()` on all the values in the `lifeExp` column, and then again with `min()`.

But in our case we want to **count** the number of rows, and there is a function for that: `n()`. (Think "number of observations or rows".)

Let's get the code and run it on our code, then I'll explain:

- Inside the code chunk, add the following:


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

1. We start with the tibble first and then pipe into `summarize()`.
2. Within the function, we define our summary:
  + We name the new column "appearances" because that is what we will count in the end.
  + We set that new column to count the **n**umber of rows.
  
Basically we are summarizing the number of rows in the data.

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

This is where summarize's close friend `group_by()` comes in.

## Group by

Here is a weird thing about group_by: It is always* followed by another function. It really just pre-sorts data so that whatever function is applied after happens within each individual group.

\* At least I think always. I can't think of a reason to use it alone.

If add a `group_by()` on our performers before our summarize function, it will put all of the "ABBA" rows together, and then all the "Bad Company" rows together, etc. and then count the rows _within_ those groups.
 
- Modify your code block to add the group_by:


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

Remember in our last notebook when we had to sorted the data by the date. We'll use the same `arrange()` function here, but we'll change the result to **desc**ending order.

- Add the pipe and arrange function below and run it, then I'll explain.


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

We added the `arrange()` function and fed it the column of "appearances". If we left it with just that, then it would list the smallest values first. Journalists always want the **most** of everything, so we need to pipe the "appearances" part into another function: `desc()` to change the order.

So that line is "arrange by appearances AND THEN descending order".

### Just the top of the list

We've printed 10,000 rows of data into our notebook when we really only wanted the top 10 or so. You might think it doesn't matter, but your knitted HTML file will "keep" that data and can make it a big file, so I try to avoid that when I can.

We can use the `head()` command again to get our top 10.

- Pipe the result into `head()` function set to 10 rows.


```r
hot100 %>%
  group_by(performer) %>% 
  summarize(appearances = n()) %>% 
  arrange(appearances %>% desc()) %>% 
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

If I was to explain the code above in English, I would descibe it as this:

1. We start with the hot100 data AND THEN
2. we group the data by performer AND THEN
3. we summarized it by counting the number of rows in each group, calling the count "appearances" AND THEN
4. we arranged the result by appearances in descencing order AND THEN
5. we kept just the first 10 rows

## A shorter way: Count

You are going to think I'm a horrible person, but there is a much easier way to do this ...

You see, we count stuff in data science (and journalism) all the time. Because of this there is a shortcut to group and count rows. I had to show you the long way because a) you need to understand how `count()` works, and b) we will do more `summarize()` with other math that isn't just counting.

The [`count()`](https://dplyr.tidyverse.org/reference/count.html) function takes the columns you want to group and then does the summarize for you:


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

To get the same pretty table you still have to rename the new column and reverse the sort, you just do it differently as arguments within the `count()` function. You still need `head()` to limit the output, too.


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

So you have to do the same amount of work to get the top 10 in nice table, but when you just need a quick count to get an answer, then `count()` is brilliant.

So, Taylor Swift ... is that who you guessed? A little history here, Swift past Elton John in the summer of 2019. Elton John has been around a long time, but Swift's popularity at a young age, plus changes in how Billboard counts plays in the modern era (like streaming) has rocketed her to the top. (Sorry, Rocket Man).

> A very important note about this list: Collaborations are separate. EXPOUND ON THIS.

## The next challenge

