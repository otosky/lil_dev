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

while getopts bfd-: arg; do
    case $arg in
        b )  base=true
             ;;
        f )  base=true
             databases=true
             deep=true
             extra=true
             lang=true
             misc=true
             ;;
        d )  databases=true 
             ;;
        - )  LONG_OPTARG="${OPTARG}"
            case $OPTARG in
            deep-learning )  deep=true ;;
            extra-python  )  extra=true ;;
            languages     )  lang=true ;;
            misc          )  misc=true ;;
            * )         echo "Illegal option --$OPTARG" >&2; exit 2 ;;
            esac ;;
        \? ) exit 2 ;;  # getopts already reported the illegal option
    esac
done
shift "$((OPTIND-1))" # remove parsed options and args from $@ list

# basic installation
if [ base = true ]; then
    echo "Updating OS"
    apt -y update && sudo apt -y full-upgrade 
    echo "Installing Basic Packages and Python Dependencies"
    apt install -y python3-pip sqlite3 git libatlas3-base libgfortran5 libpq5
    echo "Installing Packages for Spatial Python Packages"
    apt install -y libspatialindex-dev xsel xclip libxml2-dev libxslt-dev libgdal-dev
    echo "Installing Packages for Image-Based Python Packages"
    apt install libwebpdemux2 libzstd1 libopenjp2-7 libjbig0 libtiff5 liblcms2-2 \
    libwebp6 libwebpmux3 libjpeg-dev zlib1g-dev libzmq-dev
    echo "Reactivating Bash Profile"
    source .profile
    # basic Python install
    echo "Pip installing basic SciPy stack"
    pip3 install Cython jupyter numpy scipy matplotlib pandas \
    scikit-learn scikit-image seaborn
    echo "Pip installing Web-Scraping Tools"
    pip3 install requests selenium beautifulsoup4 Scrapy
    echo "Pip installing database drivers & Flask"
    pip3 install Flask pymongo psycopg2
    echo "Installing PostgreSQL"
    apt install -y postgresql libpq-dev postgresql-client postgresql-client-common
    echo "Installing MongoDB v2.4"
    apt install -y mongodb
    echo "Reactivating Bash Profile"
    source .profile
else
    echo "-b or -f flags missing from command execution"
fi

# extra Python tools
if [ extra = true ]; then
    pip3 install shapely fiona pyproj==1.9.6 geopandas
    pip3 install nltk gensim textblob
fi

# other languages
if [ lang = true ]; then
    echo "Installing Node.js"
    curl -sL https://deb.nodesource.com/setup_10.x | bash -
    apt install -y nodejs
    echo "Installing Java/Scala"
    apt-get install openjdk-8-jdk
    wget https://downloads.lightbend.com/scala/2.12.10/scala-2.12.10.deb
    dpkg -i scala-2.12.4.deb
    rm scala-2.12.10.deb
    apt install -y apt-transport-https
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
    apt -y update && apt install -y sbt
    sed -i '3s/^/SBT_OPTS=-Xmx256M\n/' /usr/bin/sbt
fi

# Deep Learning tools
if [ deep = true ]; then
    echo "Pip Installing Tensorflow 1.13.1"
    pip3 install tensorflow==1.13.1
    echo "Installing Keras Dependencies"
    apt install -y libatlas-base-dev gfortran python3-h5py
    echo "Pip Installing Keras"
    pip3 install keras
    echo "Installing PyTorch Dependencies"
    apt install libopenblas-dev cmake cython python3-yaml
    pip3 install gdown
    gdown --id 1D3A5YSWiY-EnRWzWbzSqvj4YdY90wuXq \
    --output torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
    echo "Pip Installing PyTorch"
    pip3 install torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
    rm torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
fi

# Misc Tools
if [ misc = true ]; then
    # extra database tools
    apt install -y redis
    # Docker
    curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
fi