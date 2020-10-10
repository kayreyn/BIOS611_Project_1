FROM rocker/verse
MAINTAINER Kaylia Reynolds <kayliamreynolds@gmail.com>
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('pROC')"
RUN R -e "install.packages('bestglm')"
RUN R -e "install.packages('randomForest')"
RUN R -e "install.packages('pixiedust')"
RUN R -e "install.packages('kableExtra')"
RUN R -e "install.packages('webshot')"
RUN R -e "install.packages('magick')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('stats')"
RUN R -e "install.packages('Rtsne')"