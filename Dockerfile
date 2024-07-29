# start from the rstudio/plumber image
FROM rocker/r-ver:4.4.1

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y  libssl-dev  libcurl4-gnutls-dev  libpng-dev
#RUN apt update -qq && apt install --yes --no-install-recommends r-cran-plumber

# install plumber and other necessary packages
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('rpart')"
RUN R -e "install.packages('plumber')"

# copy everything from the current directory into the container
COPY API.R myAPI.R

# open port to traffic
EXPOSE 8000

# when the container starts, start the myAPI.R script
ENTRYPOINT ["R", "-e", \
            "pr <- plumber::plumb('myAPI.R'); pr$run(host='0.0.0.0', port=8000)"]