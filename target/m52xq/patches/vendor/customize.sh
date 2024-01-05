REMOVE_FROM_WORK_DIR()
{
    local FILE_PATH="$1"

    if [ -e "$FILE_PATH" ]; then
        local FILE
        local PARTITION
        FILE="$(echo -n "$FILE_PATH" | sed "s.$WORK_DIR/..")"
        PARTITION="$(echo -n "$FILE" | cut -d "/" -f 1)"

        echo "Debloating /$FILE"
        rm -rf "$FILE_PATH"

        if [[ "$PARTITION" == "system" ]] && [[ "$FILE" == *".camera.samsung.so" ]]; then
            sed -i "/$(basename "$FILE")/d" "$WORK_DIR/system/system/etc/public.libraries-camera.samsung.txt"
        fi
        if [[ "$PARTITION" == "system" ]] && [[ "$FILE" == *".arcsoft.so" ]]; then
            sed -i "/$(basename "$FILE")/d" "$WORK_DIR/system/system/etc/public.libraries-arcsoft.txt"
        fi

        FILE="$(echo -n "$FILE" | sed 's/\//\\\//g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/fs_config-$PARTITION"

        FILE="$(echo -n "$FILE" | sed 's/\./\\./g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/file_context-$PARTITION"
    fi
}

REMOVE_FROM_WORK_DIR "$WORK_DIR/vendor/etc/midas/SRIBMidas_aiBLURDETECT_Stage1_V140_FP32.tflite"
REMOVE_FROM_WORK_DIR "$WORK_DIR/vendor/etc/midas/SRIBMidas_aiBLURDETECT_Stage2_V130_FP32.tflite"
REMOVE_FROM_WORK_DIR "$WORK_DIR/vendor/etc/midas/SRIBMidas_aiDEBLUR_INT16_V0132_sm7325_snpe1502.dlc"
REMOVE_FROM_WORK_DIR "$WORK_DIR/vendor/etc/midas/SRIBMidas_aiDENOISE_FP16_V900.caffemodel"
REMOVE_FROM_WORK_DIR "$WORK_DIR/vendor/etc/midas/SRIBMidas_aiUNIFIED_FP16_V610.caffemodel"

echo "Fix MIDAS model detection"
sed -i "s/ro.product.device/ro.product.vendor.device/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"

if ! grep -q "wlan/m526b" "$WORK_DIR/configs/file_context-vendor"; then
    {
        echo "/vendor/etc/midas/SRIBMidas_aiCLARITY2\.0_2X_V200_FP32\.caffemodel u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMidas_aiDEBLUR_V140_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMidas_aiUPSCALER_1X_V200_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMidas_aiUPSCALER_2X_V200_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMidas_aiUPSCALER_3X_V200_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMidas_aiUPSCALER_4X_V200_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMQA_aiFiQA_V100_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMQA_aiIQA_V100_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/midas/SRIBMQA_aiNOISEDETECT_V100_FP32\.tflite u:object_r:vendor_configs_file:s0"
        echo "/vendor/etc/init/wifi_firmware\.rc u:object_r:vendor_configs_file:s0"
        echo "/vendor/firmware/wpss\.b00 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.b01 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.b02 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.b03 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.b04 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.b05 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.b06 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.b07 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wpss\.mdt u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b00 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b01 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b02 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b03 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b04 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b05 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b06 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.b07 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev2/wpss\.mdt u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b00 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b01 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b02 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b03 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b04 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b05 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b06 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.b07 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev3/wpss\.mdt u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b00 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b01 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b02 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b03 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b04 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b05 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b06 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.b07 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526b/rev4/wpss\.mdt u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev1 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev1/wpss\.b01 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev1/wpss\.mdt u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev2 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev2/wpss\.b01 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev2/wpss\.mdt u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev3 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev3/wpss\.b01 u:object_r:vendor_firmware_file:s0"
        echo "/vendor/firmware/wlan/m526br/rev3/wpss\.mdt u:object_r:vendor_firmware_file:s0"
    } >> "$WORK_DIR/configs/file_context-vendor"
fi
if ! grep -q "wlan/m526b" "$WORK_DIR/configs/fs_config-vendor"; then
    {
        echo "vendor/etc/midas/SRIBMidas_aiCLARITY2.0_2X_V200_FP32.caffemodel  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMidas_aiDEBLUR_V140_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMidas_aiUPSCALER_1X_V200_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMidas_aiUPSCALER_2X_V200_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMidas_aiUPSCALER_3X_V200_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMidas_aiUPSCALER_4X_V200_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMQA_aiFiQA_V100_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMQA_aiIQA_V100_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/midas/SRIBMQA_aiNOISEDETECT_V100_FP32.tflite  0 0 644 capabilities=0x0"
        echo "vendor/etc/init/wifi_firmware.rc 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b00 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b01 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b02 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b03 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b04 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b05 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b06 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.b07 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wpss.mdt 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b00 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b01 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b02 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b03 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b04 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b05 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b06 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.b07 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev2/wpss.mdt 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b00 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b01 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b02 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b03 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b04 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b05 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b06 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.b07 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev3/wpss.mdt 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b00 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b01 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b02 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b03 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b04 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b05 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b06 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.b07 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526b/rev4/wpss.mdt 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev1 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev1/wpss.b01 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev1/wpss.mdt 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev2 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev2/wpss.b01 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev2/wpss.mdt 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev3 0 2000 755 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev3/wpss.b01 0 0 644 capabilities=0x0"
        echo "vendor/firmware/wlan/m526br/rev3/wpss.mdt 0 0 644 capabilities=0x0"
    } >> "$WORK_DIR/configs/fs_config-vendor"
fi
if ! grep -q "vendor_firmware_file (file (mounton" "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"; then
    echo "(allow init_30_0 vendor_firmware_file (file (mounton)))" >> "$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
fi
