# Graphics {#graphics}

[ggplot2](https://ggplot2.tidyverse.org/) is the data visualization library within Hadley Wickham's [tidyverse.](https://www.tidyverse.org/). It uses a concept called the Grammar of graphics, the idea that you can build every graph from the same components: a data set, a coordinate system, and geoms -- the visual marks that represent data points. With a hat tip to [Matt Waite](http://www.mattwaite.com/), the main concepts are: 

- **aesthetics**: which in this case means the data which we are going to plot
- **geometries**: which means the shape the data is going to take
- **scales**: which means any transformations we might make on the data
- **layers**: which means how we might lay multiple geometries over top of each other to reveal new information.
- **facets**: which means how we might graph many elements of the same dataset in the same space

The challenge to understand here is for every graphic, we start with the data, and then describe how to layer plots or pieces on top of that data.

## Set up our Notebook

- Create a new RNotebook. Title it "Wells visualizations" and name the file `04-charts.Rmd`.
- Load the following libraries: tidyverse, lubridate.
- Import our `wells_03.rds` data,

```r
library(tidyverse)
library(lubridate)
wells <- readRDS("data-out/wells_03.rds")
```

## Wells per county

For our first graphic, we will plot how many wells were drilled in each county.

### Shape our data

If we are plotting wells per county, we need to first build a data frame that counts the number of wells for each county. We can use the same `count()` function that we used when we cleaned our data.

```r
wells_by_county <- wells %>% 
  count(county) %>% 
  rename(wells_count = n)
wells_by_county
```

Let's break this down:

- The first line creates the new data frame `wells_by_county`, starting with our `wells` data frame.
- We apply the `count()` function on the "county" column. This makes our basic pivot table.
- On the third line, we rename the "n" column that was created by `count()`, so it is more descriptive, calling it `wells_count`.
- So now we have a data frame with two columns: **county** and **wells_count**. We print it on the fourth line so we can inspect it.

### The basic ggplot template

The template for a basic plot is this. (The `<>` signify we are inserting values there.)

```r
ggplot(data = <DATA>) +
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
```

- **ggplot()** is our function. We feed into it the data we wish to plot.
- The **+** is the equivalent of `%>%` in our tidyverse data. It means we are adding a layer, and it should always be at the end of the line, not at the beginning of the next.
- **<GEOM_FUNCTION>** is the type of chart or addition we are adding. They all start with the term **geom_** like **geom_bar**, which is what we will build.
- The geometric function requires "aesthetics" to describe what it should look like, the main one being the **mapping** of the x and y axis.

There are two ways to simplify this:

- It is implied that the first thing fed to `ggplot` is the data, so you don't have to write out `data =` unless there is ambiguity.
- The `aes()` values are also implied as mappings, so you don't have to write out `mapping =` unless there is ambiguity.
- And lastly, if the mappings are the same for all the geoms, you can put them in the ggplot line.

```r
ggplot(<DATA>, aes(<MAPPINGS>)) +
  <GEOM>(<ADDITONAL_MAPPINGS>)
```

### Plot our wells by county

Here is the verbose plot for our counties.

```r
ggplot(data = wells_by_county) +
  geom_bar(mapping = aes(x = county, y = wells_count), stat = "identity")
```

- On the first line we tell `ggplot()` that we are using the we `wells_by_county` data.
- On the next, we apply the `geom_bar()` function to make a bar chart. It needs two things:
    + The mapping, which are the aesthetics. We well it to plot **county** on the x (horizontal) axis, and **wells_count** on the y (vertical) axis. Because **county** is not a number, we have to use the `stat = "identity"` value to describe that we are using values within county. This is a special thing for bar charts.

![Basic county plot](images/visualize-county-plot.png){width=500px}

Our less verbose way to do this looks like this:

```r
ggplot(wells_by_county, aes(x=county, y=wells_count)) +
  geom_bar(stat = "identity")
```

### Add a layer of text labels

For each new thing that we add to our graphic, we add it with `+`. In this case, we want to add number labels to show the wells_count for that county.

```r
ggplot(data = wells_by_county, aes(x = county, y = wells_count)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=wells_count), vjust=-0.25)
```

![Basic county plot](images/visualize-county-plot-labels.png){width=500px}

In this case, we are just adding another layer, the `geom_text()`. It requires some additional aesthetics, like what label we want to use. The `vjust=` moves the numbers up a little. Change the number and see what happens.

The last layer we want to add here is a Title layer. The function for labels is called `labs()` and it takes an argument of `title = ""` You can also change your `x` and `y` axis names, etc.

```r
  ... +
  labs(title = "Number of wells drilled by county")
```

Congratulations! You made your first `ggplot()` chart. Not particularly revealing, but it does show that Travis County has WAY more wells than the other counties.

Let's see how those trends play out over time.

## Wells per county over time

Our next chart will be a line chart to show how the number of wells drilled has changed over time within each county.

Again, it will help us to think about what we are after and then build our data frame to match. In this case, we want to plot the "number of wells" for each county, by year. That means we need columns for county, year and number of wells. To get that, we have to use group and summarize.

Sometimes it helps to write out the steps of everything before you to do it.

- Start with the `wells` data frame.
- Filter to 2003 or later, because that's when the [system came online](http://www.twdb.texas.gov/groundwater/data/drillersdb.asp).
- Group by the `county` and `year_drilled` fields.
- Summarize to create a count the number of `wells_drilled`.
- Set all of the above to a new data frame, `wells_county_year`.
- Start a plot with the new data.
- Set x (horizontal) to be year_drilled and y (vertical) to be wells_drilled, and color to be the county.

### Work up the data frame

```r
wells %>% 
  filter(year_drilled >= 2003) %>% 
  group_by(county, year_drilled) %>% 
  summarise(
    wells_drilled = n()
  )
```

This gives you a table similar to this:

| county   | year_drilled | wells_drilled |
|:---------|:-------------|--------------:|
| Bastrop  | 2003         |           110 |
| Bastrop  | 2004         |            99 |
| Bastrop  | 2005         |            97 |
| ...      | ...          |           ... |
| Caldwell | 2003         |            40 |
| Caldwell | 2004         |            32 |
| Caldwell | 2005         |            40 |

We call this _long_ data, because each row contains a single observation, instead of _wide_ data, which would have a column for each observation.

Once you are have the data formatted, set it to fill a new data frame called `wells_county_year`.

### Draw the plot

Remember the formula for a basic plot:

```r
ggplot(<DATA>) +
  <GEOM_FUNCTION>(aes(<MAPPINGS>))
```

and if all our mappings are the same, they can go into the ggplot function.

```r
ggplot(wells_county_year, aes(x = year_drilled, y = wells_drilled, color = county)) +
  geom_line()
```

![Wells drilled by county by year](images/visualize-county-year-line.png){width=500px}

How easy would it be to add points for every year to make each data point stand out?

### Your turn: Add layers

- Add a new layer `geom_point()` and see what happens
- Add a labels layer to add a title, like we did in the bar chart above.

### Dates as numbers and the problems they cause

There was one point during my work on this graphic when my x axis did not fall evenly on years, and I figured it was because the `year_drilled` field was a number and not a date. It's possible to fix that by including the `library(lubridate)` and then mutating the year_drilled column like this:

```r
  mutate(
    year_drilled = ymd(year_drilled, truncated=2L)
  ) %>%
```

## Review of ggplot

Exploring with graphics are one of the more powerful features of working with R. It takes a bit to get used to the Grammar of Graphics and ggplot2 and it will be frustrating at first. But be assured it can do about anything once you learn how, and being able to fold in these charts with your thoughts and analysis in a repeatable way will make you a better data journalist.

## Resources and further reading

- [R Graphics Cookbook](http://www.cookbook-r.com/Graphs/)
- [The ggplot2 documentation](http://ggplot2.tidyverse.org/reference/index.html)
- [ggplot2 cheatsheets](https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf)
- Note [This article about BBC using R, ggplot](https://medium.com/bbc-visual-and-data-journalism/how-the-bbc-visual-and-data-journalism-team-works-with-graphics-in-r-ed0b35693535). BBC created the [bblot](https://github.com/bbc/bbplot) package to set BBC default styles, and [BBC R cookook](https://bbc.github.io/rcookbook/) as a collection of tips and tricks to build their styled graphics.

