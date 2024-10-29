#!/usr/bin/env bash

# This script is used to export the secured configuration trees from a standard VM and
# then to import to a CyberPatriot VM.

### Parameters ###

rootDir="$1"
outPath="$2"

### Sourcing ###

source "$CYBPAT_ROOT/lib/colors.sh"
source "$CYBPAT_ROOT/lib/root.sh"

### Functions ###

function usage {
    eecho "Usage: export-tree <rootDir> <outPath>"
    eecho "  rootDir: The root directory of the configuration tree."
    eecho "  outPath: The path to the output archive."
    exit 1
}

### Entrypoint ###

decho "$rootDir"

# The root directory must be specified
if [ ! -d "$rootDir" ]; then
    eecho "rootDir does not exist."
    usage
fi

# Check if the path exists
if [ -e "$outPath" ] && [ ! -f "$outPath" ]; then
    eecho "$outPath exists but is not a file."
    usage
fi

# If path does not end with .tar.gz, append it
if [ "${outPath: -7}" != ".tar.gz" ]; then
    outPath="$outPath.tar.gz"
fi

# W e require a pretty high level of privilege to export configurations
elevate

# Generate a list of files to export
iecho "Generating file list..."

# Baiscally everything except symlinks
fileList=$(find "${rootDir}" -type f -not -type l)

# Export the files
iecho "Exporting ${#fileList[@]} files to ${outPath}..."

# Maintain permissions, show progress, and compress
tar cf - $rootDir -P 2> /dev/null | \
    pv -s $(du -sb "$rootDir" | awk '{print $1}') | \
    gzip > "$outPath"

# Check for errors and file existence
if [ $? -ne 0 ]; then
    eecho "An error occurred while exporting the files."
    exit 1
fi

# Check if the file exists
if [ ! -e "$outPath" ]; then
    eecho "The output file does not exist."
    exit 1
fi

# Done
iecho "Export complete."