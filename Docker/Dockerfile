FROM continuumio/miniconda3:4.6.14

WORKDIR /app

RUN apt-get update && yes Y | apt-get install build-essential

RUN conda install -c r r-essentials

RUN R --vanilla -e 'install.packages(c("optparse", "caret", "party", "rpart", "rpart.plot"), repos="http://cran.r-project.org")'
