# User2021 abstract

## Teaching Biology students to code smoothly with learnR and gradethis

Guyliann Engels(Guyliann.Engels@umons.ac.be)
Philippe Grosjean (Philippe.Grosjean@umons.ac.be, phgrosjean@sciviews.org)
Numerical ecology department, Complexys and InforTech Institutes, University of Mons, Belgium

**Topic:** Teaching R & R in teaching

**Keywords:** data science class, flipped classroom, learnr, gradethis.

R is teach in a biology curriculum at the University of Mons, Belgium, in the context of five data science courses spanning from 2nd Bachelor to last Master classes (https://wp.sciviews.org). Since 2018 the flipped classroom approach is used. Three levels of exercices of increasing difficulties are proposed. First, students read a {bookdown} with integrated interactive exercises written in H5P or {Shiny}. Then, they practice R using {learnR} tutorials. Finally, they apply the new concepts on real datasets in individual or group projets managed with GitHub and GitHub Classroom (https://github.com/BioDataScience-Course).

{LearnR} is a useful tool to bridge the gap between theory and practice in R learning. Students can auto-assess their skills and get immediate feedback thanks to {gradethis}. All the exercises generate xAPI events that are recorded in a MongoDB database (more than 300,000 events recorded so far for a total of 182 students over three academic years). These data allow to quantify and visualize the progression (individual progress reports as {Shiny} applications). Thanks to the detailed visualization of their own progression, students are more motivated to complete the exercises. Whether {learnr} is used alone , or in combination with {gradethis} for immediate feedback on the answers, determine student's behavior. They spend more time on each exercise and try harder to find the right answer when {gradethis} is used.

## An integrated teaching environment for R with {learnitdown}

Philippe Grosjean (Philippe.Grosjean@umons.ac.be, phgrosjean@sciviews.org)
Guyliann Engels(Guyliann.Engels@umons.ac.be)
Numerical ecology department, Complexys and InforTech Institutes, University of Mons, Belgium

**Topic:** Teaching R & R in teaching

**Keywords:** data science teaching, learnr, shiny, bookdown, learning management system.

Many R resources exist for teaching R and data science, like {bookdown}, {blogdown} or {distill} for textbook material, {learnr} and {gradethis} for tutorials with interactive exercises, {shiny} applications for interactive demonstrations, R/exams for exams generation and administration... However, as far as we know, there is still no integrated system that manage all these tools and other common ones like Moodle or H5P, in a coherent teaching platform. The {learnitdown} R package (https://github.com/SciViews/learnitdown) brings all these tools together into a little LMS (learning management system) dedicated to teaching with R and R Markdown.

Students authentication from Moodle or Wordpress allow to track individual activity in the H5P, {learnr} or {shiny} exercises in a centralized database. A list of exercises is build automatically for each {bookdown} chapter and an auto-generated progress report help students to manage their exercises more easily. Data gathered from these exercises can be pseudonymized and analyzed. The {learnitdown} system is used to teach data science to students in biology at the University of Mons, Belgium, since 2018 with great satisfaction, see https://wp.sciviews.org (in French) and https://github.com/BioDataScience-Course.
