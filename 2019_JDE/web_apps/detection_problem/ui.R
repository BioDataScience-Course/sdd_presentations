library(shiny)
library(shinythemes)
library(DT)
SciViews::R

shinyUI(
  navbarPage(
    "Outils de détection des difficultés des étudiants",
    theme = shinytheme("yeti"),
    tabPanel("Description générale",
             sidebarLayout(
               sidebarPanel(
                 imageOutput("econum")
                 ),
               mainPanel(
                 h3("Description générale"),
                 h4("Description du tableau de données"),
                 textOutput("nbr"),
                 tableOutput("tab_gen"),
                 textOutput("tuto_nbr"),
                 DTOutput("tab_mod"),
                 hr(),
                 strong("Cette application est en cours de développement au sein du service
              d'écologie numériques des milieux aquatiques de l'Université de Mons
                        dans le cadre des cours de sciences des données"),
                 imageOutput("bds")
               )
               )),
    tabPanel("Vue globale",
             sidebarLayout(
               sidebarPanel(
                 h4("Sélectionnez la représentation graphique souhaitée ci-dessous"),
                 selectInput("nb_tuto", "Entrée par quiz",
                             choices = c("Nombre total d'entrée",
                                         "Nombre d'entrée standardisé",
                                         "Entrée en fonction du temps",
                                         "Score de participation par étudiants"),
                             selected = "Entrée en fonction du temps"),
                 strong("Cette application web est en cours de développement")
                 ),
               mainPanel(
                 h4("Répartition des entrées dans la base de données"),
                 plotOutput("bar_plot"),
                 hr(),
                 p("Après avoir analysé les différents graphiques mis à votre disposition
                   vous avez pu mettre en évidence des tutoriels ayant pu poser problème aux étudiants.
                   Vous avez à votre disposition les onglets suivants (Quiz, Etudiants)
                   afin de poursuivre votre analyse.")
                 )
                 )
             ),
    tabPanel("Quiz",
             sidebarLayout(
               sidebarPanel(
                 h4("Sélectionnez le quiz souhaité ci-dessous"),
                 selectInput("tuto", "Les quiz dispensés",
                                        choices = unique(sdd_dt$tutorial),
                                        selected = unique(sdd_dt$tutorial)[2]),
                 strong("Cette application web est en cours de développement")),
               mainPanel(
                 plotOutput("bar_plot_quiz")
               )
               )
             ),
        tabPanel("Etudiants",
             sidebarLayout(
               sidebarPanel(
                 h4("Sélectionnez le participant et le quiz souhaités"),
                 selectInput("stu", "Les participants",
                             choices = unique(sdd_dt$user_name),
                             selected = unique(sdd_dt$user_name)[1]),
                 selectInput("tuto1", "Les quiz dispensés",
                             choices = unique(sdd_dt$tutorial),
                             selected = unique(sdd_dt$tutorial)[2]),
                 strong("Cette application web est en cours de développement")),
               mainPanel(
                 plotOutput("bar_plot_stu"),
                 plotOutput("bar_plot_stu1")
               )
             )
             ),
    inverse = TRUE
))



