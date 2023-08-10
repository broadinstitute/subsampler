FROM quay.io/broadinstitute/viral-baseimage:0.2.0

LABEL maintainer "dpark@broadinstitute.org"

ENV \
    SUBSAMPLER_PATH="/opt/subsampler" \
    CONDA_DEFAULT_ENV="default" \
    MINICONDA_PATH="/opt/miniconda"
ENV \
    PATH="$SUBSAMPLER_PATH:$MINICONDA_PATH/envs/$CONDA_DEFAULT_ENV/bin:$MINICONDA_PATH/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# update to mamba
RUN conda update -n base conda
RUN conda install -n base conda-libmamba-solver
RUN conda config --set solver libmamba

# initiate conda environment
RUN conda create -n $CONDA_DEFAULT_ENV python=3.7
RUN echo "source activate $CONDA_DEFAULT_ENV" >> ~/.bashrc
RUN hash -r

# clone subsampler github repo and install dependencies
WORKDIR /opt
RUN git clone https://github.com/andersonbrito/subsampler.git
RUN /bin/bash -c "set -e; sync; conda install -y --quiet --file /opt/subsampler/config/subsampler.yaml ; conda clean -y --all"

# default bash prompt
CMD ["/bin/bash"]
