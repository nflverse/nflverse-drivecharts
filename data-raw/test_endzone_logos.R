# THIS PLOTS PITCH PLUS NEW ENDZONES AS PDF FOR TESTS

save_plot <- function(away_team, home_team){
  endzone <- data.frame(
    x = c(5, 115),
    y = 53.333/2,
    team_abbr = c(away_team, home_team),
    color = c(endzone_color(away_team), endzone_color(home_team)),
    angle = c(90, -90)
  )
  pitch <- pitch +
    ggplot2::annotate(
      "tile",
      x = c(20, 100),
      y = 53.33/2,
      width = 20,
      height = 53.33,
      fill = "red",
      alpha = 0.1
    )

  p <- pitch +
    # ENDZONE colors
    ggplot2::geom_tile(
      data = endzone,
      ggplot2::aes(
        x = c(5, 115),
        y = 53.33/2,
        fill = color
      ),
      width = 10,
      height = 53.33
    ) +
    # Draw Goal Lines on top of colored endzone
    # goal lines are 8 inches. I round to 0.25 yards
    ggplot2::annotate(
      ggplot2::GeomTile,
      x = c(10 - 0.25/2, 110 + 0.25/2),
      y = 53.33/2,
      fill = "white",
      width = 0.25,
      height = 53.33
    ) +
    ggplot2::scale_fill_identity() +
    nflplotR::geom_from_path(
      data = endzone,
      ggplot2::aes(x = x, y = y, path = system.file(paste0(team_abbr, ".png"), package = "drivecharts"), angle = angle),
      height = 0.1,
      alpha = 0.9
    )

  ggplot2::ggsave(paste0("data-raw/new_endzones/", away_team, "_", home_team, ".pdf"), width = 20, height = 15, units = "cm")
}

save_plot("LAC", "BUF")

teams <- nflreadr::load_teams()

df <- tibble::tibble(
  away_team = teams$team_abbr[c(TRUE, FALSE)],
  home_team = teams$team_abbr[c(FALSE, TRUE)],
)

purrr::pwalk(df, save_plot)
