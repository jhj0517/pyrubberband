#!/bin/sh

ENV_NAME="test-environment"
set -e

conda_create ()
{

    hash -r
    conda config --set always_yes yes --set changeps1 no
    conda update -q conda
    conda config --add channels pypi
    conda info -a
    deps='pip numpy scipy pandas requests pytest coverage numpydoc matplotlib sphinx scikit-learn seaborn'

    conda create -q -n $ENV_NAME "python=$TRAVIS_PYTHON_VERSION" $deps
}

src="$HOME/env/miniconda$TRAVIS_PYTHON_VERSION"
if [ ! -d "$src" ]; then
    mkdir -p $HOME/env
    pushd $HOME/env

        # Download miniconda packages
        wget http://repo.continuum.io/miniconda/Miniconda-3.16.0-Linux-x86_64.sh -O miniconda.sh;

        # Install environment
        bash miniconda.sh -b -p $src

        export PATH="$src/bin:$PATH"
        conda_create 

        source activate $ENV_NAME

        conda install -c conda-forge ffmpeg

        pip install soundfile
        pip install python-coveralls
        pip install pytest-cov
        source deactivate
    popd
else
    echo "Using cached dependencies"
fi
