SKIPUNZIP=1

# Define the target file system type (ext4 or erofs)
TARGET_FS_TYPE=${1:-ext4}

# Define the directories to search for fstab files
DIRECTORIES=("system" "vendor")

# Loop through each directory
for DIR in "${DIRECTORIES[@]}"; do
    # Find all fstab files in the directory
    find "$WORK_DIR/$DIR" -type f -name "fstab*" | while read -r FSTAB_FILE; do
        # Check if the file contains 'f2fs'
        if grep -q 'f2fs' "$FSTAB_FILE"; then
            # Replace only occurrences of f2fs as the file system type (tab-separated fields)
            sed -i "s|\tf2fs\t|\t${TARGET_FS_TYPE}\t|g" "$FSTAB_FILE"
            cat "$FSTAB_FILE"
            echo "Updated $FSTAB_FILE to use $TARGET_FS_TYPE instead of f2fs"
        else
            echo "No changes made to $FSTAB_FILE (no 'f2fs' found)"
        fi
    done
done
