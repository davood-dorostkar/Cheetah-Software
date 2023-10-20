####################################
echo Stage 1 - Building Dependencies
####################################

# make a working directory
cd $HOME/Documents
rm -rf Cross
mkdir Cross
cd Cross

# install or update all apt-get dependencies
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install gcc -y                 # not cross
sudo apt-get install g++ -y
sudo apt-get install make -y
sudo apt-get install bison -y
sudo apt-get install flex -y
sudo apt-get install gawk -y
sudo apt-get install libgmp3-dev -y
sudo apt-get install libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg -y
sudo apt-get install mpc -y
sudo apt-get install texinfo -y            # optional
sudo apt-get install libcloog-isl-dev -y   # optional
sudo apt-get install build-essential -y
sudo apt-get install glibc-devel -y
sudo apt-get -y install gcc-multilib libc6-i386 -y

# download and unpack necessary files
wget http://ftpmirror.gnu.org/binutils/binutils-2.25.1.tar.gz
wget http://ftpmirror.gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.gz
wget http://ftpmirror.gnu.org/mpc/mpc-1.0.3.tar.gz
for f in *.tar*; do tar zvxf $f; done

# create installation directory
mkdir Install
export PREFIX="$HOME/Documents/Cross/Install"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

################################
echo Stage 2 - Building Compiler
################################

# install mpc
mkdir build-mpc
cd build-mpc
../mpc-1.0.3/configure --prefix="$PREFIX"
make -j6
make -j6 check
make -j6 install
cd ..

# install binutils
mkdir build-binutils
cd build-binutils
../binutils-2.25.1/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j6
make -j6 install
cd ..

# install gcc
mkdir build-gcc
cd build-gcc
../gcc-5.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --with-mpc="$PREFIX"
make -j6 all-gcc
make -j6 all-target-libgcc
make -j6 install-gcc
make -j6 install-target-libgcc
cd ..

################################
echo Stage 3 - Install LCM
################################
wget https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.0.tar.gz	
tar zvxf v1.5.0.tar.gz
mkdir build
cd build
cmake ..
make -j6
sudo make install

################################
echo Stage 4 - Install Eigen3
################################

sudo apt install libeigen3-dev
sudo apt install mesa-common-dev freeglut3-dev libblas-dev liblapack-dev libglib2.0-dev
sudo apt install default-jdk libjchart2d-java doxygen liblua5.3-dev lua5.3 python3-dev
pip install Sphinx myst-parser sphinx-rtd-theme