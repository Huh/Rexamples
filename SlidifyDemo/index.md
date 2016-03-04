---
title       : R Group Introduction
subtitle    : Created with R
author      : Josh Nowak
job         : R Hack
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
github:
    user: Huh
    repo: SlidifyRGroup
---

## Best Practices

> 1. Modular
> 2. Pattern Oriented 
> 3. Simple
> 4. Style
> 5. Commenting

---

## Modular
Code should be modular.  It should be written general enough so that it works in
numerous situations.

---

## Pattern Oriented
As you write code, name objects, name functions and work through your project
recognize patterns and leverage them to increase readability of your code.

---

## Simple
When your code starts to get really complicated...there may be a problem.

---

## Style
Style was never important to me in the beginning, but as I read more and more
code style becomes a vehicle for me to quickly pick apart my code.

---

##  R as a scripting language
Because we have the ability to write scripts we leave behind documentation of 
our entire workflow.  You can literally go back to your code a year later and
understand exactly how you created objects xyz...if you commented your code.

Answer why, not what when commenting

---
## Workflow

1. Starts with a directory for each project and a simple description of the goals
2. The directory has special properties (e.g. GitHub)
4. I like to create a single control script that sources all the other pieces
5. Functions are used to do each task

---
