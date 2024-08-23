#!/bin/bash

# Step 1: Prompt the user for input
read -p "Enter the name to search for (e.g., Tesla): " input

# Step 2: Normalize the input by converting it to lowercase and replacing spaces with underscores
normalized_input=$(echo "$input" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Step 3: Search for the URL in the index.json that matches the normalized input
index_file="$PWD/domain_chaos_list/index.json"
if [ ! -f "$index_file" ]; then
    echo "Index file not found. Please run domain_chaos_list.sh first."
    exit 1
fi

url=$(jq -r --arg input "$normalized_input" '
    .[] | select(
        ( .name | ascii_downcase | gsub(" ";"_") | contains($input) ) or
        ( .program_url | ascii_downcase | gsub(" ";"_") | contains($input) ) or
        ( .URL | ascii_downcase | gsub(" ";"_") | contains($input) )
    ) | .URL' "$index_file")

# Step 4: If a matching URL is found, proceed with the download and extraction process
if [ -n "$url" ]; then
    echo "URL found: $url"
    filename=$(basename "$url")
    dirname="${filename%.zip}"
    
    # Create a directory for the program in the current working directory
    target_dir="$PWD/$dirname"
    mkdir -p "$target_dir"
    
    # Download the zip file
    wget "$url" -O "$filename"
    
    # Extract the contents of the zip file into the correct directory
    unzip -d "$target_dir" "$filename"
    
    # Remove the downloaded zip file after extraction
    rm "$filename"
    
    echo "Process completed successfully."

    # Step 5: Initialize a flag to track if any new subdomains are found
    new_subdomains_found=false
    
    # Step 6: Iterate through each file in the target directory
    for downloaded_file in "$target_dir"/*.txt; do
        downloaded_filename=$(basename "$downloaded_file")
        
        echo "Checking downloaded file: $downloaded_filename"
        
        # Check if a file with the same name exists in the domain_chaos_list directory
        if [ -f "$PWD/domain_chaos_list/$downloaded_filename" ]; then
            echo "File match found: $downloaded_filename"
            
            # Perform the 'anew' operation and save new subdomains to the output file
            if [ -s "$downloaded_file" ] && [ -s "$PWD/domain_chaos_list/$downloaded_filename" ]; then
                echo "Processing $downloaded_file with $PWD/domain_chaos_list/$downloaded_filename"
                
                # Create the directory to save new subdomains
                new_subd_dir="${target_dir}_new_subdomain"
                mkdir -p "$new_subd_dir"
                
                output_file="$new_subd_dir/NewSubdomain.$downloaded_filename"
                cat "$downloaded_file" | anew "$PWD/domain_chaos_list/$downloaded_filename" > "$output_file"
                
                if [ -s "$output_file" ]; then
                    echo -e "\e[32mNew subdomains saved successfully in $output_file\e[0m"
                    new_subdomains_found=true
                else
                    echo -e "\e[31mNo new subdomains found in $output_file\e[0m"
                fi
            else
                echo "One of the files is empty or missing: $downloaded_file or $PWD/domain_chaos_list/$downloaded_filename"
            fi
        else
            echo "No match found for $downloaded_filename in $PWD/domain_chaos_list/"
        fi
    done

    # Step 7: If no new subdomains were found, remove the directory if it was created
    if [ "$new_subdomains_found" = false ]; then
        echo -e "\e[31mNo new subdomains found. Removing directory $new_subd_dir\e[0m"
        rm -rf "$new_subd_dir"
    fi
else
    echo "No URL found for the input: $input"
fi
