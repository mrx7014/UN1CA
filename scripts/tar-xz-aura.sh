#!/bin/bash
#
# Copyright (C) 2025 @blueskychan-dev
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

set -eu

echo "tar xz full compression 1000000% aura - @mazurikian"

# Compress .zip to .tar.xz, zip path at $OUT_DIR/rom_path.txt, open txt and get path
# Output is build-a23xq.tar.xz
ROM_PATH=$(cat "$OUT_DIR/rom_path.txt")

# Ensure ROM_PATH is a .zip file
if [[ "$ROM_PATH" == *.zip ]]; then
    tar -cJf "$OUT_DIR/build-a23xq.tar.xz" -C "$(dirname "$ROM_PATH")" "$(basename "$ROM_PATH")"
else
    echo "Error: The path in rom_path.txt is not a .zip file."
    exit 1
fi

exit 0