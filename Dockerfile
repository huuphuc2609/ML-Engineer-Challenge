# We will use Ubuntu for our image
FROM ubuntu:bionic

# Updating Ubuntu packages
RUN apt-get update && yes|apt-get upgrade
RUN apt-get install -y emacs

# Adding wget and bzip2
RUN apt-get install -y wget bzip2

# Install cURL
RUN apt-get update && apt-get install -y curl

# Add sudo
RUN apt-get -y install sudo

# Add user ubuntu with no password, add to sudo group
RUN adduser --disabled-password --gecos '' ubuntu
RUN adduser ubuntu sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/
RUN chmod a+rwx /home/ubuntu/

# Anaconda installing
RUN wget https://repo.continuum.io/archive/Anaconda3-5.3.1-Linux-x86_64.sh
RUN bash Anaconda3-5.3.1-Linux-x86_64.sh -b
RUN rm Anaconda3-5.3.1-Linux-x86_64.sh

# Set path to conda
ENV PATH /home/ubuntu/anaconda3/bin:$PATH

# Updating Anaconda packages
#RUN conda update conda
#RUN conda update anaconda
#RUN conda update --all

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml
RUN pip install transformers
RUN pip install Flask
RUN pip install torch==1.8.1+cpu torchvision==0.9.1+cpu torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "ds-nlp-demo-sentiment-analysis", "/bin/bash", "-c"]

COPY myservice ./myservice
COPY test_service.sh .
ENTRYPOINT ["python", "./myservice/app.py"]