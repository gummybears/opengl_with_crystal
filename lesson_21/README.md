In lesson 17 we are going to install the latest
GLFW software which is currently version 3.4

To install GLFW you have to do the following

1) Download (clone) the software from github

$ git clone https://github.com/glfw/glfw.git

2) Install the GLFW software

# cd glfw
# cmake .
# make
# sudo make install

3) Check the software is installed

Open the file /usr/local/include/GLFW/glfw3.h
and check the version
