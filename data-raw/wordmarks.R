# THIS CODE LOADS AND SAVES WORDMARK SVGs FROM WIKIPEDIA
# THEY WERE THE RAW START FOR MY NEW ENDZONE WORDMARKS
raw <- rvest::read_html("https://commons.wikimedia.org/wiki/National_Football_League")

files <- xml2::xml_find_all(raw, "//a[contains(concat(' ',normalize-space(@href),' '),'.svg')]") |>
  xml2::xml_find_all(".//img") |>
  xml2::xml_attr("src")

urls <- files[!stringr::str_detect(files, "Conference")] |>
  stringr::str_extract("[:graph:]+(?=.svg/)") |>
  stringr::str_remove_all("/thumb") |>
  paste0(".svg")

t <- nflreadr::load_teams()

teams <- t |>
  dplyr::arrange(team_division) |>
  dplyr::pull(team_abbr)

curl::multi_download(urls, paste0("data-raw/wordmarks/wiki/", teams, ".svg"))
