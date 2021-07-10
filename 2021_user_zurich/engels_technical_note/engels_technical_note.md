---
title: "Teaching Biology students to code smoothly with learnr and gradethis"
author:
- Engels Guyliann Engels, Numerical Ecology Department, Complexys and InforTec Institutes,
  University of Mons, Belgium
- Philippe Grosjean, Numerical Ecology Department, Complexys and InforTec Institutes,
  University of Mons, Belgium
date: "2021-06-23"
output:
  html_document:
    keep_md: yes
bibliography: bibliography.bib
---





## Abstract

Students in a biology curriculum at the University of Mons learn to use R, RStudio, git and GitHub in their data science courses. The flipped classroom approach is used since 2018; students discover by themselves new concepts using online course material (<https://wp.sciviews.org>) at home. Then they apply the new concepts in the classroom on biological datasets in individual or group projects hosted on GitHub (<https://github.com/BioDataScience-Course>).

{learnr} tutorials are used for a smooth transition between the theory at home and practice in the classroom. Students self-assess their conceptual understanding thanks to these tutorials with or without guided feedback using {gradethis}. {learnitdown} (<https://www.sciviews.org/learnitdown/>) is used to manage students identity and to record their activity in a MongoDB database.

Students in the first course are more perseverant when guided feedback is available, translating in a significant increase in the number of attempts per question. In the second course, their perseverance was already high without the guided feedback, which exhibits thus a more limited effect.

Perception of the workload in the tutorials is quantified using a Raw Task load index (NASA-LTX questionnaire). This index could be used as one of the indicators to check the improvement of the tutorials in the future.

### Keywords

data science class, flipped classroom, learnr, gradethis, learnitdown

## Findings

Number of regular students, tutorials, questions and recorded events during the last two years are presented in the next table.


|Course             |Academic year | Users| Learnr| Questions| Events|
|:------------------|:-------------|-----:|------:|---------:|------:|
|BioDataScience I   |2019-2020     |    44|     22|       280|  57003|
|BioDataScience I   |2020-2021     |    50|     25|       239| 103389|
|BioDataScience II  |2019-2020     |    31|      8|        93|  17730|
|BioDataScience II  |2020-2021     |    37|     13|       146|  37875|
|BioDataScience III |2020-2021     |    26|      7|        44|   8621|

The learnr tutorials analysed in the present study are available in GitHub:

-   BioDataScience1 (<https://github.com/BioDataScience-Course/BioDataScience1>)
-   BioDataScience2 (<https://github.com/BioDataScience-Course/BioDataScience2>)
-   BioDataScience3 (<https://github.com/BioDataScience-Course/BioDataScience3>)

{{<figure src="attempts-1.png" >}}

The comparison with and without guided feedback does not show significant differences in number of attempts per exercise except for the Biodatascience I course (Wilcoxon independent test, W = 33, p-value = 2e-16). Guided feedback induces a behaviour change: students gave up sooner without them.



### Perceived workload

The NASA-LTX indicator is composed of six questions on a Likert scale to quantify the perceived workload to complete a tutorial [@hart1988development]. The questions concern mental load, physical load, time pressure, expected success, effort required, and frustration experienced during the accomplishment of the task. The average value for the six questions constitutes a Raw Task Load indeX (RTLX) [@byers1989traditional].

{{<figure src="rtlx-1.png" >}}

Despite the increased difficulty of the exercises from one course to the other, RTLX indicator for Biodatascience III is significantly lower than for Biodatascience I (Tukey HSD, p-value = 0.023). We hypothesise that students are more used to the {learnr} tutorials as well as, R coding required to solve the exercises. Consequently, global workload is perceived as lighter. These RTLX measurements are meant to be a reference point for the following years: any future improvements in the tutorials should lead to similar or lower RTLX.



The combination of {learnr}, {gradethis} and {learnitdown} provides a powerful tool to self-assess learning in data science. Students first exposed to {learnr} tutorials also benefit from additional guided feedback with {gradethis}. We propose to use the RTLX index as a mean to assess perceived difficulties and work required to complete these tutorials.


### **Availability of supporting source code and requirements**

-   Project home pages: <https://www.sciviews.org/learnitdown/>, <https://github.com/BioDataScience-Course/BioDataScience1>, <https://github.com/BioDataScience-Course/BioDataScience2>, <https://github.com/BioDataScience-Course/BioDataScience3>
-   Operating systems: Platform independent
-   Programming language: R
-   Other requirements: R 4.0.5 or higher, learnr 0.10.1.9008 or higher , gradethis, learnitdown 1.3.0 or higher

### Data availability

The data will be opened shortly.

### References

