# Reordering factors

> Needs rewrite around a journalism problem or drop it

There is a complexity within R data frames that we need to cover becomes it comes into play when we want to order categorical data within graphics.

We are going to handle this through a new project using our Survey data from class.

## Goals for this section

- Create a new project with our class survey data.
- Create a chart that uses categorical data.
- Reorder the values in the chart using `fct_reorder()`.

This is the chart we want to build:

![Popular princesses](images/factors-graphic-example.png)


## Create our survey project

### Setup

- In RStudio, choose File > New Project
- Walk through the steps to create a New Project in a New Directory called `yourname-survey`.
- In your project, create a new directory called `data-raw`.
- Go to [this link](https://github.com/utdata/rwd-mastery-assignments/blob/master/survey-results/survey-results-2019-01-sp.csv?raw=true) in a browser. Do **File > Save page as** and save the file inside your `data-out` folder as `survey-results.csv`.
- Create a new RNotebook. Save the file and name it `01-survey.Rmd`. For this simple example, we'll only be using one notebook.

### Libraries

We need two libraries. I _think_ the **forcats** library is already installed, but if not you'll have to run the following in your RConsole: `install.packages("forcats")`.

```r
library(tidyverse)
library(forcats)
```

### Import the data

Import the data from the csv

```r
survey <- read.csv("data-raw/survey-results.csv") %>% clean_names()

# peek at the data
survey %>% head()
```

Peeking at the data, we see it is something like this:

| class             | graduating | ice_cream           | princess               | computer  |
|-------------------|------------|---------------------|------------------------|-----------|
| Senior            | Yes        | Cookies & Cream     | Mulan                  | Macintosh |
| Masters candidate | Yes        | Rocky Road          | Mulan                  | Windows   |
| Senior            | Yes        | Chocolate           | Ariel (Little Mermaid) | Windows   |
| Senior            | No         | Mint chocolate chip | Mulan                  | Macintosh |
| Junior            | No         | Mint chocolate chip | Jasmine (Aladdin)      | Windows   |
| Senior            | No         | Mint chocolate chip | Rapunzel (Tangled)     | Macintosh |

## Figuring out our data shape

As we've talked about before, it is helpful to think of what we want the graphic to be, even to draw it out, so we can figure out what columns we need for the X and Y axis.

The example I showed above is a little weird in that we are really building a bar/column chart, but we've turned sideways so we can read the labels. To build the chart, we are really looking at this:

![Princess before flip](images/factors-before-flip.png)


- What do we need for the x value? Well, we need the **total votes** for each princess.
- What do we need for the y value? We need to list each **princess** that got votes.

## Charting the popularity of princess

So, we need a `princess` column and a `votes` column. These easiest way to do this is a simple `count()` summary. Build the count _before_ you assign it back to `princess_count` so you see what is happening, but this is similar to what we've done in the past.

```r
princess_count <- survey %>%
  count(princess) %>%
  rename(votes = n) %>%
  arrange(desc(votes))

# peak
princess %>% head
```

In order, we are:

- Assigning the result (which you do at the end), starting from `survey`.
- Count the rows of each princess.
- Rename the `n` column to `votes`.
- Arrange so the most votes are on top.

We get this:

| princess                      | votes |
|-------------------------------|------:|
| Mulan                         |    14 |
| Rapunzel (Tangled)            |     7 |
| Jasmine (Aladdin)             |     6 |
| Ariel (Little Mermaid)        |     5 |
| Tiana (Princess and the Frog) |     2 |
| Aurora (Sleeping Beauty)      |     1 |
| Belle (Beauty and the Beast)  |     1 |
| Merida (Brave)                |     1 |
| Snow White                    |     1 |

## Create our princess plot

We are going to use a new chart, `geom_col`, which is like `geom_bar` but it already understands the `stat="identity"`.

```r
princess_count %>% ggplot(aes(x = princess, y = votes)) +
  geom_col() +
  coord_flip() +
  labs(title="Favorite Disney Princesses in class", x = "Princess", y = "Votes") +
  geom_text(aes(label = votes), hjust=-.25)
```

And we get this:

![Princess wrong order](images/factors-wrong-order.png)

Well, that is frustrating. The bars are not in the same order that we arranged them in the data frame.

As explained in [the R-Graph-Gallery post](https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2/): This is due to the fact that ggplot2 takes into account the order of the factor levels, not the order you observe in your data frame. You can sort your input data frame with sort() or arrange(), it will never have any impact on your ggplot2 graphic.

### Labels and titles

Before I get into factors, let me explain the other lines in the graphic above:

- `coord_flip()` transposes the bars so they go horizontal instead of vertical. This allows us to read the princess values.
- `labs()` allows us to add the title and cleaner axis labels.
- `geom_text()` adds the numbers at the end of the bar, with some adjustments to get them off the top of the bars.

## Factors

Factors allow you to apply an order (called "levels") to values beyond being alphabetical. It is super useful when you are dealing with things like the names of months which have a certain order ("Jan", "Feb", "March") which would not be ordered correctly alphabetically.

But is is kind of frustrating here.

We can improve it by reordering the levels of `princess` using a function from the [forcats](https://forcats.tidyverse.org/) package. (forcats is an anagram for "factors"). There are four functions you can use reorder a factor:

- `fct_reorder()`: Reordering a factor by another variable.
- `fct_infreq()`: Reordering a factor by the frequency of values.
- `fct_relevel()`: Changing the order of a factor by hand.
- `fct_lump()`: Collapsing the least/most frequent values of a factor into “other”.

We will use [`fct_reorder()`](https://forcats.tidyverse.org/reference/fct_reorder.html) to reorder the **princess** values based on the **votes** values. `fct_reorder()` takes two main arguments: a) the factor (or column) whose levels you want to modify, and b) a numeric vector (or column of values) that you want to use to reorder the levels.

```r
fct_reorder(what_you_are_reordering, the_col_to_base_it_on)
```

## Reorder princess

While we could do this in the ggplot code, I find it's easiest to do in the data frame as we shape our data. So, go back up to where we made the `princes_count` data frame and add a new pipe like this:

```r
princess_count <- survey %>%
  count(princess) %>%
  rename(votes = n) %>%
  arrange(desc(votes)) %>% 
  mutate(princess = fct_reorder(princess, votes)) # this line reorders the factors
```

The data frame won't look any different but if you re-run the ggplot code chunk, you graphic will be reordered.

![Popular princess](images/factors-graphic-example.png)

## Factors recap

Factors in R allow us to apply "levels" to sort categorical data into a logical order beyond alphabetical.

If you are building a graphic that uses a categorical column as one of your aesthetics, then you might need to reorder the factor  using `fct_reorder()` or one of the other functions. It's easiest to do that using dplyr's `mutate()` function on your data frame before you plot.

## Practice: Make an ice cream chart

Make the same chart as above, but using the `ice_cream` counts. Order the column chart by the most popular ice cream.

### Turn in this project

- Save, knit and zip the project and turn it into the Canvas assignment for "Factors".

## Resources

These resources can help you understand the concepts.

- This post on [Reordering a variable in ggplot](https://www.r-graph-gallery.com/267-reorder-a-variable-in-ggplot2/) helped me understand how to reorder factors for graphics.
- Hadley Wickam's R for Data Science has a [Chapter on factors](https://r4ds.had.co.nz/factors.html). For those who _really_ want to learn more about them later.



