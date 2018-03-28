#!/bin/sh
# Note: this script assumes that it is being run from within the deploymnet dir

# create release dir from latest tag
current_tag=$(git describe --tags | awk -F"-" '{print $1"."$2}')
release_dir=$(echo "pupil_${current_tag}_linux_x64")
echo "release_dir:  ${release_dir}"
mkdir ${release_dir}

# build dependencies
python3 ../pupil_src/shared_modules/pupil_detectors/build.py
python3 ../pupil_src/shared_modules/cython_methods/build.py

# bundle Pupil Capture
cd deploy_capture
./bundle.sh
mv *.deb ../$release_dir

# bundle Pupil Service
cd ../deploy_service
./bundle.sh
mv *.deb ../$release_dir

# bundle Pupil Player
cd ../deploy_player
./bundle.sh
mv *.deb ../$release_dir

# temporary line for diagnostics before we gzip and transfer bundles
cd ../ && ls -alR