# Dockerfile
FROM rocker/shiny:4.4.1

# System libraries for rmarkdown, pdftools, xml2, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl-dev libcurl4-openssl-dev libxml2-dev \
    libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    libpoppler-cpp-dev git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install R packages used in your Rmd
RUN R -e "install.packages(c( \
  'rmarkdown','shiny','ggplot2','gt','dplyr','tibble','stringr','tidyr','tidyverse', \
  'lubridate','readr','leaflet','leaflet.extras','patchwork','scales','htmltools', \
  'tidycensus','plotly','pdftools','glue','rvest','purrr','xml2','httr','forcats','jsonlite' \
), repos='https://cloud.r-project.org')"

# Copy app into Shiny Server's default site dir
# If your files are under Desktop/DTR/code/developer, adjust the COPY accordingly.
WORKDIR /srv/shiny-server/
COPY . /srv/shiny-server/

# If your Rmd isn't named index.Rmd, rename or set an index.
# Shiny Server serves interactive Rmds directly from this directory.

# Shiny Server listens on 3838 by default
EXPOSE 3838
CMD ["/usr/bin/shiny-server"]
