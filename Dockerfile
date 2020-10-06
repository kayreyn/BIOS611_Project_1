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