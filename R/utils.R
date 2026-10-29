# https://www.joedolson.com/2008/05/testing-color-contrast/
# Color difference formula: (must be greater than 500)
color_diff <- function(col1, col2) {
  rgb1 <- as.vector(col2rgb(col1))
  rgb2 <- as.vector(col2rgb(col2))

  diff <-
    (max(rgb1[1],rgb2[1]) - min(rgb1[1],rgb2[1])) +
    (max(rgb1[2],rgb2[2]) - min(rgb1[2],rgb2[2])) +
    (max(rgb1[3],rgb2[3]) - min(rgb1[3],rgb2[3]))

  return(diff)
}

icon_from_desc <- function(desc){
  dplyr::case_when(
    desc == "FG" ~             system.file("fg.png", package = "drivecharts"),
    desc == "TD" ~             system.file("td.png", package = "drivecharts"),
    desc == "Opp TD" ~         system.file("td.png", package = "drivecharts"),
    desc == "Punt Return TD" ~ system.file("td.png", package = "drivecharts"),
    desc == "INT Return TD" ~  system.file("td.png", package = "drivecharts"),
    desc == "INT" ~            system.file("to.png", package = "drivecharts"),
    desc == "FUM" ~            system.file("to.png", package = "drivecharts"),
    TRUE ~ NA_character_
  )
}

resolve_team_colors <- function(away_team,
                                home_team,
                                ...,
                                limit = 150){
  teams <- nflreadr::load_teams(current = FALSE)
  home_colors <- teams |>
    dplyr::filter(team_abbr == home_team) |>
    dplyr::select(tidyselect::contains("color")) |>
    dplyr::select(team_color, team_color2) |>
    t() |>
    as.vector()
  away_colors <- teams |>
    dplyr::filter(team_abbr == away_team) |>
    dplyr::select(tidyselect::contains("color")) |>
    dplyr::select(team_color, team_color2) |>
    t() |>
    as.vector()
  colors <- tidyr::expand_grid(home = home_colors, away = away_colors) |>
    dplyr::mutate(
      diff = purrr::map2_int(home, away, color_diff)
    )
  best_comb <- colors |>
    dplyr::filter(diff >= limit) |>
    dplyr::slice_head(n = 1)
  best_comb
}

endzone_color <- function(team){
  t <- nflreadr::load_teams(current = FALSE)
  t |>
    dplyr::filter(team_abbr == team) |>
    dplyr::pull(team_color)
}

endzone_wordmark <- function(team){
  system.file(paste0(team, ".png"), package = "drivecharts")
}
