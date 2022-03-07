# Deeper into ggplot {#ggplot-more}

The chapter is by Prof. Lukito, who uses a PC.

In the last chapter, you were introduced to [ggplot2](https://ggplot2.tidyverse.org/index.html), the `tidyverse` package that helps you build graphics, charts, and figures. In this chapter, we'll take your `ggplot` knowledge to the next level. We encourage you to treat this chapter as a reference.

## References

`ggplot2` has a LOT to it and we'll cover only the basics. Here are some references you might use:

- [ggplot cheatsheet](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf)
- [R for Data Science](https://r4ds.had.co.nz/index.html)
- [R Graphics Cookbook](https://r-graphics.org/)
- [The R Graph Gallery](https://www.r-graph-gallery.com/) another place to see examples.
- [ggplot2: Elegant graphics for Data Analysis](https://ggplot2-book.org/index.html)


## Learning goals for this chapter

In this chapter, we will cover the following topics:

- How to prepare and build a line chart  
- How to use themes to change the looks of a chart  
- More about aesthetics in layers!  
- Faceting, or making multiple charts from the same data  
- How to save files  
- How to make interactive plots with `Plotly`  

## Set up your notebook

This week, we'll return to our `leso` data, but start a new RNotebook. Let's open our “yourname-military-surplus” R project first, and then create a new RNotebook. Do this:

1. Create your RNotebook.
2. Rename the title "Military Surplus figures"
3. Remove the rest of the boilerplate template.
4. Save the file and name it `03-ggplot.Rmd`.
5. Load the `tidyverse` library.



We'll also load the `lubridate` package, which we used previously.



### Let's get the data

> We'll demonstrate this in class, but you can also follow along in the screencast.

Next, let's read in the `leso.csv` dataset, which we imported in [5.4.4](https://utdata.github.io/rwdir/sums-import.html#import-the-data-1). We'll do this using `read_csv()`.

<details>
  <summary>You should be able to do this on your own. Really!</summary>


```r
leso <- read_csv("data-raw/leso.csv") #read the data in
```

```
## Rows: 124848 Columns: 12
```

```
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr  (7): state, agency_name, nsn, item_name, ui, demil_code, station_type
## dbl  (4): sheet, quantity, acquisition_value, demil_ic
## dttm (1): ship_date
```

```
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
glimpse(leso) #peek at the data
```

```
## Rows: 124,848
## Columns: 12
## $ sheet             <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"~
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A~
## $ nsn               <chr> "2540-01-565-4700", "1240-DS-OPT-SIGH", "1005-01-587~
## $ item_name         <chr> "BALLISTIC BLANKET KIT", "OPTICAL SIGHTING AND RANGI~
## $ quantity          <dbl> 10, 1, 10, 9, 10, 1, 1, 1, 1, 1, 1, 1, 3, 12, 1, 5, ~
## $ ui                <chr> "Kit", "Each", "Each", "Each", "Each", "Each", "Each~
## $ acquisition_value <dbl> 15871.59, 245.88, 1626.00, 333.00, 926.00, 658000.00~
## $ demil_code        <chr> "D", "D", "D", "D", "D", "C", "C", "Q", "D", "C", "C~
## $ demil_ic          <dbl> 1, NA, 1, 1, 1, 1, 1, 3, 7, 1, 1, NA, 1, 1, 1, 1, 1,~
## $ ship_date         <dttm> 2018-01-30, 2016-06-02, 2016-09-19, 2016-09-14, 201~
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"~
```

</details>

Don't forget to also do the other processing steps we did in [Chapter 5](https://utdata.github.io/rwdir/sums-import.html#create-a-total_value-column).

<details>
  <summary>Again, you should be able to do this on your own</summary>

Buuuut, if you needed a refresher, check out section [5.4.6](https://utdata.github.io/rwdir/sums-import.html#remove-unnecessary-columns) to [5.4.7](https://utdata.github.io/rwdir/sums-import.html#create-a-total_value-column). There are 2 steps to this:

- Removing unnecessary columns using `select()`  
- Creating a `total_value` column using `mutate()`  


```r
leso_tight <- leso %>% 
  select(
    -sheet,
    -nsn,
    -starts_with("demil")
  ) #this chunk removes unnecessary columns

leso_total <- leso_tight %>% 
  mutate(total_value = quantity * acquisition_value) #this chunk creates a total_value column
```

</details>

Alrighty! Let's look at the data


```r
leso_total %>% glimpse()
```

```
## Rows: 124,848
## Columns: 9
## $ state             <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"~
## $ agency_name       <chr> "ABBEVILLE POLICE DEPT", "ABBEVILLE POLICE DEPT", "A~
## $ item_name         <chr> "BALLISTIC BLANKET KIT", "OPTICAL SIGHTING AND RANGI~
## $ quantity          <dbl> 10, 1, 10, 9, 10, 1, 1, 1, 1, 1, 1, 1, 3, 12, 1, 5, ~
## $ ui                <chr> "Kit", "Each", "Each", "Each", "Each", "Each", "Each~
## $ acquisition_value <dbl> 15871.59, 245.88, 1626.00, 333.00, 926.00, 658000.00~
## $ ship_date         <dttm> 2018-01-30, 2016-06-02, 2016-09-19, 2016-09-14, 201~
## $ station_type      <chr> "State", "State", "State", "State", "State", "State"~
## $ total_value       <dbl> 158715.90, 245.88, 16260.00, 2997.00, 9260.00, 65800~
```

Lookin' good!

## Wrangle the data

To prepare the data for visualizing, we need to do a couple more new things. This is going to take several steps, which we will pipe together.

1. `filter` the data to focus on more recent data. Let's specifically consider military surplus in 2010 and after.
2. And then, create a `year` variable using the `year()` function. `year()` is a function in `lubridate` that allows us to aggregate  
3. And then, `select` a few variables to study (specifically, `year`, `total_value`, `state`, and `agency_name`)


```r
leso_total <- leso_total %>%
  filter(ship_date >= as.Date("2010-01-01")) %>%
  mutate(year = year(ship_date)) %>% #if you get an error, make sure you've loaded the lubridate library!
  select(year, total_value, state)

glimpse(leso_total)
```

```
## Rows: 84,605
## Columns: 3
## $ year        <dbl> 2018, 2016, 2016, 2016, 2017, 2016, 2016, 2017, 2017, 2016~
## $ total_value <dbl> 158715.90, 245.88, 16260.00, 2997.00, 9260.00, 658000.00, ~
## $ state       <chr> "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL", "AL"~
```

There's a lot of information in this data, so let's focus our visualizing on Texas, like we did in our previous chapters. We'll do this by `filter`ing the rows where `state == "TX"`.


```r
leso_texas <- leso_total %>% 
  filter(state == "TX")
```

Now that we have our data in a nice structure, with some yearly information, let's use our GSA process (`group_by() %>% summarize() %>% arrange()`). In this process, we'll `group by` year (the variable we have just created), `summarize` a the total value of the military surplus (by year) and arrange that information chronologically. 


```r
leso_texas_gsa <- leso_texas %>%
  group_by(year) %>%
  summarize(yearly_cost = sum(total_value)) %>%
  arrange(year)

head(leso_texas_gsa) #use head() to view the first 6 rows of this new data frame
```

```
## # A tibble: 6 x 2
##    year yearly_cost
##   <dbl>       <dbl>
## 1  2010    7018530.
## 2  2011    2707371.
## 3  2012    4938685.
## 4  2013   11573720.
## 5  2014   45836900.
## 6  2015    3456193.
```

We may come back to the data to fix some stuff but for now, we're ready to plot!

> If any of these steps are confusing to you, we encourage you to go back to [Chapter 5 and 6](https://utdata.github.io/rwdir/sums-import.html#about-the-story-military-surplus-transfers).

## Make a line chart of the Texas data

Data visualization is an iterative process: you may prepare the data, do the visualization, and then realize you want to prepare the data a different way. Remember that the process of coding can involve trial and error: you're often testing different thing to see what works.

### Plot the chart

Alright, so now let's get ready to use the `ggplot()` function. I want you to create the plot here one step at a time so you can review how the layers are added.

In this new plot, we'll learn about a new `geom` layer: `geom_line()` (recall that in [Chapter 7](https://utdata.github.io/rwdir/ggplot-intro.html), we learned about `geom_point()` and `geom_col()`).

1. Add and run the ggplot() line first (but without the `+`)
2. Then add the `+` and the `geom_point()` and run it.
3. Then add the `+` and `geom_line()` and run it.
4. Then add the `+` and `labs()`, and run everything.


```r
ggplot(leso_texas_gsa, aes(x = year, y = yearly_cost)) + #we create the graph
  geom_point() + #adding the points
  geom_line() + #adding the lines between the points
  labs(title = "Yearly Law Enforcement Support Office Data, Texas", 
       x = "Year", y = "Cost of acquisitions")
```

<img src="08-plots-more_files/figure-html/unnamed-chunk-4-1.png" width="672" />

### Cleaning Up

Alright, so we have a working plot! But there's a couple things that are a bit ugly about this plot. First, I'm not digging the weird numbers on the side (what the heck does `0.0e+00` even mean?!). To fix this, let's go back to our data and do a bit more preparing. If we use `head()` to look at our data, we'll notice that there are a few numbers that are just really, really big.


```r
head(leso_texas_gsa) #use head() to view the first 6 rows of this new data frame
```

```
## # A tibble: 6 x 2
##    year yearly_cost
##   <dbl>       <dbl>
## 1  2010    7018530.
## 2  2011    2707371.
## 3  2012    4938685.
## 4  2013   11573720.
## 5  2014   45836900.
## 6  2015    3456193.
```

These large numbers are causing R to read our numbers as "scientific notation" (a math-y way of reading large numbers). For example, the total cost of supplies in February 2010 was `5,399,589.0` (that's the first spike in our figure, around the `5.0e + 06` mark). But what a pain to read!

To get around this, let's divide our `yearly_cost` variable (in the `leso_tx_gsa` data frame) by 1 million. Just like we round our numbers when we write about data, so too do we often round numbers when we visualize it. In the line below, we use `mutate()` to divide `yearly_cost` by 1,000,000.


```r
leso_texas_gsa <- leso_texas_gsa %>%
  mutate(yearly_cost = yearly_cost/1000000) #divide by 1 million

head(leso_texas_gsa)
```

```
## # A tibble: 6 x 2
##    year yearly_cost
##   <dbl>       <dbl>
## 1  2010        7.02
## 2  2011        2.71
## 3  2012        4.94
## 4  2013       11.6 
## 5  2014       45.8 
## 6  2015        3.46
```

Now, let's re-visualize our data. Notice that in the `labs` layer below, we add some new information to the `y-axis`, so people know that the `5` here refers to `5 million`.


```r
ggplot(leso_texas_gsa, aes(x = year, y = yearly_cost)) + #we create the graph
  geom_point() + #adding the points
  geom_line() + #adding the lines between the points
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas", 
       x = "Year", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")
```

<img src="08-plots-more_files/figure-html/unnamed-chunk-7-1.png" width="672" />

Our chart is looking much better!

### Saving plots as an object

Sometimes it is helpful to push the results of a plot into an R object to "save" those configurations. You can continue to add layers to this object, but you won't need to rebuild the main portions of the chart each time. We'll do that here so we can explore themes next.

1. Edit your Texas plot chunk you made earlier to save it into an R object, and then call `tx_plot` after it so you can see it.


```r
# the line below saves the graph results into tx_plot
tx_plot <- ggplot(leso_texas_gsa, aes(x = year, y = yearly_cost)) + 
  geom_point() + 
  geom_line() +
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas", 
       x = "Year", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")

# Since we saved the plot into an R object above, we have to call it again to see it.
# We save graphs like this so we can reuse them.
tx_plot
```

<img src="08-plots-more_files/figure-html/tx-plot-create-1.png" width="672" />

We can continue to build upon the `tx_plot` object like we do below with themes, but those changes won't be "saved" into the R environment unless you assign it to an R object.

## Themes

The _look_ of the graph is controlled by the theme. There are a number of preset themes you can use. Let's look at a couple.

1. Create a new section saying we'll explore themes.
2. Add the chunk below and run it.


```r
tx_plot +
  theme_minimal()
```

<img src="08-plots-more_files/figure-html/theme-minimal-1.png" width="672" />

This takes our existing `tx_plot` and then applies the `theme_minimal()` look to it.

There are a number of themes built into ggplot, most are pretty simplistic.

1. Edit your existing chunk to try different themes. Some you might try are `theme_classic()`, `theme_dark()` and `theme_void()`. 

### More with ggthemes

There are a number of other packages that build upon `ggplot2`, including [`ggthemes`](https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/).

1. In your R console, install the `ggthemes` package using the `install.packages()` function: `install.packages("ggthemes")`
2. Add the `library(ggthemes)` at the top of your current chunk.
3. Update the theme line to view some of the others options noted below.


```r
library(ggthemes)
tx_plot +
  theme_economist()
```

<img src="08-plots-more_files/figure-html/theme-economist-1.png" width="672" />


```r
tx_plot +
  theme_fivethirtyeight()
```

<img src="08-plots-more_files/figure-html/theme-538-1.png" width="672" />


```r
tx_plot +
  theme_stata()
```

<img src="08-plots-more_files/figure-html/theme-stata-1.png" width="672" />

### There is more to themes

There is also a `theme()` function that allows you individually [adjust about every visual element](https://ggplot2.tidyverse.org/reference/theme.html) on your plot.

We do a wee bit of that later.

## Adding more information

OK, our Texas military surplus information is fine ... but how does that compare to neighboring states? Let's work through building a new chart that shows all those steps.

### Prepare the data

We need to go back to our original `leso_total` to get the additional states.

1. Start a new section that notes we are building a chart for five states (Texas, Oklahoma, Arkansas, New Mexico, and Louisiana)
2. Prepare the data using the `%in%` filter that we learned about in [Chapter 6](https://utdata.github.io/rwdir/sums-analyze.html#looking-a-local-agencies). Rather than creating a separate list, we're going to write the list right into the `filter()` function using `c()`.


```r
leso_five <- leso_total %>% 
  filter(
    state %in% c("TX", "OK", "AR", "NM", "LA")
  )

leso_five
```

```
## # A tibble: 11,546 x 3
##     year total_value state
##    <dbl>       <dbl> <chr>
##  1  2021        421. AR   
##  2  2021      44478  AR   
##  3  2021       4977. AR   
##  4  2021        168  AR   
##  5  2021        232. AR   
##  6  2018       1918  AR   
##  7  2021          0  AR   
##  8  2015       3861  AR   
##  9  2013      89900  AR   
## 10  2014      89900  AR   
## # ... with 11,536 more rows
```

Now that we have our five states, let's GSA this information, like we did earlier (but for all 5 states and not just Texas).

<details>
  <summary>Again, this should be a refresher!</summary>


```r
leso_five_gsa <- leso_five %>%
  group_by(state, year) %>% #groups by state AND year
  summarize(yearly_cost = sum(total_value)) %>% 
  mutate(yearly_cost = yearly_cost/1000000) #divide by 1 million
```

```
## `summarise()` has grouped output by 'state'. You can override using the `.groups` argument.
```

```r
leso_five_gsa %>% glimpse()
```

```
## Rows: 55
## Columns: 3
## Groups: state [5]
## $ state       <chr> "AR", "AR", "AR", "AR", "AR", "AR", "AR", "AR", "AR", "AR"~
## $ year        <dbl> 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019~
## $ yearly_cost <dbl> 0.00207600, 0.70035335, 0.67255778, 2.77192930, 12.0723892~
```

</details>

### Plot multiple line chart

For our next plot, we'll add a different line for each state. To do this you would use the color aesthetic `aes()` in the `geom_line()` geom. Recall that geoms can have their own `aes()` variable information. This is especially useful for working with a third variable (like when making a stacked bar chart or line plot with multiple lines). Notice that the color aesthetic (meaning that it is in `aes`) takes a variable, not a color. You can learn how to change these colors [here](http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually). For now, though, we'll use the `ggplot` default colors.

1. Add a note that we'll now build the chart.
2. Add the code chunk below and run it. Look through the comments so you understand it.


```r
ggplot(leso_five_gsa, aes(x = year, y = yearly_cost)) + 
  geom_point() +
  geom_line(aes(color = state)) + # The aes selects a color for each state
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas and Boardering States", 
       x = "Yearly", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")
```

<img src="08-plots-more_files/figure-html/five-hied-lcolor-1.png" width="672" />

Notice that R changes the color of the line, but not the point? This is because we only included the aesthetic in the `geom_line()` geom and not the `geom_point()` geom.

1. Edit your `geom_point()` to add `aes(color = state)`.


```r
ggplot(leso_five_gsa, aes(x = year, y = yearly_cost)) + 
  geom_point(aes(color = state)) +
  geom_line(aes(color = state)) + # The aes selects a color for each state
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas and Boardering States", 
       x = "Year", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")
```

<img src="08-plots-more_files/figure-html/five-hied-pcolor-1.png" width="672" />

## On your own: Line chart

I want you to make a line chart of military surplus acquisitions in three states that are **different** from the five we used above. This is very similar to the chart you just made, but with different values.

Some things to do/consider:

1. Do this in a new section and explain it.
2. You'll need to prepare the data just like we did above to get the right data points and the right states.
3. I really suggest you build both chunks (the data prep and the chart) one line at a time so you can see what each step adds.

## Tour of some other adjustments

You don't have to add these examples below to your own notebook, but here are some examples of other things you can control.

### Line width


```r
ggplot(leso_five_gsa, aes(x = year, y = yearly_cost)) + 
  geom_point(aes(color = state)) +
  geom_line(aes(color = state), size = 1.5) + #make the lines thicker here
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas and Boardering States", 
       x = "Year", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")
```

<img src="08-plots-more_files/figure-html/line-width-1.png" width="672" />

### Line type

This example removes the points and adds a `linetype = state` to the ggplot aesthetic. This gives each state a different type of line. We also set the color in the `geom_line()`


```r
ggplot(leso_five_gsa, aes(x = year, y = yearly_cost)) + 
  geom_point(aes(color = state)) +
  geom_line(aes(color = state, linetype = state), size = 0.75) + #changes the line type
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas and Boardering States", 
       x = "Year", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")
```

<img src="08-plots-more_files/figure-html/line-type-1.png" width="672" />

Notice that when you put the information `geom_line(aes())` (like with `color` and `linetype`), this varies the color and linetype of the lines, whereas `size` is consistent for all the lines.

### Adjust axis

`ggplot()` typically makes assumptions about scale. Sometimes, you may want to change it though (e.g., make them a little larger). There are a couple different ways to do this. The most straightforward may be `xlim()` and `ylim()`.


```r
ggplot(leso_five_gsa, aes(x = year, y = yearly_cost)) + 
  geom_point(aes(color = state)) +
  geom_line(aes(color = state, linetype = state), size = 0.75) + #changes the line type
  xlim(2009, 2022) + # sets minimum and maximum values on axis
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas and Boardering States", 
       x = "Year", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")
```

<img src="08-plots-more_files/figure-html/adjust-axis-1.png" width="672" />
The function `xlim()` and `ylim()` are shortcuts for `scale_x_continuous()` and `scale_y_continuous()` which [do more things](https://ggplot2.tidyverse.org/reference/scale_continuous.html#examples).

## Facets

Facets are a way to make multiple graphs based on a variable in the data. There are two types, the `facet_wrap()` and the `facet_grid()`. There is a good explanation of these in [R for Data Science](https://r4ds.had.co.nz/data-visualisation.html?q=facet#facets).

We'll start by creating a base graph and then apply the facet. 

1. Start a new section about facets
2. Add the code below to create your chart and view it. This is the same plot we've already created


```r
five_plot <- ggplot(leso_five_gsa, aes(x = year, 
                          y = yearly_cost)) + 
  geom_point(aes(color = state)) +
  geom_line(aes(color = state)) + 
  labs(title = "Yearly Value of Military Surplus Acquisitions in Texas and Boardering States", 
       x = "Year", y = "Cost of acquisitions (in millions)",
       caption = "Source: Law Enforcement Support Office")

five_plot
```

<img src="08-plots-more_files/figure-html/facet-data-1.png" width="672" />

### Facet wrap

The `facet_wrap()` function splits your chart based on a single variable. To use the `facet_wrap()` function, you need one argument: a `~` followed by a space and the variable you want to split by (in the chart below, this will be the `state` variable).

Like with our themed plots, we'll use a `+` to add this `facet_wrap()` layer to our previously created line graph.

1. Add a new chunk and include our previously created plot
2. Use the `+` in the next line to "pipe" in a `facet_wrap()` layer.
3. (We also use a `theme` layer to remove the legend. See what happens when you comment this out!)


```r
five_plot +
  facet_wrap(~ state) +
  theme(legend.position = "none") # this line removes the legend. Try it without it!
```

<img src="08-plots-more_files/figure-html/facet-wrap-1.png" width="672" />

A couple of notes about the above code:

- Note the comment in the code above where we used the `theme()` function to remove the legend.
- You can specify the number of rows or columns of the grouping by adjusting the facet_wrap() function: `facet_wrap(~ state, nrow = 2)` or `facet_wrap(~ state, ncol = 2)`. Try them!

### Facet grids

A `facet_grid()` allows you to plot on a combination of variables. We don't really have two numbers to compare in our higher education data so we'll show this with the `mpg` data we've used before.

1. Start a new section noting you'll try facet grid.
2. Add the chunk below and run it. Notice here that we are putting our `aes()` layer in `geom_point()`. 

Explanations follow the chart.


```r
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + # add points to the chart
  facet_grid(drv ~ cyl) # splits into charts by drive train and cylinder
```

<img src="08-plots-more_files/figure-html/facet-grid-1.png" width="672" />

This chart is kinda hard to read, but let's try:

- Inside the mini charts, the best gas mileage is toward the top (from `hwy`) and the smaller engines are to the left (from `displ`.)
- The rows of charts are divided by drive train `drv`: four-wheel drive, front-wheel drive and rear-wheel drive.
- The columns of charts are divided by cylinders: like a 4-cylinder car vs 8-cylinder car.

This chart tells us that 4-cylinder, front-wheel drive cars with smaller engines get the best gas mileage. The blank charts mean that combination of values didn't exist in the data.

## On your own: Facet wrap

1. Create a section about doing a facet wrap on your own.
1. Take the "On your own" plot that you made earlier (The other states that you chose) and apply a `facet_wrap()` here. You were instructed to save the plot into an R object, so you should be able to use that.
1. Remove the legend since each mini chart is labeled.

## Saving plots

To save plots as images, you can right-click plots that you make in RNotebooks. Or, you can use the export button in the Plot pane. Or (and this is a preferred strategy), you can save them using `ggsave()`. ([Learn more here](https://ggplot2.tidyverse.org/reference/ggsave.html)).

1. Use your Files pane to create a new folder called "images" so we can save our chart there.
2. Start a section on saving plots and add the following chunk.


```r
ggsave("images/txplot.png", plot = tx_plot)
```

```
## Saving 7 x 5 in image
```

Using `ggsave` creates a higher-res image than other methods. It needs:

- The path and name of the image, in quotes
- the `plot =` variable to say which plot you are saving. (Your plot must already be saved into an R object for this method to work.)

## Interactive plots

Want to make your plot interactive? You can use [plotly](https://plotly.com/r/)'s `ggplotly()` function to transform your graph into an interactive chart.

To use plotly, you’ll want to install the plotly package, add the library, and then use the ggplotly() function:

1. In your R Console, run `install.packages("plotly")`. (You only have to do this once on your computer.)
1. Add a new section to note you are creating an interactive chart.
2. Add the code below and run it. Then play with the chart!

```r
library(plotly)

tx_plot %>% 
  ggplotly()
```

(We can't show the interactive version in this book.)

Now you have tool tips on your points when you hover over them.

The `ggplotly()` function is not perfect. Alternatively, you can use plotly's own syntax to build some quite interesting charts, but it's a whole [new syntax to master](https://plotly.com/r/).

## What we learned

There is so much more to `ggplot2` than what we've shown here, but these are the basics that should get you through the class. At the top of this chapter are a list of other resources to learn more.

