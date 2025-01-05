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

# What this script does: Uploads the ROM to transfer.sh mirror/3-rd party server (for example: http://jp.asuka.cyou:18080/)
set -eu

# find for .zip and .tar-md5 in the $OUT_DIR 
find "$OUT_DIR" -type f -name "-sign.zip" -exec curl --upload-file {} http://jp.asuka.cyou:18080/{} \; || true
find "$OUT_DIR" -type f -name ".tar.md5" -exec curl --upload-file {} http://jp.asuka.cyou:18080/{} \; || true

exit 0