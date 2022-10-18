options(nflreadr.verbose = FALSE)

save_new_games <- function(){
  saved_games <- read.csv("auto/saved_games.csv")

  # data.frame(game_id = NA_character_) |>
  #   write.csv("auto/saved_games.csv", row.names = FALSE)

  completed_games <- nflreadr::load_schedules() |>
    dplyr::filter(!is.na(result)) |>
    dplyr::select(game_id)

  to_save <- completed_games$game_id[!completed_games$game_id %in% saved_games$game_id]

  if (length(to_save) == 0) {
    cli::cli_alert_info("Nothing to do at the moment!")
    return(invisible())
  }

  seasons <- substr(to_save, 1, 4) |> unique() |> as.integer()

  cli::cli_alert_info("Going to create charts for {length(to_save)} game{?s} in {length(seasons)} season{?s}")

  purrr::walk(seasons, save_season, ids_to_save = to_save)

  new_saved_games <- dplyr::bind_rows(saved_games, data.frame(game_id = to_save)) |>
    dplyr::arrange(game_id)

  write.csv(new_saved_games, "auto/saved_games.csv", row.names = FALSE)
}

save_season <- function(season, ids_to_save){
  cli::cli_alert_info("Start working on {.val {season}} season...")
  pbp <- nflreadr::load_pbp(season)
  in_season_ids <- ids_to_save[ids_to_save %in% pbp$game_id] |> unique()
  if(length(in_season_ids) == 0){
    cli::cli_alert_info("No new games in {.val {season}}")
    return(invisible())
  }
  purrr::walk(in_season_ids, function(in_season_id, pbp){
    cli::cli_progress_step("Save {.val {in_season_id}}")
    # filter down to game
    g <- dplyr::filter(pbp, game_id == in_season_id)
    # create plot objects
    overall <- drivecharts::ggdrive(g)
    away <-    drivecharts::ggdrive(g, "away", with_score_plot = TRUE)
    home <-    drivecharts::ggdrive(g, "home", with_score_plot = TRUE)
    # save temporarily
    save_chart(overall, in_season_id, "overall")
    save_chart(away, in_season_id, "away")
    save_chart(home, in_season_id, "home")
  }, pbp = pbp)

  upload_files <- list.files("auto", pattern = "*.png", full.names = TRUE)
  drivecharts_upload(upload_files)
  file.remove(upload_files)
}

save_chart <- function(obj, game_id, type = c("overall", "home", "away")){
  file_path <- file.path(".", "auto", paste0(game_id, "_", type, ".png"))
  suppressWarnings(
    ggplot2::ggsave(
      file_path,
      plot = obj,
      width = 3308,
      height = 3308/2,
      units = "px",
      dpi = 300
    )
  )
}

#' Upload to divecharts release
#'
#' @param files vector of filepaths to upload
#' @param tag release name
#' @param ... other args passed to `piggyback::pb_upload()`
drivecharts_upload <- function(files, tag = "drivecharts", ...){
  # upload files
  piggyback::pb_upload(files, repo = "nflverse/nflverse-drivecharts", tag = tag, ...)
  cli::cli_alert_info("Uploaded {length(files)} to nflverse/nflverse-drivecharts @ {tag} on {Sys.time()}")
}


save_new_games()
