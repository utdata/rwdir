# Tidy data {#tidy}

## Goals for this session

- Explore the [tidyr](https://tidyr.tidyverse.org/) package to reshape data.
- Learn `gather()`, `spread()` and other tidyr verbs.
- Introduce the RSocrata package to download data using an API.

## What is tidy data

"Tidy"" data is well formated so each variable is in a column, each observation is in a row and each value is a cell.

![Tidy data](images/tidy-example.png)

![A tidy table](images/tidy-table-manipulate.png)

![A tidy table](images/tidy-table-nottidy.png)

When our data is tidy, we can use the [tidyr](https://tidyr.tidyverse.org/) package to reshape the layout of our data to suit our needs.

![Tidy verbs](images/tidy-verbs.png){width=600px}


About shaping data with tidyr.

For the practice assignment, we'll continue to use census so we can gather the data and then build a tabyl or something.

alcohol data should be good for this because we can spread and gather alcohol, etc.

Let's also add summary(), hist(), boxplot() and plot() to this. Maybe a whole thing on "exploring data".
