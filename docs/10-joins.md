# Joins

## Goals

- Learn how to join two files based on a common column
- Explore correlations between two numerical values
- Practice showing relationships with scatterplots
- Learn how to merge two files one top of each other

This lesson is _heavily_ cribbed from a lesson in Matt Waite's Sports Data Journalism course at the University of Nebraska.

## Project setup

- Create your project. Call it `yourname-football`.
- Create a `data-raw` folder so you have a place to download the files.
- Start a new notebook.

### Download the data

You can download the files we are using based on their URLs in a Github repository. Once you've run this block of code, comment out the three `download.file()` lines by putting a `#` at the beginning. You really only need to download the files once.

```r
# Downloads the files. Convert to comments once you've done this:
download.file("https://github.com/utdata/rwd-r-assignments/blob/master/football-compare/penalties.csv?raw=true", "data-raw/penalties.csv")
download.file("https://github.com/utdata/rwd-r-assignments/blob/master/football-compare/scoring_offense.csv?raw=true", "data-raw/scoring_offense.csv")
download.file("https://github.com/utdata/rwd-r-assignments/blob/master/football-compare/third_down_conversion.csv?raw=true", "data-raw/third_down_conversion.csv")
```

Import the three files:

```r
# import the files
penalties <- read_csv("data-raw/penalties.csv")
scoring <- read_csv("data-raw/scoring_offense.csv")
thirddown <- read_csv("data-raw/third_down_conversion.csv")
```

## The story

The data we are using comes from [cfbstats](http://www.cfbstats.com/), a website for college football statistics. We will be comparing how [third-down conversions](http://www.cfbstats.com/2018/leader/national/team/offense/split01/category25/sort01.html) might correlate to a football team's [Scoring offence](http://www.cfbstats.com/2018/leader/national/team/offense/split01/category09/sort01.html).

## Explore the data

We have two data sets here.

### Third-down conversions

- **year**: Year
- **name**: Team name
- **g**: Number of games played
- **attempts**: Third-down attempts
- **conversions**: Third-down attempts that were successful
- **conversion_percent**: conversions/attempts * 100

### Scoring

- **year**: Year
- **name**: Team name
- **g**: Number of games played
- **td**: Touchdowns
- **fg**: Field goals
- **x1xp**: 1pt PAT made
- **x2xp**: 2pt PAT made
- **safety**: Safeties
- **points**: Total points scored
- **points_g**: Points per game

Now our goal here is to compare how the `converstion_percent` might relate to `points_g` for all teams, and how specific teams might buck the national trend.

## About joins

To make our plot, we need to join the two data sets on common fields. We want to start with the `scoring` data frame, and then add all the columns from the `thirddown` data frame. We want to do this based on the same year and team.

There are several types of [joins](https://dplyr.tidyverse.org/reference/join.html). We describe these based on which table we reference first. In the figure below, we can see which matching records are retained based on the type of join we use.

![Types of joins](images/joins-description.png)




In our case we only want records that match on both `year` and `name`, so we'll use an `inner_join()`.

The syntax works like this:

```r
new_dataframe <- <type>_join(first_df, second_df, by = field_name_to_join_on)
```

If you want to use more than one field in the *by* part like we do, then you define them in a concatenated list: `by = "field1", "field2")`.

For our project we want to use an inner join, and we will formulate it like this. Add this to your notebook along with notes describing that you are joining the two data sets:

```r
offense <- left_join(scoring, thirddown, by=c("year", "name"))

# peak at the new data frame
offense %>% head()
```

## Build our scatterplot

We're trying to show the relationship between `conversion_percent` and `points_g`, so we can use those as our x and y values in a `geom_point()` graphic.

```r
offense %>% 
  ggplot(aes(x = conversion_percent, y = points_g)) + 
  geom_point() 
```

![First scatterplot](images/join-scatter.png)

### Add a fit line

We can see by the shape of the dots that indeed, as conversion percentage goes up, points go up. 

In statistics, there is something called a fit line -- the line that predicts shows what happens given the data. There's lot of fit lines we can use but the easiest to understand is a straight line. It's like linear algebra -- for each increase or decrease in x, we get an increase or descrease in x. To get the fit line, we add [`geom_smooth()`](https://ggplot2.tidyverse.org/reference/geom_smooth.html) with a method.

```r
offense %>% 
  ggplot(aes(x = conversion_percent, y = points_g)) +
  geom_point() + 
  geom_smooth(method=lm, se=FALSE) # adds fit line
```

![First scatterplot](images/join-scatter-fitline.png)

### Run a correlation test

So we can see how important third down conversions are to scoring. But still, how important? For this, we're going to dip our toes into statistics. We want to find out the correlation coefficient (specifically the [Pearson Correlation Coefficient](https://statistics.laerd.com/statistical-guides/pearson-correlation-coefficient-statistical-guide.php). That will tell us how related our two numbers are. We do that using `cor.test()`, which is part of R core.

```r
cor.test(offense$conversion_percent, offense$points_g)
```

That bottom number is the key. If we square it, we then know exactly how much of scoring can be predicted by third down conversions.

```r
(0.6569602 * 0.6569602) * 100
```

Which gets us 43.15967. 

So what that says is that 43 percent of a team's score is predicted by their third down percentage. That's nearly half. In social science, anything above 10 percent is shockingly predictive. So this is huge if this were human behavior research. In football, it's not that surprising, but we now know how much is predicted.

## How does Texas compare to the field?

Let's create a data frame of the Texas data.

```r
tx <- offense %>%
  filter(name == "Texas")
```

With this, we can plot the Texas stats on top of the national stats and see how they compare.

We've also added a light grey color to the original `geom_point()` and `geom_smooth()` layers so that the Texas plots stand out more.


```r
offense %>% 
  ggplot(aes(x = conversion_percent, y = points_g)) +
  geom_point(color = "light grey") + # adds light grey color
  geom_smooth(method=lm, se=FALSE, color = "light grey") + # adds light grey color
  geom_point(data = tx, aes(x = conversion_percent, y = points_g), color = "#bf5700") + # adds Texas points colored burnt orange, of course
  geom_text(data = tx, aes(x = conversion_percent, y = points_g, label = year)) # adds year labels to see
```

![Adding Texas to plot](images/join-scatter-tx.png)

This is good, but the labels for the year are sitting on top of the values. There is an R package called ggrepel that will move those labels off the numbers. You might have to run `install.packages('ggrepel')` to make this work.

For this update update, we are doing a number of things, adding or modifying layers along the way:

- Add a `goem_smooth()` fit line specific to Texas, in burnt orange. We'll put it before the text so it is underneath it.
- Modify the `geom_text` to `geom_text_repel` to move the labels.
- Add `labs()` for a title and such to finish out our graphic.
- Add `theme_minimal()` just to improve the looks.

```r
  ggplot(aes(x = conversion_percent, y = points_g)) +
  geom_point(color = "light grey") + 
  geom_smooth(method=lm, se=FALSE, color = "light grey") +
  geom_point(data = tx, aes(x = conversion_percent, y = points_g), color = "#bf5700") +
  geom_smooth(data = tx, aes(x = conversion_percent, y = points_g), method=lm, se=F, color = "#bf5700") +
  geom_text_repel(data = tx, aes(x = conversion_percent, y = points_g, label = year)) +
  labs(x="Third-down conversion rate",
       y="Points per game",
       title="Texas' third down success predicts scoreboard",
       subtitle="In 2018 the Longhorns were 18th in the FBS for third down conversions.",
       caption="Source: NCAA") +
  theme_minimal()
```

![Finished Texas graphic](images/join-scatter-tx-finished.png)

## Correlaton test for Texas

It looks like Texas tracks pretty much along the national average.

Let's do the correlation test for Texas just to compare.

```r
cor.test(tx$conversion_percent, tx$points_g)
```

Which yields a correlation of 0.685967. Let's see how much third-down conversions predict Texas' scoring per game.

```r
(0.685967 * 0.685967) * 100
```

Which gets us 47.1%, not too far from the national average of 43.2%.

## Practice 1: Track for Penn State

Not every team tracks the national average like Texas. Tell me (and show me) how Penn State performs in this same third-down vs scoring metric by creating a similar graphic and correlation test from the Penn State data.

## Practice 2: Penalties vs scoring

How predictive are penalty yards on points per game? Do more disiplined teams score more points than undisciplined ones? How does Texas compare to the rest of the league?

You're going to have to join [penalty data](http://www.cfbstats.com/2018/leader/national/team/offense/split01/category09/sort01.html) (you've already downloaded the file `data-raw/penalties.csv` file) to your [offensive statistics](http://www.cfbstats.com/2018/leader/national/team/offense/split01/category09/sort01.html). Then you'll make your own scatterplot, add a fit line and run a correlation test for both the national average and for Texas. What does it say? Write a sentence that explains this to a reader.

