FROM rocker/verse
MAINTAINER Kaylia Reynolds <kayliamreynolds@gemail.com>
RUN R -e "install.packages('gridExtra')"