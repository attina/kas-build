#!/usr/bin/env bash

set -euo pipefail

usage() {
    printf 'Usage: %s <machine>\n' "$(basename "$0")" >&2
    exit 2
}

if [[ $# -ne 1 ]]; then
    usage
fi

machine=$1
if [[ ! $machine =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
    printf 'Error: invalid machine name: %s\n' "$machine" >&2
    exit 2
fi

if [[ ! $machine =~ ^ls1046a(.+)$ ]]; then
    printf 'Error: this script only supports ls1046a machines: %s\n' "$machine" >&2
    exit 2
fi
platform=ls1046a-${BASH_REMATCH[1]}

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
root_dir=$(cd -- "${script_dir}/.." && pwd)
image_dir=${root_dir}/build/tmp/deploy/images/${machine}
remote_host=pico-deb-ext
remote_dir=www/${machine}/images/test

if [[ ! -d $image_dir ]]; then
    printf 'Error: image directory does not exist: %s\n' "$image_dir" >&2
    exit 1
fi

shopt -s nullglob
sources=()
destinations=()

add_image() {
    local destination=$1
    shift
    local source=
    local candidate

    for candidate in "$@"; do
        # Prefer the real timestamped artifact over a convenience symlink.
        if [[ -f $candidate && ! -L $candidate ]]; then
            if [[ -n $source ]]; then
                printf 'Error: multiple source images matched for %s\n' "$destination" >&2
                exit 1
            fi
            source=$candidate
        fi
    done

    if [[ -z $source ]]; then
        printf 'Error: required image does not exist for %s\n' "$destination" >&2
        exit 1
    fi

    sources+=("$source")
    destinations+=("$destination")
}

emmc_images=("${image_dir}/firmware_${machine}_"*uboot_emmcboot.img)
sd_images=("${image_dir}/firmware_${machine}_"*uboot_sdboot.img)
qspi_images=("${image_dir}/firmware_${machine}_"*uboot_qspiboot.img)
boot_images=("${image_dir}/boot_${machine}_lts_6.18.tgz")
kernel_images=("${image_dir}/kernel-fsl-${platform}-sdk"*.itb)
rootfs_images=("${image_dir}/pico-sdk-ls1046a-${machine}.rootfs"*.tar.gz)

add_image "firmware_${machine}_uboot_emmcboot.img" "${emmc_images[@]}"
add_image "firmware_${machine}_uboot_sdboot.img" "${sd_images[@]}"
add_image "firmware_${machine}_uboot_qspiboot.img" "${qspi_images[@]}"
add_image "boot_${machine}_lts_6.18.tgz" "${boot_images[@]}"
add_image "kernel-fsl-${platform}-sdk.itb" "${kernel_images[@]}"
add_image "pico-sdk-ls1046a-${machine}.rootfs.tar.gz" "${rootfs_images[@]}"
shopt -u nullglob

printf 'Creating remote directory: %s:%s\n' "$remote_host" "$remote_dir"
ssh "$remote_host" "mkdir -p \"\$HOME/${remote_dir}\""

printf 'Uploading %d image(s) to %s:%s\n' "${#sources[@]}" "$remote_host" "$remote_dir"
for index in "${!sources[@]}"; do
    rsync -av --progress -e ssh -- "${sources[$index]}" \
        "${remote_host}:${remote_dir}/${destinations[$index]}"
done
