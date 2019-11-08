#!/bin/bash

function usage()
{
    echo "Usage : $0 [-f]"
}

# need arguments for RPI Model and full/modified install
#arguments
#-b --basic
#-f --full
#-d --databases 
#--deep-learning 
#--extra-python
#--languages

base=false
deep=false
deep_all=false
geop=false
nlp=false
xgb=false
tensor=false
pytorch=false
keras=false
lang=false
misc=false
docker=false
skip=false

while getopts bfd-: arg; do
    case $arg in
        b )  base=true
             ;;
        f )  base=true
             databases=true
             deep=true
             deep_all=true
             nlp=true
             geop=true
             xgb=true
             lang=true
             misc=true
             ;;
        - )  LONG_OPTARG="${OPTARG}"
            case $OPTARG in
            nlp           )  nlp=true ;;
            deep=all      )  deep=true 
                             deep_all=true
                             ;;
            deep=keras    )  keras=true 
                             deep=true
                             ;;
            deep=pytorch  )  pytorch=true 
                             deep=true   
                             ;;
            deep=tensorflow )tensor=true 
                             deep=true
                             ;;
            geopandas     )  geop=true ;;
            xgboost       )  xgb=true ;;
            languages     )  lang=true ;;
            misc          )  misc=true ;;
            docker        )  docker=true ;;
            skip_base     )  skip=true ;;
            * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
            esac ;;
        \? ) exit 2 ;;  # getopts already reported the illegal option
    esac
done
shift "$((OPTIND-1))" # remove parsed options and args from $@ list

# basic installation
if [ "$base" = true ] && [ "$skip" = false ]; then
    echo -e "\nUpdating OS"
    apt -y update && sudo apt -y full-upgrade 
    echo -e "\nInstalling Basic Packages and Python Dependencies"
    apt install -y python3-pip sqlite3 cmake git libatlas3-base libgfortran5 libpq5
    echo "\nInstalling Packages for Spatial Python Packages"
    apt install -y libspatialindex-dev xsel xclip libxml2-dev libxslt-dev libgdal-dev
    echo -e "\nInstalling Packages for Image-Based Python Packages"
    apt install -y libwebpdemux2 libzstd1 libopenjp2-7 libjbig0 libtiff5 liblcms2-2 \
    libwebp6 libwebpmux3 libjpeg-dev zlib1g-dev libzmq-dev
    echo -e "\nReactivating Bash Profile"
    source ~/.profile
    # basic Python install
    echo -e "\nPip installing basic SciPy stack"
    pip3 install Cython jupyter numpy scipy matplotlib pandas \
    scikit-learn scikit-image seaborn
    echo -e "\nPip installing Web-Scraping Tools"
    pip3 install requests selenium beautifulsoup4 Scrapy
    echo -e "\nPip installing database drivers & Flask"
    pip3 install Flask pymongo psycopg2
    echo -e "\nInstalling PostgreSQL"
    apt install -y postgresql libpq-dev postgresql-client postgresql-client-common
    echo -e "\nInstalling MongoDB v2.4"
    apt install -y mongodb
    echo -e "\nReactivating Bash Profile"
    source ~/.profile
elif [ "$base" = true ] && [ "$skip" = true ]; then
    echo "Skipping Base Install -- I hope you did it already!"
else
    echo "-b or -f flags missing from command execution"
fi

# extra Python tools
if [ "$nlp" = true ] && [ "$base" = true ]; then
    echo -e "\nInstalling NLP packages"
    pip3 install nltk gensim textblob
fi

if [ "$xgb" = true ] && [ "$base" = true ]; then
    echo -e "\nInstalling xgboost"
    cd ~
    git clone --recursive https://github.com/dmlc/xgboost
    cd xgboost
    mkdir build
    cd build
    cmake ..
    make -j4
    cd ..
    cd python-package
    python3 setup.py install
fi

if [ "$geop" = true ] && [ "$base" = true ]; then
    echo -e "\nInstalling Geopandas"
    pip3 install shapely fiona pyproj==1.9.6 geopandas
fi

# other languages
if [ "$lang" = true ] && [ "$base" = true ]; then
    echo -e "\nInstalling Node.js"
    curl -sL https://deb.nodesource.com/setup_10.x | bash -
    apt install -y nodejs
    echo -e "\nInstalling Java/Scala"
    apt install -y openjdk-8-jdk
    wget https://downloads.lightbend.com/scala/2.12.10/scala-2.12.10.deb
    dpkg -i scala-2.12.10.deb
    rm scala-2.12.10.deb
    apt install -y apt-transport-https
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
    apt -y update && apt install -y sbt
    sed -i '3s/^/SBT_OPTS=-Xmx256M\n/' /usr/bin/sbt
fi

# Deep Learning tools
if [ "$deep" = true ] && [ "$base" = true ]; then
    if [ "$tensor" = true ] || [ "$deep_all" = true ]; then
        echo -e "\nPip Installing Tensorflow 1.13.1"
        pip3 install tensorflow==1.13.1
    fi
    if [ "$keras" = true ] || [ "$deep_all" = true ]; then
    echo -e "\nInstalling Keras Dependencies"
    apt install -y libatlas-base-dev gfortran python3-h5py
    echo -e "\nPip Installing Keras"
    pip3 install keras
    fi
    if [ "$pytorch" = true ] || [ "$deep_all" = true ]; then
    echo -e "\nInstalling PyTorch Dependencies"
    apt install -y libopenblas-dev cmake cython python3-yaml
    pip3 install gdown
    gdown --id 1D3A5YSWiY-EnRWzWbzSqvj4YdY90wuXq \
    --output torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
    echo -e "\nPip Installing PyTorch"
    pip3 install torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
    rm torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
    fi
fi

# Misc Tools
if [ "$misc" = true ] && [ "$base" = true ]; then
    # extra database tools
    apt install -y redis
fi
if [ "$docker" = true ] && [ "$base" = true ]; then
    # Docker
    curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
fi