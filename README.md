# 'Lil Dev

How to set up a basic coding environment on the Raspberry Pi 3B.

## Step 1 - Booting Image:
download minimal Raspbian Buster image from here: 
https://www.raspberrypi.org/downloads/raspbian/

Raspbian Buster is the RPI equivalent of Debian Buster.  It comes with Python 3.7.5
built-in, but more importantly, the Python packages that we'll download are super easy
to install via `pip` from [piwheels](piwheels.com).  

*Why not Ubuntu? Or Anaconda to manage packages/dependencies?*

While Ubuntu has some good, stable images for the Raspberry Pi, the aptitude repos
for many Python packages are fairly old.  If you don't feel the need to stay
on top of the most current updates, then Ubuntu will be totally adequate.

The ports of Anaconda for the RPI, on the other hand, I find pretty disappointing. 
Maintenance seems pretty infrequent and the available packages are limited. The piwheels
project seems much more promising for updates and attaining the general catalog of packages
normally found on PyPi. 

## Step 1.5:
*If running RPI headless:*

add ssh file to boot partition by cd-ing into your SD-card directory and executing

`touch ssh`

This just needs to be blank file, no format necessary. More info [here](https://www.raspberrypi.org/documentation/remote-access/ssh/)

## Step 2 - Initial Raspbian Setup:
*If running RPI headless:*

- ssh with `pi@ipaddress`

password is: `raspberry`

change your password with `passwd` command

update and upgrade: `sudo apt update && sudo apt full-upgrade`

## Step 3 - Install OS Dependencies

install pip: `sudo apt install python3-pip`

numpy and general: `sudo apt install sqlite3 libatlas3-base libgfortran5 git libpq5`

spatial: `sudo apt install libspatialindex-dev xsel xclip libxml2-dev libxslt-dev libgdal-dev`

for Pillow: `sudo apt install libwebpdemux2 libzstd1 libopenjp2-7 libjbig0 libtiff5 liblcms2-2 libwebp6 libwebpmux3 libjpeg-dev zlib1g-dev libzmq-dev`

**reactivate bash-profile:** `source .profile`

## Step 4 - Pip Install Python Packages

### Python Packages:

General/SciPy/ML/Viz:
- Jupyter/iPython
- Pandas
- NumPy
- SciPy
- sklearn
- xgboost
- matplotlib
- seaborn

`pip3 install Cython jupyter numpy scipy matplotlib pandas scikit-learn scikit-image seaborn`

Web-Scraping:
- scrapy
- selenium
- bs4

`pip3 install requests selenium beautifulsoup4 Scrapy`

NLP-related:
- nltk
- gensim 
- textblob

`pip3 install nltk gensim textblob`

Web-server/Database:
- flask
- pymongo
- pscypg2

`pip3 install Flask pymongo psycopg2`

#### Geopandas :weary:
This was mega annoying because the `apt` version of 'libproj-dev' is at 5.2.0 for Buster rather than
the 6.0.0+ that 'pyproj' - a geopandas dependency - currently needs.  Building PROJ from source proved too painful and buggy, so I just elected to use an older version of 'pyproj'.

`pip3 install shapely fiona pyproj==1.9.6 geopandas`

**reactivate bash-profile:** `source .profile`

## Step 5 - Install Database Tools
### Database Tools:

- PostgreSQL

`sudo apt install -y postgresql libpq-dev postgresql-client postgresql-client-common`

[Extra setup](https://opensource.com/article/17/10/set-postgres-database-your-raspberry-pi)

- MongoDB

`sudo apt install -y mongodb`

debian repo versions are very old @v2.4.14

The main complication with Mongo setups on Raspberry Pis has to do with the newer versions of 
Mongo needing 64-bit operating systems, while Raspbian images are currently all 32-bit operating
systems.  Memory issues also play some role in this.

I didn't think it worth the while, but this might allow you to get up to v3.2: 
http://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/.

- Redis

`sudo apt install -y redis`

- MySQL (MariaDB)

TODO: https://pimylifeup.com/raspberry-pi-mysql/

## Extras:
### More ML tools:

These Deep Learning tools are probably overkill for the Pi, but I've included
them just in case.

**Tensorflow**:

`pip3 install tensorflow==1.13.1`

This version is slightly old, but is confirmed to build properly.  The official
instructions on the Tensorflow website using Docker to build the wheel failed 
when it got to SciPy...

**Keras**:

``` 
sudo apt-get install libatlas-base-dev
sudo apt-get install gfortran
sudo apt-get install python3-h5py
sudo pip3 install keras
```

**PyTorch**:

dependencies: 

`sudo apt install libopenblas-dev cmake cython python3-yaml`

```
# gdown allows you to download files from Google Drive
pip3 install gdown
gdown --id 1D3A5YSWiY-EnRWzWbzSqvj4YdY90wuXq --output torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
pip3 install torch-1.0.0a0+8322165-cp37-cp37m-linux_armv7l.whl
```

NOTE: this is the build for armv7 (RPI 2 & 3)

[.whl file on Google Drive](https://drive.google.com/file/d/1D3A5YSWiY-EnRWzWbzSqvj4YdY90wuXq/view)

for 3B+ and later: https://devtalk.nvidia.com/default/topic/1049071/jetson-nano/pytorch-for-jetson-nano-with-new-torch2trt-converter/

## Extras

**Docker:**

`curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh`

**Java/Scala:**

```
sudo apt-get install openjdk-8-jdk
wget https://downloads.lightbend.com/scala/2.12.10/scala-2.12.10.deb
sudo dpkg -i scala-2.12.10.deb
```

sbt: 
```
sudo apt-get install apt-transport-https
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update && sudo apt-get install sbt
```

limit memory usage:
`sudo nano /usr/bin/sbt`

add `SBT_OPTS=-Xmx256M` to beginning

https://aknay.github.io/2017/05/09/how-to-install-scala-and-sbt-in-raspberry-pi-3.html

**Node.js; npm:**

```
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt install nodejs
```

**Golang**

TODO
https://www.e-tinkers.com/2019/06/better-way-to-install-golang-go-on-raspberry-pi/

**Rust**

TODO
https://www.makeuseof.com/tag/getting-started-rust-raspberry-pi/


chmod +x  lil_dev/raspbian/setup.sh //add execute permission
sudo lil_dev/raspbian/setup.sh -b

Basic Install Size = 
Full Install Size = 6.2G

**OpenCV**

https://linuxize.com/post/how-to-install-opencv-on-raspberry-pi/