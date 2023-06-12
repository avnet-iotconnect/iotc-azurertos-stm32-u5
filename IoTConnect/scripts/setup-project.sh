#!/bin/bash

set -e

pushd "$(dirname $0)"/../../

git submodule update --init --recursive

cube_zip_name='en.x-cube-azure-v2-3-0.zip'
if [ ! -f ${cube_zip_name} ]; then
  echo "The X-Cube Azure project needs to be downloaded as ${cube_zip_name} into ${PWD} "
  exit 2
fi

rm -rf STM32CubeExpansion_Cloud_AZURE_*

echo "Extracting files from ${cube_zip_name}..."
unzip -q -o ${cube_zip_name}
pushd STM32CubeExpansion_Cloud_AZURE_*/ >/dev/null

#remove the unsupported project
rm -rf Projects/B-U585I-IOT02A/Applications/NetXDuo

echo "Copying files from the package over the repository files..."
cp -nr Drivers Middlewares Projects Utilities .. # do not overwrite existing files

popd >/dev/null

echo "Cleaning up..."
rm -rf STM32CubeExpansion_Cloud_AZURE_*

echo "Done."