
# Package --------
library(shiny)
library(shinythemes)
SciViews::R
library(data.table)
library(forcats)

# Import dataset -----------
# sdd_dt <- read("2019_JDE/data/sdd.rds", type = "rds")
sdd_dt <- read("../../data/sdd.rds", type = "rds")

# wrangling
learnrs <- tribble(
  ~module, ~tutorial,      ~name,
  2,       "sdd1.02a", "02a_base",
  2,       "sdd1.02b", "02b_decouverte",
  2,       "sdd1.02c", "02c_nuage_de_points",
  2,       "sdd1.02d", "02d_np_challenge",
  3,       "sdd1.03a", "03a_test",
  4,       "sdd1.04a", "04a_test",
  5,       "sdd1.05a", "05a_test",
  6,       "sdd1.06a", "06a_test",
  7,       "sdd1.07a", "07a_proba",
  7,       "sdd1.07b", "07b_distri",
  8,       "sdd1.08a", "08a_chi2",
  8,       "sdd1.08b", "08b_chi2",
  9,       "sdd1.09a", "09a_ttest",
  9,       "sdd1.09b", "09b_ttest_wmw",
  10,       "sdd1.10a", "10a_anova",
  10,       "sdd1.10b", "10b_anova_kruskal",
  11,       "sdd1.11a", "11a_anova2",
  11,       "sdd1.11b", "11b_syntaxr",
  12,       "sdd1.12a", "12a_correlation",
  13,       "sdd1.13a", "13a_examen",
  13,       "sdd1.13b", "13b_examen"
)

sdd_dt <- left_join(sdd_dt, learnrs, by = "tutorial")


sdd_dt %>.%
  filter(., !event %in% c("exercise_hint", "section_skipped")) %>.%
  mutate(., date = parse_datetime(date),
         tutorial = factor(tutorial),
         version = factor(version, levels = c("1.0.0", "1.1.0", "1.2.0"),
                          ordered = TRUE),
         user_name = factor(user_name),
         event = factor(event),
         tuto_label = factor(tuto_label),
         row = 1:length(date)) -> sdd_dt

sdd_dt$event <- as.character(sdd_dt$event)
sdd_dt$event[sdd_dt$label == "comm"] <- "comm"
sdd_dt$event <- factor(sdd_dt$event)

ord <- rev(levels(sdd_dt$tutorial))


sdd_dt %>.%
  filter(., label != "comm") %>.%
  group_by(., name) %>.%
  summarise(., student = length(unique(user_name)), entree = length(tuto_label), tot = length(unique(tuto_label))) -> t

sdd_dt1 <- filter(sdd_dt, ! is.na(correct))


sdd_dt1 <- filter(sdd_dt1, label != "comm")

sdd_dt1 %>.%
  group_by(., user_name, name, tuto_label) %>.%
  summarise(., result = length(tuto_label)) %>.%
  ungroup(.) %>.%
  group_by(. ,user_name, name) %>.%
  summarise(., res = length(result)) -> ttt

ttt <- left_join(ttt, t, by = "name")
ttt <- mutate(ttt, score = res/tot,
              score1 = pmin(res / (tot - 2), 1),
              quiz = str_extract(name, pattern = "\\w{3}"))

test <- rev(paste("student_", 1:40, sep = ""))

# Server ---------
server <- function(input, output) {

  output$nbr <- renderText({
    paste("En ce", format(Sys.time(), "%d %B %Y %X"), ", la base de données comprend : \n")
  })

  output$tab_gen <- renderTable({
    tibble::data_frame("Entrées" = nrow(sdd_dt),
               "Quiz" = length(unique(sdd_dt$tutorial)),
               "Etudiants" = length(unique(sdd_dt$user_name)))
  })

  output$tuto_nbr <- renderText({
    paste("La base de données comprend", length(unique(sdd_dt$tutorial)), "tutoriels qui sont réparti au sein des différents modules du cours de Sciences des données I : Visualisation et inférence.")
  })

  output$econum <- renderImage({
    list(src = "images/EcoNum-logo.pdf",
         filetype = "image/pdf")
  }, deleteFile = FALSE)
  output$bds <- renderImage({
    list(src = "images/BioDataScience-256.png",
         filetype = "image/png",
         width = "150px")
  }, deleteFile = FALSE)
  output$umons <- renderImage({
    list(src = "images/UMONS-logo.pdf",
         filetype = "image/pdf",
         width = "150px")
  }, deleteFile = FALSE)

  output$tab_mod <- renderDataTable({
    datatable(t, colnames = c("Quiz", "Etudiants", "Nombre d'entrée","Nombre de questions par quiz"),
              rownames = FALSE, options = list(pageLength = 5))
      })

  output$bar_plot <- renderPlot({
    if (input$nb_tuto == "Entrée en fonction du temps"){
      chart::chart(data = sdd_dt, fct_relevel(tutorial, ord) ~ date %fill=% tutorial) +
        ggridges::geom_density_ridges(show.legend = F) +
        ggplot2::labs( x = "Temps [mois]", y = "Quiz")
    } else if (input$nb_tuto == "Nombre total d'entrée") {
      chart::chart(data = sdd_dt, ~ fct_relevel(tutorial, ord)  %fill=% tutorial) +
        ggplot2::geom_bar(show.legend = F) +
        ggplot2::labs( x = "Quiz", y = "Nombre d'essais") +
        ggplot2::coord_flip()
    } else if (input$nb_tuto == "Nombre d'entrée standardisé"){
      sdd_dt %>.%
        group_by(., tutorial) %>.%
        summarise(., n_tot =  length(unique(label)), n = length(label),
                  ratio = n/n_tot) %>.%
        chart::chart(data = ., ratio ~ fct_relevel(tutorial, ord)  %fill=% tutorial) +
        ggplot2::geom_col(show.legend = F) +
        ggplot2::labs( x = "Quiz", y = "Nombre d'essais standardisé") +
        ggplot2::coord_flip()
    } else {
      chart(ttt, fct_relevel(user_name, test) ~ quiz %fill=% score1) +
        geom_raster() +
        xlab("") +
        ylab("") +
        geom_hline(yintercept = (0:length(levels(ttt$user_name))) + 0.5) +
        geom_vline(xintercept = (0:length(unique(ttt$name))) + 0.5) +
        scale_fill_distiller(palette = "RdBu", direction = 1) +
        labs(caption = "Le score est le ratio de réponses soumises \n sur le nombre total de réponses par quiz")
    }
  })

  output$bar_plot_quiz <- renderPlot({
    sdd_dt %>.%
      filter(., tutorial == input$tuto) %>.%
      chart::chart(., ~ label %fill=% event) +
      ggplot2::geom_bar(show.legend = F) +
      ggplot2::labs( x = "Questions", y = "Nombre d'essais") +
      ggplot2::coord_flip()
  })

  output$bar_plot_stu <- renderPlot({
    sdd_dt %>.%
      filter(., user_name == input$stu) %>.%
      chart::chart(data = .,fct_relevel(tutorial, ord) ~ date %fill=% tutorial) +
      ggridges::geom_density_ridges(show.legend = F) +
      ggplot2::labs( x = "Temps [mois]", y = "Quiz")
  })

  output$bar_plot_stu1 <- renderPlot({
    sdd_dt %>.%
      filter(., user_name == input$stu) %>.%
      filter(., tutorial == input$tuto1) %>.%
      chart::chart(., ~ label %fill=% event) +
      ggplot2::geom_bar(show.legend = F) +
      ggplot2::labs( x = "Questions", y = "Nombre d'essais") +
      ggplot2::coord_flip()
  })
}

