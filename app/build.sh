#!/bin/bash

set -euo pipefail

this_dir="$(dirname "$BASH_SOURCE")"
project_root_dir="$this_dir/.."

zip -q -r9 "$project_root_dir/__function.zip" "$this_dir"/{package.json,index.js}
