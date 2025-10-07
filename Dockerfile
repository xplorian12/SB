FROM rocker/verse:4.4.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
    libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install2.r --error --skipinstalled \
    shiny plotly gt dplyr tidyr ggplot2 lubridate scales readr stringr tibble

WORKDIR /app
COPY . /app

ENV PORT=3838
CMD ["bash", "-lc", "R -e 'rmarkdown::run(\"scratch.Rmd\", shiny_args=list(host=\"0.0.0.0\", port=as.numeric(Sys.getenv(\"PORT\", 3838))))'"]
