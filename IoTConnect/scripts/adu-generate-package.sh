#!/bin/bash

set -e

fw_filename=$1
fw_version=$2
fw_provider=$3
fw_name=$4
dev_manufacturer=$5
dev_model=$6

this_dir=$(dirname "$0")

function usage {
  echo "Usage: $0 <fw_filename_path> <fw_version> <fw_provider> <fw_name> [[device manufacturer] [device model]]" >&2
  echo "The non-secure app file is usually located at Projects/B-U585I-IOT02A/Applications/TFM_Azure_IoT/TFM_Appli/Binary/tfm_ns_app_enc_sign.bin"
  echo "If either the device model or manufacturer are not provided, default values will be used." >&2
  echo "Example:" >&2
  echo "    "$(dirname "$0")"/adu-generate-package.sh ./fw1.1.0.bin 1.1.0 AVNET SAMPLEAPP" >&2
}

if [[ -z "${fw_filename}" || -z "${fw_version}" || -z "${fw_provider}" ]]; then
  usage
  exit 1
fi

if [[ -z "${dev_manufacturer}" ]]; then
      dev_manufacturer="STMicroelectronics"
fi

if [[ -z "${dev_model}" ]]; then
      dev_model="B-U585I-IOT02A"
fi

if [[ -z "${fw_filename}" ]]; then
  usage
  exit 3
fi

if [[ ! -f "${fw_filename}" ]]; then
  usage
  echo "File ${fw_filename} not found!" >&2
  exit 4
fi

td="${fw_provider}-${fw_name}-${fw_version}"
tf="${td}/${fw_provider}-${fw_name}-${fw_version}.importmanifest.json"
sha256=$(sha256sum -b "${fw_filename}" | cut -f1 -d' ' | xxd -r -p - | base64)
file_size=$(du -b "${fw_filename}" | cut -f1)
created_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
mkdir -p "${td}"
cp -f "$this_dir/adu-import-manifest-template.json" "${tf}"
cp -f "${fw_filename}" "${td}"
sed -i "s#@@@FW_PROVIDER@@@#${fw_provider}#g" "${tf}"
sed -i "s#@@@FW_NAME@@@#${fw_name}#g" "${tf}"
sed -i "s#@@@FW_VERSION@@@#${fw_version}#g" "${tf}"
sed -i "s#@@@DEVICE_MANUFACTURER@@@#${dev_manufacturer}#g" "${tf}"
sed -i "s#@@@DEVICE_MODEL@@@#${dev_model}#g" "${tf}"
sed -i "s#@@@FW_FILENAME@@@#$(basename ${fw_filename})#g" "${tf}"
sed -i "s#@@@FW_FILE_SIZE@@@#${file_size}#g" "${tf}"
sed -i "s#@@@FW_SHA256@@@#${sha256}#g" "${tf}"
sed -i "s#@@@CREATED_DATE@@@#${created_date}#g" "${tf}"

echo Done



