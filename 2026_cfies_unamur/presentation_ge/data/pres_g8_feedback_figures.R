# Figures for the presentation: teacher vs LLM feedback and grades
#
# Input : data/pres_g8_feedback.rds (pseudonymised sub-table,
#         made by pres_g8_feedback_data.R in sdd_exam_grading). Paths are
#         relative to the presentation/ folder (where the .Rmd is).
# Objects: fig_words (median number of words), fig_hist (distribution of
#         words, 3 groups), fig_hist2 (idem, 2 groups), fig_agree (teacher vs
#         LLM grades). PNG files in figures/ only if save_png is TRUE.
# Groups (maximal, partial, null grade) are based on the TEACHER grade.

SciViews::R

save_png <- FALSE   # TRUE to also write the PNG files in fig_dir
fig_dir  <- "figures"
pres_ <- read$rds("data/pres_g8_feedback.rds")

col_who   <- c(Enseignant = "#E07B39", LLM = "#2E6FB7")
col_agree <- c("LLM plus sévère" = "#C0392B", "Accord" = "#2E6FB7",
  "LLM plus clément" = "#2E8B57")

# Factor levels with the number of observations, e.g., "Note maximale (n = 1482)"
with_n <- function(x) {
  x <- droplevels(as.factor(x))
  n <- table(x)
  factor(paste0(x, "\n(n = ", n[as.character(x)], ")"),
    levels = paste0(names(n), "\n(n = ", n, ")"))
}

# Long format: one row per answer and per author of the feedback
words_long_ <- {
  .= pres_
  # Group labels with n, computed before pivoting (2 rows per answer after)
  .= mutate_(
    score_lab  = ~with_n(score_group),
    score_lab2 = ~with_n(factor(if_else(score_group == "Note maximale",
      "Note maximale", "Note partielle ou nulle"),
      levels = c("Note maximale", "Note partielle ou nulle"))))
  .= pivot_longer_(c("words_teacher", "words_llm"),
    names_to = "who", values_to = "words")
  .= mutate_(who = ~factor(if_else(who == "words_teacher", "Enseignant",
    "LLM"), levels = names(col_who)))
}


# Common look for the slides: no frame, light grid, bold title -------------
theme_pres <- theme_sciviews(font_size = 13) +
  theme(
    panel.border       = element_blank(),
    axis.line          = element_blank(),
    axis.ticks         = element_blank(),
    panel.grid.major.y = element_line(colour = "grey90", linewidth = 0.4),
    plot.title         = element_text(face = "bold", size = 16, hjust = 0),
    plot.title.position = "plot",
    plot.subtitle      = element_text(colour = "grey35", size = 12),
    plot.caption       = element_text(colour = "grey45", size = 9),
    legend.position    = "top",
    legend.justification = "left",
    legend.title       = element_blank(),
    legend.text        = element_text(size = 12),
    strip.background   = element_blank(),
    strip.text         = element_text(face = "bold", size = 12)
  )

# 2. Figure 1: median feedback length -----------------------------------------
words_ <- {
  .= words_long_
  .= group_by_(~score_lab, ~who)
  .= summarise_(words = ~fmedian(words), .groups = "drop")
}

fig_words <- chart(words_, words ~ score_lab %fill=% who) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7) +
  geom_text(f_aes(~ NULL %label=% words),
    position = position_dodge(width = 0.75), vjust = -0.5,
    size = 6.5, fontface = "bold", colour = "grey20") +
  scale_fill_manual(values = col_who) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Longueur du feedback selon la note de l'enseignant",
    subtitle = "Nombre de mots médian par réponse",
    x = NULL, y = NULL,
    caption = "Questions de code et ouvertes") +
  theme_pres +
  theme(axis.text.y = element_blank(), panel.grid.major.y = element_blank(),
    axis.text.x = element_text(size = 12, colour = "grey20"))
fig_words
if (save_png) ggsave(fs::path(fig_dir, "fig_feedback_words.png"), fig_words,
  width = 8, height = 5, dpi = 200, bg = "white")

# 3. Figure 2: distribution of feedback length -------------------------------
# `group` = column used for the facets in columns (score_lab or score_lab2)
plot_hist <- function(data, group) {
  hist_med_ <- {
    .= summarise_(data, words = ~fmedian(words), .by = c("who", group))
    # Label right of the first bar when the median is ~0 (avoids the overlap)
    .= mutate_(x_lab = ~pmax(words, 7))
  }

  chart(data, ~ words %fill=% who) +
  geom_histogram(aes(y = after_stat(density * 5 * 100)), binwidth = 5,
    boundary = 0, closed = "left", colour = "white", linewidth = 0.3,
    show.legend = FALSE) +
  geom_vline(data = hist_med_, f_aes(~ NULL %xintercept=% words),
    linetype = "dashed", linewidth = 0.6, colour = "grey20") +
  geom_text(data = hist_med_,
    # f_aes() drops %x=%, so plain aes() here
    aes(x = x_lab, label = paste("médiane", words)),
    y = 92, hjust = -0.1, vjust = 1, size = 4.2, fontface = "bold",
    colour = "grey20") +
  scale_fill_manual(values = col_who) +
  scale_y_continuous(limits = c(0, 100), breaks = c(0, 50, 100),
    labels = function(x) paste(x, "%"), expand = expansion(0)) +
  scale_x_continuous(breaks = seq(0, 80, 20),
    expand = expansion(mult = c(0.02, 0))) +
  facet_grid(rows = vars(who), cols = vars(.data[[group]]), switch = "y") +
  coord_cartesian(xlim = c(0, 80), clip = "off") +
  labs(title = "Distribution de la longueur du feedback",
    subtitle = "Part des réponses selon le nombre de mots du commentaire",
    x = "Nombre de mots", y = NULL,
    caption = "Questions de code et ouvertes") +
  theme_pres +
  theme(strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0, face = "bold", size = 13),
    panel.spacing.x = unit(1.5, "lines"),
    panel.spacing.y = unit(2.5, "lines"))
}

# 3a. Three groups: maximal, partial and null grades
fig_hist <- plot_hist(words_long_, "score_lab")
fig_hist
if (save_png) ggsave(fs::path(fig_dir, "fig_feedback_hist.png"), fig_hist,
  width = 11, height = 6, dpi = 200, bg = "white")

# 3b. Two groups: maximal grade vs partial or null grade
fig_hist2 <- plot_hist(words_long_, "score_lab2")
fig_hist2
if (save_png) ggsave(fs::path(fig_dir, "fig_feedback_hist2.png"), fig_hist2,
  width = 9, height = 6, dpi = 200, bg = "white")

# 4. Figure 3: grade agreement teacher vs LLM --------------------------------
agree_ <- {
  .= pres_
  .= mutate_(q_type = ~with_n(q_type))
  .= group_by_(~q_type, ~agreement)
  .= summarise_(n = ~fn(grade_gap), .groups = "drop")
  .= group_by_(~q_type)
  .= mutate_(pct = ~100 * n / sum(n))
  .= ungroup_()
  .= mutate_(
    label = ~paste0(round(pct), " %"),
    # Small segments: label outside, at the right of the bar
    inside = ~pct >= 6)
}

fig_agree <- chart(agree_, pct ~ q_type %fill=% agreement) +
  geom_col(position = position_stack(reverse = TRUE), width = 0.6,
    colour = "white", linewidth = 0.6) +
  geom_text(data = filter_(agree_, ~inside),
    f_aes(~ NULL %label=% label),
    position = position_stack(vjust = 0.5, reverse = TRUE),
    colour = "white", fontface = "bold", size = 5.5) +
  geom_text(data = filter_(agree_, ~!inside),
    f_aes(~ NULL %label=% label %colour=% agreement),
    y = 101.5, hjust = 0, fontface = "bold", size = 4.5,
    show.legend = FALSE) +
  scale_fill_manual(values = col_agree,
    labels = c("LLM plus sévère", "Accord (écart ≤ 25 % de la note max.)",
      "LLM plus clément")) +
  scale_colour_manual(values = col_agree) +
  scale_x_discrete(limits = rev) +
  scale_y_continuous(breaks = seq(0, 100, 25),
    labels = paste(seq(0, 100, 25), "%"), expand = expansion(0)) +
  coord_flip(ylim = c(0, 100), clip = "off") +
  labs(title = "Accord entre la note de l'enseignant et celle du LLM",
    x = NULL, y = NULL,
    caption = "Note LLM : éléments corrects et erreurs, sans pénalité de forme") +
  theme_pres +
  theme(panel.grid.major.y = element_blank(),
    axis.text.y = element_text(size = 12, colour = "grey20", hjust = 1),
    plot.margin = margin(10, 35, 10, 10))
fig_agree
if (save_png) ggsave(fs::path(fig_dir, "fig_grade_agreement.png"), fig_agree,
  width = 9.5, height = 4.2, dpi = 200, bg = "white")
