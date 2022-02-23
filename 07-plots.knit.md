# Data Viz - Intro to ggplot {#ggplot-intro}

The chapter is by Prof. Lukito, who uses a PC.

This week, we'll move on from summaries to talking about data visualizations ("data viz"), an essential skill for any data journalist. While there are a lot of different ways to make figures and graphs, this chapter will focus on one popular R package for data viz: `ggplot`.

## Goals for this section

In this chapter, we'll learn the basics of **data visualization** using the Grammar of Graphics principles. We'll start with some smaller datasets to give you a sense of how the code works. And, in the next chapter, you'll apply this to a dataset we have already used in the class.

Our learning goals are:

- To learn about the Grammar of Graphics
- To make scatterplots
- To make bar charts

## Introduction to ggplot

[ggplot2](https://ggplot2.tidyverse.org/) is the data visualization library within Hadley Wickham's [tidyverse](https://www.tidyverse.org/). It is **a beast** of a package, because it supports a whole variety of different types of data visualizations, from [bar charts](https://www.r-graph-gallery.com/histogram.html) and [line charts](https://www.r-graph-gallery.com/connected-scatterplot.html) to fancy [choropleth maps](https://www.r-graph-gallery.com/choropleth-map.html) and [animated figures](https://www.r-graph-gallery.com/animation.html).  

Even though the package is called `ggplot2`, the function to make graphs is just `ggplot()`. So, for simplicity, we'll just call everything `ggplot`

The `ggplot` package relies on a concept called the [Grammar of Graphics](https://byrneslab.net/classes/biol607/readings/wickham_layered-grammar.pdf), hence the `gg` in `ggplot`. The basic logic of the Grammar of Graphics is that any graph you could ever want to build will need similar things: a data set, some information about the scales of your variables, and the type of figure or graph that you want to create. These various things can be "layered" on top of each other to create a visually pleasing graph.  

Folks who have used Adobe creative programs (e.g., Photoshop, Illustrator, etc.) can think about it like laying an image: each layer in your image *should do something* to change the image. Likewise, each layer in a `ggplot` figure will add to the overall graph.

### What I like/dislike about ggplot

Let me just start by saying that I'm a total `ggplot` geek. I'll talk about `ggplot` figures the way people talk about new TikTok trends. When producing figures and graphs in R, `ggplot` is the **absolute best approach** because you'll see the results right in your R notebook. And, basic data visualizations are an absolutely essential skill for any data journalist: it helps you find important things in your data that you may ultimately report on. So, `ggplot` is important for any R-based data journalism project.

That being said, there are less complicated ways of creating publishable graphics. Tools like [Datawrapper](https://www.datawrapper.de/) and [Flourish](https://flourish.studio/) can produce equally beautiful graphics without the code. So why learn `ggplot`? Because, **(1)** `ggplot` is super useful when you're just learning about the data and **(2)** to get good enough in `ggplot` to make publishable graphics, you have to practice, practice, practice. Yes, `ggplot` is a big package with lots of nuiance. But the more you take the time to learn it, the more you will master it.

### The Grammar of Graphics

This section was inspired by [Matt Waite](http://www.mattwaite.com/) and the [BBC Visual Cookbook](https://bbc.github.io/rcookbook/).

As I said above, the `gg` in `ggplot` stands for "Grammar of Graphics," which is a fancy way of saying we'll build our charts layer by layer. Once you know what data you are using, there are three main layers to any `ggplot` chart:

- **aesthetics** ("aes"): this is where you put information about the dataset, including specifics about what fields/variables should  be on the x-axis and y-axis.
- **geometries** ("geom"): this is where you tell R the shape of your visualization, whether it's lines, bars, points, or something else.
- **themes** ("theme"): this is where you tell R the font you'd like to use, the background color, and other things you want to "pretty up" the data viz.

In addition to these three main layers, there are lots of helper layers we'll learn about along the way, including:  

- **coord_flip**: a special layer for flipping the chart  
- **scales**: transforming the data to make the plot more read-able  
- **labels** ("labs"): for making titles and labels   
- **facets**: For graphing many elements of the same data set in the same space (one dataset, multiple figures)  

  This all may seem complicated now, but it'll make sense once we start putting together these layers together, one at a time. After all, the best way to learn any R package is to **do it**


## Start a new project

1. Get into RStudio and make sure you don't have any other files or projects open.
2. Create a new project, name it `yourname-ggplot` and save it in your rwd folder.
3. (No need for a folder structure, we'll do this all in one file.)
4. Start a new RMarkdown notebook and save it as `01-intro-ggplot.Rmd`.
5. Remove the boilerplate and create a setup section that loads `library(tidyverse)`, like we do with every notebook. The `ggplot` package is a part of `tidyverse`, so when you load `tidyverse`, you'll load `ggplot`.



## The layers of ggplot

> Much of this first plot explanation comes from Hadley Wickham's [R for Data Science](https://r4ds.had.co.nz/data-visualisation.html?q=aes#data-visualisation), with edits to fit the lesson here.

To explore how `ggplot` works, we're going to work with some data that already comes with `tidyverse`. Let's take a look at it now.

1. Start a new section "First plot" and add a code chunk.
2. Add the code below and run it to see what the `mpg` dataset looks like.


```r
mpg
```

```
## # A tibble: 234 x 11
##    manufacturer model      displ  year   cyl trans drv     cty   hwy fl    class
##    <chr>        <chr>      <dbl> <int> <int> <chr> <chr> <int> <int> <chr> <chr>
##  1 audi         a4           1.8  1999     4 auto~ f        18    29 p     comp~
##  2 audi         a4           1.8  1999     4 manu~ f        21    29 p     comp~
##  3 audi         a4           2    2008     4 manu~ f        20    31 p     comp~
##  4 audi         a4           2    2008     4 auto~ f        21    30 p     comp~
##  5 audi         a4           2.8  1999     6 auto~ f        16    26 p     comp~
##  6 audi         a4           2.8  1999     6 manu~ f        18    26 p     comp~
##  7 audi         a4           3.1  2008     6 auto~ f        18    27 p     comp~
##  8 audi         a4 quattro   1.8  1999     4 manu~ 4        18    26 p     comp~
##  9 audi         a4 quattro   1.8  1999     4 auto~ 4        16    25 p     comp~
## 10 audi         a4 quattro   2    2008     4 manu~ 4        20    28 p     comp~
## # ... with 224 more rows
```

The `mpg` data contains observations collected by the US Environmental Protection Agency on 38 models of cars. It's a data set embedded into the tidyverse for lessons like this one.

For this lesson, we'll use (at least two) two specific variables in this data:

- `displ`, a car’s engine size, in liters.
- `hwy`, a car’s fuel efficiency on the highway, in miles per gallon (mpg).

With these two variables, we can test the theory that cars with smaller engines (`displ`) get better gas mileage (`hwy`). To do this, we'll make a plot.

### Build the base layer

When working with the `ggplot2` package, you'll start nearly every figure with the `ggplot()` function. In the `ggplot()` function, you'll tell R what data you're using, and the coordinate system you want to build based on the data.

The first thing you'll want to do is tell `ggplot` the dataset you want to use (in this case, `mpg`). Let's do that now.

Do this:

1. In your first plot section, add some text that you are building the mpg chart.
2. Make a new code chunk and add the code below.


```r
ggplot(mpg)
```

<img src="07-plots_files/figure-html/mpg-prebase-1.png" width="672" />

This tells us... absolutely nothing! But that's not surprising: you haven't even told `ggplot` what variables you want to focus on or the way you want to visualize the data. To do that, you'll need a second argument (and the first official layer in your plot): the `aes()` (short for "aesthetic"). This is considered a `mapping` argument, because you use this argument to tell `ggplot` how you want to map your data (in our case, `mpg`).

In an `aes()` argument, you want to indicate the variables that you will be mapping to the x and y axes. This is usually done with the `x` and `y` arguments, so your `aes()` argument will look something like this: `aes(x = some_variable, y = another_variable)`, where `some_variable` and `another_variable` are variables in your dataset.

In our case, we'll practice using `displ` (the car's engine size) and `hwy` (the car's highway efficiency). Let's plug in our `aes()` layer now, directly into the `ggplot()` function.

Do this:

1. In the code chunk you created above, add the following line of code.


```r
ggplot(mpg, aes(x = displ, y = hwy))
```

<img src="07-plots_files/figure-html/mpg-base-1.png" width="672" />

Let's work through the code above:

- `ggplot()` is the function we use to make a chart.
- The first argument `ggplot()` needs is the data. It could be specified as `data = mpg` but we don't need the `data = ` part as it is always the first item specified inside of (or piped into) `ggplot()`
- Next is the **aesthetics** or `aes()`. This is where tell ggplot what data to plot on the `x` and `y` axis. You might see this as `mapping = aes(<VALUES>)` but we can often get by without the `mapping =` part.

This code tells us just a little bit more than nothing: instead of a blank box, we can now see the grid for the x and y axis. But we'll need another layer to add data to this grid!

A quick [FYI](https://en.wikipedia.org/wiki/FYI): The `aes()` that you put into `ggplot()` apply to the whole graph. Other (geom) layers that you write after this main layer can also take `aes()` arguments. We'll do that in future charts.

Now that we have our `ggplot()` argument and first layer done, let's talk about how to add layers to this.

### Layers can we add to our plots

Our base layer is the starting point for every `ggplot` chart, but it's certainly not the end. In the next section below, we'll work with three **types** of layers. Don't worry if this seems like a lot of information: we'll go layer by layer so you can see the whole process. 

Below are some of the layers we will work with:

- **geometries** (or "geoms" as we call them) are the way we plot data on the base grid. There are [many geoms](https://github.com/rstudio/cheatsheets/blob/master/data-visualization.pdf), but here are a few common ones:
    - `geom_points()` adds dots onto the grid based on the data. Will will use these here to build a scatterplot graph.
    - `geom_line()` adds lines between data points on the grid. Basically a line chart.
    - `geom_col()` and `geom_bars()` adds bars to the grid based on values in the data. A bar chart. We'll use `geom_col()` later in this lesson but you can read about the difference between the two in a later chapter.
    - `geom_text()` adds labels based on values in the data.
- **themes** change the visual styles of the grids and axis. There are several available within ggplot and [many other from the R community](https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/).
- **labels** (or labs, since we use the `labs()` function for them) are a series of text-based items we can layer onto our plots like titles, bylines and axis names.

In addition to these layers, we'll use the `+` at the end of each line. Think of the `+` as the ` %>% ` of ggplot. So, your code will look something like this (don't run this code chunk!):


```r
ggplot(data, aes(x = some_variable, y = another_variable)) + #creates the base layer, with the + at the end
  geom_layer #adds a geom
```

Okay, now that we know what the code looks like, let's proceed with the first `geom`.

### Add geom_points

The second layer we'll add to our figure is a `geom` layer. "Geom" is short for geometries: these layers provide a lot of different ways to shape and visualize the data. Simply put, `geom` layers tell R what kind of chart you'd like to make.

Let's start with a straightforward `geom` layer, `geom_plot()`, which adds a layer of points to your plot (this type of plot is called a scatterplot).

1. EDIT your plot chunk to add the `+` and a new line for `geom_point()`


```r
ggplot(mpg, aes(x = displ, y = hwy)) + # don't forget the + at the end of this line
  geom_point() # the geom_point layer
```

<img src="07-plots_files/figure-html/mpg-points-1.png" width="672" />

```r
#The geom_point() function will inherit the aes() values from the line above it.
```

Now we're starting to get somewhere! With the `geom_point()` layer added, our data are now finally displayed as points. And, as you can see, the pattern is pretty obvious: the lower the car's `displ` (their engine size, in liters), the higher the `hwy` (their gas milage on a highway).

### Adding other mappings

As mentioned in the above section, there are aesthetics (`aes`) arguments that can apply to the plot as a whole (which we did with the x and y values above) and there are aesthetics we can write into specific `geom` layers (these aesthetics will not apply to other layers--just that `geom`). This can be useful if you wanted to incorporate a third variable into your figure, as we will demonstrate below, using `color`.

1. Edit your `geom_point()` function to add a color mapping to the points with `aes(color = class)`. `color` is the type of aesthetic, and `class` is another variable (column) in the data.


```r
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) # this is the line you are editing
```

<img src="07-plots_files/figure-html/mpg-color-1.png" width="672" />

As you can see, the dots were given colors based on the values in the `class` column, and ggplot also added a legend to the graphic. These colors are the default color settings in `ggplot`

There are other aesthetics you can use.

1. Change the `color` aesthetic to one of these values and run it to see how it affects the chart: `alpha`, `size` and `shape`. (i.e., `alpha = class`.)
2. Once you've tried them, change it back to `color`.

OK, enough of the basics ... let's build a chart you _might_ care about.

## Let's build a bar chart

In our first week of class, we sent out a survey where you told us your favorite Disney Princess and favorite flavor of ice cream. Let's now play around with some of this data.

For this lesson, we're not going to create a different notebook or download the data to our computer. Instead, we're going to save the data directly into a tibble.

1. Start a new section: Princess chart data upload.
1. In the text, note that we are importing the princess chart data.
1. Add the code below to get the data.


```r
# read the data and create an tibble object called "class"
class <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQfwR6DBW5Qv6O5aEBFJl4V8itnlDxFEc1e_-fOAtBMDxXx1GeEGb8o5VSgi33oTYqeFhVCevGGbG5y/pub?gid=0&single=true&output=csv")
```

```
## Rows: 28 Columns: 3
```

```
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr (3): Name, Princess, Ice cream
```

```
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
# peek at the data
class
```

```
## # A tibble: 28 x 3
##    Name    Princess                      `Ice cream`      
##    <chr>   <chr>                         <chr>            
##  1 Katy    Belle (Beauty and the Beast)  Cookies and Cream
##  2 Ana     Belle (Beauty and the Beast)  Cookie Dough     
##  3 Marissa Tiana (Princess and the Frog) Cookie Dough     
##  4 Jessie  Pocahontas                    Strawberry       
##  5 José    Ariel (Little Mermaid)        Cookies and Cream
##  6 Claire  Ariel (Little Mermaid)        Coffee/Jamoca    
##  7 Payne   Snow White                    Cookie Dough     
##  8 Caro    Belle (Beauty and the Beast)  Cookie Dough     
##  9 Vicente Rapunzel (Tangled)            Coffee/Jamoca    
## 10 Bryan   Jasmine (Aladdin)             Cookie Dough     
## # ... with 18 more rows
```

So, now, you should have the data in your environment. 

### Prepare the data

While there are ways for ggplot to calculate values from your data on the fly, I prefer to first build a table of the values I want, and then I will plot it on a chart. It's helpful to think of these steps as separate so you have a good workflow (clean the data, prepare the data in a table form, and then plot the data).

Today, our goal will be to make a bar chart, sometimes known as a column chart or histogram. This bar chart will show the number of votes for each princess from the data. So, we need to count the number of rows for each value ... our typical `group_by`/`summarize`/`arrange` (GSA) process. 

For this lesson, I'm going to use the `count()` shortcut, since we haven't used it much lately. Next, I'll save the summarized data into a new dataframe called `princess_data`. Follow along in your notebook:

1. Add a section: Princess chart.
1. Add text that you are creating a data frame to plot.
2. Add the code below to create that data.

















