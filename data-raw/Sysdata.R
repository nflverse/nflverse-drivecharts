# The following code block requires sportyR < 2.0!!!
pitch <- sportyR::geom_football(
  "NFL",
  grass_color = scales::alpha("#567d46", 0.4),
  # grass_color = scales::alpha("#006500", 0.4),
  sideline_1_color = scales::alpha("#ffffff", 1),
  sideline_2_color = scales::alpha("#ffffff", 1),
  endline_color = scales::alpha("#ffffff", 1),
  goal_line_color = scales::alpha("#ffffff", 0.9),
  yard_markings_color = scales::alpha("#ffffff", 0.9),
  try_marking_color = scales::alpha("#ffffff", 0.9),
  directional_arrows_color = scales::alpha("#ffffff", 0.9),
  yard_numbers_color = scales::alpha("#ffffff", 0.9)
)
# Code for sportyR >= 2.0
pitch2 <- sportyR::geom_football(
  "NFL",
  color_updates = list(
    "offensive_half" = "#b6c6b3",
    "defensive_half" = "#b6c6b3",
    "sideline" = "#ffffff",
    "end_line" = "#ffffff",
    "goal_line" = "#ffffffe6",
    # assuming by yard_markings_color you want
    # yard line colors for all yard lines
    "minor_yard_line" = "#ffffffe6",
    "major_yard_line" = "#ffffffe6",
    "try_mark" = "#ffffffe6",
    "directional_arrow" = "#ffffffe6",
    "yardage_marker" = "#ffffffe6",
    "offensive_endzone" = "black",
    "defensive_endzone" = "#b6c6b3",
    "field_apron" = "#b6c6b3",
    "field_border" = "#b6c6b3",
    "team_bench_area" = NULL
  ),
  x_trans = 60,
  y_trans = 25 + 1/3
)
usethis::use_data(pitch, overwrite = TRUE, internal = TRUE)
