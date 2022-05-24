# Install Party {#install}

> This chapter was written by Prof. McDonald using macOS.

Let's get this party started.

## Mac vs PC

We're a big fan of using keyboard commands to do operations in any program, but Prof. McDonald references this from a Mac perspective and Prof. Lukito references this from a PC perspective. So if we say use *Cmd+S* or *Command+S* to save, that translates to *Cntl+S* or *Control+S* on a PC. Importantly, *Cmd* (for Mac) and *Cntl* (for PC) are fairly synonymous, but there may be other differences. Usually, it's easy to figure the translation out by looking at menu items in RStudio to figure out the Mac/PC command.

As we said, Prof. McDonald uses a Mac and Prof. Lukito uses a PC, so we'll be able to troubleshoot it regardless of the operating system that you use! **We will try to note that at the top of a chapter.**

We will install R and RStudio. It might take some time depending on your Internet connection.

**If you are doing this on your own** you might follow [this tutorial](https://learnr-examples.shinyapps.io/ex-setup-r/). But below you'll find the basic steps.

## Installing R

Our first task is to install the R programming language onto your computer. 

1. Go to the <https://cloud.r-project.org/>.
1. Click on the link for your operating system.
1. The following steps will differ slightly based on your operating system.
    + For Macs, you want the "latest package" unless you have an "M1" Mac (Nov. 2020 or newer), in which case choose the **arm64.pkg** version.
    + For Windows, you want the "base" package. You'll need to decide whether you want the 32- or 64-bit version. (Unless you've got a pretty old system, chances are you'll want 64-bit.)

This should be pretty self explanatory: once you download the installation file, you should be able to run it on your respective computers to install R.

You'll never "launch" R as a program in a traditional sense, but you need it on your computers (it's mostly so that the computer can recognize R as a "language"). In all situations (in this class, and beyond), we'll use RStudio, which is next.

## Installing RStudio

[RStudio](https://www.rstudio.com/) is an "integrated development environment" -- or IDE -- for programming in R. Basically, it's the program you will use when doing work for this class.

1. Go to <https://www.rstudio.com/download>.
2. Scroll down to the versions and find **RStudio Desktop** and click on the **Download** button.
3. It should take you down the page to the version you need for your computer.
4. Install it. Should be like installing any other program on your computer.

### Getting "Git" errors on Macs

If later during package installation you get errors that mention "git" or "xcode-select" then **say yes!** and do it.

## Class project folder

To keep things consistent and help with troubleshooting, We recommend that you save your work in the same location all the time.

- On both Mac and Windows, every user has a "Documents" folder. Open that folder. (If you don't know where it is, ask us to help you find it.)
- Create a new folder called "rwd". Use all lowercase letters.

When we create new "Projects", I want you to always save them in the `Documents/rwd` folder. This just keeps us all on the same page.

## RStudio Cloud

If your computer is aging and you find you have trouble with RStudio, there is [RStudio Cloud](https://rstudio.cloud/). You can try it for free but might end up on the $5/month plan before the end of the semester, depending on your use. It works quite well.
