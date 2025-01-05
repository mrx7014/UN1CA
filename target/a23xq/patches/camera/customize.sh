SKIPUNZIP=1

# [
ADD_TO_WORK_DIR()
{
    local PARTITION="$1"
    local FILE_PATH="$2"
    local TMP

    case "$PARTITION" in
        "system_ext")
            if $TARGET_HAS_SYSTEM_EXT; then
                FILE_PATH="system_ext/$FILE_PATH"
            else
                PARTITION="system"
                FILE_PATH="system/system/system_ext/$FILE_PATH"
            fi
        ;;
        *)
            FILE_PATH="$PARTITION/$FILE_PATH"
            ;;
    esac

    mkdir -p "$WORK_DIR/$(dirname "$FILE_PATH")"
    cp -a --preserve=all "$FW_DIR/${MODEL}_${REGION}/$FILE_PATH" "$WORK_DIR/$FILE_PATH"

    TMP="$FILE_PATH"
    [[ "$PARTITION" == "system" ]] && TMP="$(echo "$TMP" | sed 's.^system/system/.system/.')"
    while [[ "$TMP" != "." ]]
    do
        if ! grep -q "$TMP " "$WORK_DIR/configs/fs_config-$PARTITION"; then
            if [[ "$TMP" == "$FILE_PATH" ]]; then
                echo "$TMP $3 $4 $5 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-$PARTITION"
            elif [[ "$PARTITION" == "vendor" ]]; then
                echo "$TMP 0 2000 755 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-$PARTITION"
            else
                echo "$TMP 0 0 755 capabilities=0x0" >> "$WORK_DIR/configs/fs_config-$PARTITION"
            fi
        else
            break
        fi

        TMP="$(dirname "$TMP")"
    done

    TMP="$(echo "$FILE_PATH" | sed 's/\./\\\./g')"
    [[ "$PARTITION" == "system" ]] && TMP="$(echo "$TMP" | sed 's.^system/system/.system/.')"
    while [[ "$TMP" != "." ]]
    do
        if ! grep -q "/$TMP " "$WORK_DIR/configs/file_context-$PARTITION"; then
            echo "/$TMP $6" >> "$WORK_DIR/configs/file_context-$PARTITION"
        else
            break
        fi

        TMP="$(dirname "$TMP")"
    done
}

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
        if [[ "$PARTITION" == "system" ]] && [[ "$FILE" == *".media.samsung.so" ]]; then
            sed -i "/$(basename "$FILE")/d" "$WORK_DIR/system/system/etc/public.libraries-media.samsung.txt"
        fi

        [[ "$PARTITION" == "system" ]] && FILE="$(echo "$FILE" | sed 's.^system/system/.system/.')"
        FILE="$(echo -n "$FILE" | sed 's/\//\\\//g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/fs_config-$PARTITION"

        FILE="$(echo -n "$FILE" | sed 's/\./\\\\\./g')"
        sed -i "/$FILE /d" "$WORK_DIR/configs/file_context-$PARTITION"
    fi
}
# ]

MODEL=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
REGION=$(echo -n "$TARGET_FIRMWARE" | cut -d "/" -f 2)

# Fix camera lock for devices with a rear SLSI sensor
echo "Patching camera HAL"
HAL_LIBS="
$WORK_DIR/vendor/lib/hw/camera.qcom.so
$WORK_DIR/vendor/lib/hw/com.qti.chi.override.so
$WORK_DIR/vendor/lib64/hw/camera.qcom.so
$WORK_DIR/vendor/lib64/hw/com.qti.chi.override.so
"
for f in $HAL_LIBS; do
    sed -i "s/ro.boot.flash.locked/ro.camera.notify_nfc/g" "$f"
done

# Fix system camera libs
BLOBS_LIST="
system/lib/android.hardware.camera.common@1.0.so
system/lib/android.hardware.camera.device@3.2.so
system/lib/libcamera_client.so
system/lib/libFace_Landmark_API.camera.samsung.so
system/lib/libOpenCv.camera.samsung.so
system/lib/libcamera2ndk.so
system/lib/libcamera_metadata.so
system/lib/libcore2nativeutil.camera.samsung.so
system/lib/libexifa.camera.samsung.so
system/lib/libseccameracore2.so
system/lib/libsecjpeginterface.camera.samsung.so
system/lib/libjpega.camera.samsung.so
system/lib64/android.frameworks.cameraservice.common-V1-ndk.so
system/lib64/android.frameworks.cameraservice.common@2.0.so
system/lib64/android.frameworks.cameraservice.device-V1-ndk.so
system/lib64/android.frameworks.cameraservice.device@2.0.so
system/lib64/android.frameworks.cameraservice.device@2.1.so
system/lib64/android.frameworks.cameraservice.service-V1-ndk.so
system/lib64/android.frameworks.cameraservice.service@2.0.so
system/lib64/android.frameworks.cameraservice.service@2.1.so
system/lib64/android.frameworks.cameraservice.service@2.2.so
system/lib64/android.hardware.camera.common-V1-ndk.so
system/lib64/android.hardware.camera.common@1.0.so
system/lib64/android.hardware.camera.device-V2-ndk.so
system/lib64/android.hardware.camera.device@1.0.so
system/lib64/android.hardware.camera.device@3.2.so
system/lib64/android.hardware.camera.device@3.3.so
system/lib64/android.hardware.camera.device@3.4.so
system/lib64/android.hardware.camera.device@3.5.so
system/lib64/android.hardware.camera.device@3.6.so
system/lib64/android.hardware.camera.device@3.7.so
system/lib64/android.hardware.camera.metadata-V2-ndk.so
system/lib64/android.hardware.camera.metadata@3.2.so
system/lib64/android.hardware.camera.metadata@3.3.so
system/lib64/android.hardware.camera.metadata@3.4.so
system/lib64/android.hardware.camera.metadata@3.5.so
system/lib64/android.hardware.camera.metadata@3.6.so
system/lib64/android.hardware.camera.provider-V2-ndk.so
system/lib64/android.hardware.camera.provider@2.4.so
system/lib64/android.hardware.camera.provider@2.5.so
system/lib64/android.hardware.camera.provider@2.6.so
system/lib64/android.hardware.camera.provider@2.7.so
system/lib64/camera-service-worker-aidl-V4-cpp.so
system/lib64/libDLInterface_aidl.camera.samsung.so
system/lib64/libEventDetector.camera.samsung.so
system/lib64/libBeauty_v4.camera.samsung.so
system/lib64/libFacePreProcessing_jni.camera.samsung.so
system/lib64/libFace_Landmark_API.camera.samsung.so
system/lib64/libFace_Landmark_Engine.camera.samsung.so
system/lib64/libFood.camera.samsung.so
system/lib64/libFoodDetector.camera.samsung.so
system/lib64/libHprFace_GAE_api.camera.samsung.so
system/lib64/libImageScreener.camera.samsung.so
system/lib64/libMattingCore.camera.samsung.so
system/lib64/libOpenCv.camera.samsung.so
system/lib64/libHprFace_GAE_jni.camera.samsung.so
system/lib64/libHpr_RecGAE_cvFeature_v1.0.camera.samsung.so
system/lib64/libImageCropper.camera.samsung.so
system/lib64/libImageTagger.camera.samsung.so
system/lib64/libMyFilter.camera.samsung.so
system/lib64/libMyFilterPlugin.camera.samsung.so
system/lib64/libPortraitSolution.camera.samsung.so
system/lib64/libSceneDetector_v1.camera.samsung.so
system/lib64/libQREngine.camera.samsung.so
system/lib64/libcamera_metadata.so
system/lib64/libcameraservice.so
system/lib64/libcolor_engine.camera.samsung.so
system/lib64/libcore2nativeutil.camera.samsung.so
system/lib64/libFacialBasedSelfieCorrection.camera.samsung.so
system/lib64/libHpr_RecFace_dl_v1.0.camera.samsung.so
system/lib64/libInteractiveSegmentation.camera.samsung.so
system/lib64/libStride.camera.samsung.so
system/lib64/libStrideTensorflowLite.camera.samsung.so
system/lib64/libUltraWideDistortionCorrection.camera.samsung.so
system/lib64/libcamera_client.so
system/lib64/libSegmentationCore.camera.samsung.so
system/lib64/libcamera2ndk.so
system/lib64/libexifa.camera.samsung.so
system/lib64/libhumantracking_util.camera.samsung.so
system/lib64/libjpega.camera.samsung.so
system/lib64/libsmart_cropping.camera.samsung.so
system/lib64/libsaiv_HprFace_cmh_support_jni.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.myfilter.camera.samsung.so
system/lib64/libsecimaging.camera.samsung.so
system/lib64/libsrib_CNNInterface.camera.samsung.so
system/lib64/libtensorflowLite.myfilter.camera.samsung.so
system/lib64/libtensorflowLite.camera.samsung.so
system/lib64/vendor.samsung.hardware.camera.provider@4.0.so
system/lib64/libseccameracore2.so
system/lib64/libsecimaging_pdk.camera.samsung.so
system/lib64/libsecjpeginterface.camera.samsung.so
system/lib64/libsrib_humanaware_engine.camera.samsung.so
system/lib64/vendor.samsung.hardware.camera.device-V1-ndk.so
system/lib64/vendor.samsung.hardware.camera.provider-V1-ndk.so
system/lib64/vendor.samsung.hardware.camera.device@5.0.so
system/lib64/libsurfaceutil.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.camera.samsung.so
system/lib64/libFacialAttributeDetection.arcsoft.so
system/lib64/libbeautyshot.arcsoft.so
system/lib64/libface_landmark.arcsoft.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/libPortraitDistortionCorrectionCali.arcsoft.so
"
for blob in $BLOBS_LIST
do
    REMOVE_FROM_WORK_DIR "$WORK_DIR/system/$blob"
done

echo "Add stock camera libs"
BLOBS_LIST="
system/etc/public.libraries-camera.samsung.txt
system/lib/libSlowShutter_jni.media.samsung.so
system/lib64/libFace_Landmark_Engine.camera.samsung.so
system/lib64/libHpr_RecFace_dl_v1.0.camera.samsung.so
system/lib64/libImageCropper.camera.samsung.so
system/lib64/libImageTagger.camera.samsung.so
system/lib64/libMyFilter.camera.samsung.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/libSlowShutter_jni.media.samsung.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libsaiv_HprFace_cmh_support_jni.camera.samsung.so
system/lib64/libsamsung_videoengine_9_0.so
system/lib64/libtensorflowLite.myfilter.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.myfilter.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
{
    echo "libLttEngine.camera.samsung.so"
} >> "$WORK_DIR/system/system/etc/public.libraries-camera.samsung.txt"

