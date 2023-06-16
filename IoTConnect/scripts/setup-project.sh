#!/bin/bash

set -e

pushd "$(dirname $0)"/../../ >/dev/null

cube_zip_name='en.x-cube-azure-v2-3-0.zip'

if [  "${1}" == "package" ]; then
  git clean -fdx -e "${cube_zip_name}"
fi

git submodule update --init --recursive

if [ ! -f ${cube_zip_name} ]; then
  echo "ERROR: The X-Cube Azure project needs to be downloaded as ${cube_zip_name} into ${PWD} "
  exit 2
fi

rm -rf STM32CubeExpansion_Cloud_AZURE_*

echo "Extracting files from ${cube_zip_name}..."
unzip -q -o "${cube_zip_name}"
pushd STM32CubeExpansion_Cloud_AZURE_*/ >/dev/null

#remove the unsupported project
rm -rf Projects/B-U585I-IOT02A/Applications/NetXDuo

echo "Copying files from the package over the repository files..."
cp -nr Drivers Middlewares Projects Utilities .. # do not overwrite existing files

popd >/dev/null

echo "Cleaning up..."
rm -rf STM32CubeExpansion_Cloud_AZURE_*

if [  "${1}" == "package" ]; then
  package_name="X-Cube-IoTConnect-v1.0.0"
  echo "Making the ${package_name} package..."
  mkdir -p "${package_name}"
  cat > README.txt <<END
If you don't have the ability to read markdown files, you can access the same README.md
in your browser by opening this project's GitHub repository at:
https://github.com/avnet-iotconnect/x-cube-iotconnect-azrtos-u5
END

  cp -rf IoTConnect Projects Drivers Middlewares Utilities README.md "${package_name}/"
  zip -r "${package_name}.zip" "${package_name}"
  #rm -rf "${package_name}"
fi


echo "Done."