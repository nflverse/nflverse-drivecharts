# THIS SCRIPT LOADS ENDZONES FILES FROM NGS
# I DROPPED THIS ATTEMPT BECAUSE THEY ARE BS
# I JUST KEEP THE CODE FOR FUTURE REFERENCE

save_endzone_image <- function(team){
  cli::cli_progress_step("Save {.pkg {team}}")
  read_path <- paste0(
    "https://nextgenstats.nfl.com/public/svg/logos/teams-field-endzone/",
    team,
    ".svg"
  )
  save_path <- file.path(getwd(), "data-raw", "endzone", "svg", paste0(team, ".svg"))

  img <-magick::image_read_svg(read_path)
  magick::image_write(img, save_path, format = "svg")
  cli::cli_progress_done()
}

convert_svg <- function(team){
  cli::cli_progress_step("Save {.pkg {team}}")
  read_path <- file.path(getwd(), "data-raw", "endzone", "svg", paste0(team, ".svg"))
  save_path <- file.path(getwd(), "data-raw", "endzone", "png", paste0(team, ".png"))

  img <-magick::image_read_svg(read_path)
  magick::image_write(img, save_path, format = "png")
  cli::cli_progress_done()
}

t <- nflreadr::load_teams()

purrr::walk(t$team_abbr, save_endzone_image)
purrr::walk(t$team_abbr, convert_svg)

t |>
  mutate(
    file = file.path(getwd(), "data-raw", "wordmarks", "png", paste0(team_abbr, ".png"))
  ) |>
  ggplot(aes(x = 1, y = 1)) +
  geom_tile(aes(fill = team_color), width = 3.5, height = 3.5) +
  nflplotR::geom_from_path(aes(path = file), height = 0.5) +
  facet_wrap(vars(team_abbr)) +
  scale_fill_identity() +
  NULL
