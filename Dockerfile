# start from the rstudio/plumber image
FROM rocker/r-ver:4.4.1

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y  libssl-dev  libcurl4-gnutls-dev  libpng-dev
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libsodium-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*

# install plumber and other necessary packages
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('rpart')"
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("tidyverse",upgrade="never", version = "1.3.2")'
RUN Rscript -e 'remotes::install_version("plumber",upgrade="never", version = "1.2.0")'


# copy everything from the current directory into the container
COPY diabetes_binary_health_indicators_BRFSS2015.csv API.R /

# open port to traffic
EXPOSE 8000

# when the container starts, start the myAPI.R script
ENTRYPOINT ["R", "-e", \
            "pr <- plumber::plumb('API.R'); pr$run(host='0.0.0.0', port=8000)"]