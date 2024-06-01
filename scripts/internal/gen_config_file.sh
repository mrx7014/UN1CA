#!/usr/bin/env bash
#
# Copyright (C) 2023 BlackMesa123
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# shellcheck disable=SC1090,SC1091

set -Ee

# [
trap 'rm -f $OUT_DIR/config.sh' ERR

GET_OFFICIAL_STATUS()
{
    local USES_UNICA_CERT=false

    if [ -f "$SRC_DIR/unica/security/unica_platform.pk8" ]; then
        openssl ec -pubout -in "$SRC_DIR/unica/security/unica_platform.pk8" -out "$OUT_DIR/unica_platform.pub" &> /dev/null \
            || touch "$OUT_DIR/unica_platform.pub"
        if cmp -s "$SRC_DIR/unica/security/unica_platform.pub" "$OUT_DIR/unica_platform.pub"; then
            USES_UNICA_CERT=true
        fi
        rm -f "$OUT_DIR/unica_platform.pub"
    fi

    echo "$USES_UNICA_CERT"
}

GEN_CONFIG_FILE()
{
    if [ -f "$OUT_DIR/config.sh" ]; then
        echo "config.sh already exists. Regenerating..."
        rm -f "$OUT_DIR/config.sh"
    fi

    {
        echo "# Automatically generated by unica/scripts/internal/gen_config_file.sh"
        echo "ROM_IS_OFFICIAL=\"$(GET_OFFICIAL_STATUS)\""
        echo "ROM_VERSION=\"${ROM_VERSION:?}\""
        echo "ROM_CODENAME=\"${ROM_CODENAME:?}\""
        echo "SOURCE_FIRMWARE=\"${SOURCE_FIRMWARE:?}\""
        if [ "${#SOURCE_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
            echo "SOURCE_EXTRA_FIRMWARES=\"$( IFS=:; printf '%s' "${SOURCE_EXTRA_FIRMWARES[*]}" )\""
        else
            echo "SOURCE_EXTRA_FIRMWARES=\"\""
        fi
        echo "SOURCE_API_LEVEL=\"${SOURCE_API_LEVEL:?}\""
        echo "SOURCE_VNDK_VERSION=\"${SOURCE_VNDK_VERSION:?}\""
        echo "TARGET_NAME=\"${TARGET_NAME:?}\""
        echo "TARGET_CODENAME=\"${TARGET_CODENAME:?}\""
        if [ "${#TARGET_ASSERT_MODEL[@]}" -ge 1 ]; then
            echo "TARGET_ASSERT_MODEL=\"$( IFS=:; printf '%s' "${TARGET_ASSERT_MODEL[*]}" )\""
        else
            echo "TARGET_ASSERT_MODEL=\"\""
        fi
        echo "TARGET_FIRMWARE=\"${TARGET_FIRMWARE:?}\""
        if [ "${#TARGET_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
            echo "TARGET_EXTRA_FIRMWARES=\"$( IFS=:; printf '%s' "${TARGET_EXTRA_FIRMWARES[*]}" )\""
        else
            echo "TARGET_EXTRA_FIRMWARES=\"\""
        fi
        echo "TARGET_API_LEVEL=\"${TARGET_API_LEVEL:?}\""
        echo "TARGET_VNDK_VERSION=\"${TARGET_VNDK_VERSION:?}\""
        echo "TARGET_SINGLE_SYSTEM_IMAGE=\"${TARGET_SINGLE_SYSTEM_IMAGE:?}\""
        echo "TARGET_OS_FILE_SYSTEM=\"${TARGET_OS_FILE_SYSTEM:?}\""
        echo "TARGET_INSTALL_METHOD=\"${TARGET_INSTALL_METHOD:=zip}\""
        echo "TARGET_BOOT_DEVICE_PATH=\"${TARGET_BOOT_DEVICE_PATH:=/dev/block/bootdevice/by-name}\""
        echo "TARGET_INCLUDE_PATCHED_VBMETA=\"${TARGET_INCLUDE_PATCHED_VBMETA:=false}\""
        echo "TARGET_KEEP_ORIGINAL_SIGN=\"${TARGET_KEEP_ORIGINAL_SIGN:=false}\""
        echo "TARGET_SUPER_PARTITION_SIZE=\"${TARGET_SUPER_PARTITION_SIZE:?}\""
        echo "TARGET_SUPER_GROUP_SIZE=\"${TARGET_SUPER_GROUP_SIZE:?}\""
        echo "SOURCE_HAS_SYSTEM_EXT=\"${SOURCE_HAS_SYSTEM_EXT:?}\""
        echo "TARGET_HAS_SYSTEM_EXT=\"${TARGET_HAS_SYSTEM_EXT:?}\""
        echo "SOURCE_FP_SENSOR_CONFIG=\"${SOURCE_FP_SENSOR_CONFIG:?}\""
        echo "TARGET_FP_SENSOR_CONFIG=\"${TARGET_FP_SENSOR_CONFIG:?}\""
        echo "SOURCE_HAS_HW_MDNIE=\"${SOURCE_HAS_HW_MDNIE:?}\""
        echo "TARGET_HAS_HW_MDNIE=\"${TARGET_HAS_HW_MDNIE:?}\""
        echo "SOURCE_HAS_MASS_CAMERA_APP=\"${SOURCE_HAS_MASS_CAMERA_APP:?}\""
        echo "TARGET_HAS_MASS_CAMERA_APP=\"${TARGET_HAS_MASS_CAMERA_APP:?}\""
        echo "SOURCE_IS_ESIM_SUPPORTED=\"${SOURCE_IS_ESIM_SUPPORTED:?}\""
        echo "TARGET_IS_ESIM_SUPPORTED=\"${TARGET_IS_ESIM_SUPPORTED:?}\""
        echo "SOURCE_MULTI_MIC_MANAGER_VERSION=\"${SOURCE_MULTI_MIC_MANAGER_VERSION:?}\""
        echo "TARGET_MULTI_MIC_MANAGER_VERSION=\"${TARGET_MULTI_MIC_MANAGER_VERSION:?}\""
        echo "SOURCE_SSRM_CONFIG_NAME=\"${SOURCE_SSRM_CONFIG_NAME:?}\""
        echo "TARGET_SSRM_CONFIG_NAME=\"${TARGET_SSRM_CONFIG_NAME:?}\""
    } > "$OUT_DIR/config.sh"
}

source "$SRC_DIR/target/$1/config.sh"
source "$SRC_DIR/unica/config.sh"
# ]

GEN_CONFIG_FILE
[ -f "$OUT_DIR/config.sh" ] || exit 1

exit 0
