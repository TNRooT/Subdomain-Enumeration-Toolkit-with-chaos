#!/bin/bash

# Step 1: Create the domain_chaos_list directory in the current working directory (PWD)
target_dir="$PWD/domain_chaos_list"
mkdir -p "$target_dir"

# Step 2: Download the index.json file containing all available programs
index_url="https://chaos-data.projectdiscovery.io/index.json"
echo "Downloading index file from $index_url..."
wget "$index_url" -O "$target_dir/index.json"

# Step 3: Parse the index.json file to get all URLs for the available programs
echo "Extracting program URLs from index file..."
urls=$(jq -r '.[].URL' "$target_dir/index.json")

# Step 4: Download and unzip each program into the domain_chaos_list directory
for url in $urls; do
    echo "Processing $url..."
    filename=$(basename "$url")
    program_name="${filename%.zip}"
    
    # Download the zip file
    wget "$url" -O "$target_dir/$filename"
    
    # Create a directory for the program
    mkdir -p "$target_dir/$program_name"
    
    # Unzip the file into the program's directory
    unzip -d "$target_dir/$program_name" "$target_dir/$filename"
    
    # Remove the downloaded zip file
    rm "$target_dir/$filename"
done

# Step 5: List the contents of the domain_chaos_list directory
echo "All programs have been downloaded and unzipped into $target_dir:"
ls -R "$target_dir"
