resolve_theme <- function(theme) {
  # theme = NULL means no Bootstrap (TODO: is this actually supported?)
  if (is.null(theme)) return(theme)
  # Bootstrap/Bootswatch 3 names (backwards-compatibility)
  if (is.character(theme)) {
    if (length(theme) != 1) {
      stop("`theme` must be character vector of length 1.", call. = FALSE)
    }
    if (theme %in% "default") {
      return("cosmo")
    }
    return(match.arg(theme, themes()))
  }
  if (is.list(theme)) {
    if (!is_available("rmarkdown", "2.6.6")) {
      stop("Providing a list to `theme` requires the rmarkdown verion 2.6.6 or higher.", call. = FALSE)
    }
    return(as_bs_theme(theme))
  }
  stop(
    "`theme` expects any one of the following values: \n",
    "    (1) a character string referencing a Bootswatch 3 theme name, \n",
    "    (2) a list of arguments to bslib::bs_theme(), \n",
    "    (3) a bslib::bs_theme() object."
    , call. = FALSE)
}

as_bs_theme <-  function(theme) {
  if (is_bs_theme(theme)) {
    return(theme)
  }
  if (is.list(theme)) {
    return(do.call(bslib::bs_theme, theme))
  }
  NULL
}

is_bs_theme <- function(x) {
  is_available("bslib") && bslib::is_bs_theme(x)
}

get_color_contrast <- function(color) {
  out <- sass::sass(
    list(
      sass::sass_file(
        system.file("sass-utils", "color-contrast.scss", package = "bslib")
      ),
      sprintf("foo{color:color-contrast(%s)}", color)
    ),
    options = sass::sass_options(output_style = "compressed")
  )
  sub("}", "", sub("foo{color:", "", out, fixed = TRUE), fixed = TRUE)
}


themes <- function() {
  c("bootstrap",
    "cerulean",
    "journal",
    "flatly",
    "readable",
    "spacelab",
    "united",
    "cosmo",
    "lumen",
    "paper",
    "sandstone",
    "simplex",
    "yeti"
  )
}
