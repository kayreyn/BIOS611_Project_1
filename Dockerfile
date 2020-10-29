FROM rocker/verse
MAINTAINER Kaylia Reynolds <kayliamreynolds@gmail.com>
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('pROC')"
RUN R -e "install.packages('bestglm')"
RUN R -e "install.packages('pixiedust')"
RUN R -e "install.packages('kableExtra')"
RUN R -e "install.packages('webshot')"
RUN R -e "install.packages('magick')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('stats')"
RUN R -e "install.packages('Rtsne')"
RUN R -e "install.packages('GGally')"
RUN R -e "install.packages('ggfortify')"
RUN R -e "install.packages('caret')"
RUN R -e "install.packages('e1071')"
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine matplotlib pandasql bokeh