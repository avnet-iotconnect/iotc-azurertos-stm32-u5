#!/bin/bash

UNZIP="unzip -q -o"

pushd "$(dirname $0)"/../../

cube_zip_name='en.x-cube-azure-v2-3-0.zip'
if [ ! -f ${cube_zip_name} ]; then
  echo "The X-Cube Azure project needs to be downloaded as ${cube_zip_name} into ${PWD} "
  exit 2
fi

rm -rf STM32CubeExpansion_Cloud_AZURE_*

echo "Extracting files from ${cube_zip_name}..."
%{UNZIP} -q ${cube_zip_name}
pushd STM32CubeExpansion_Cloud_AZURE_*/ >/dev/null
echo "Copying files from the package over the repository files..."
cp -nr Drivers Middlewares Projects Utilities .. # do not overwrite existing files
popd >/dev/null
rm -rf STM32CubeExpansion_Cloud_AZURE_*