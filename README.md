![/Banner.png](https://github.com/TNRooT/Subdomain-Enumeration-Toolkit-with-chaos/blob/master/Banner.png))

***
This repository contains scripts for downloading and processing subdomain data from the chaos-data project. The toolkit includes scripts for setting up a comprehensive subdomain list and for searching and comparing new subdomains against this list.
***
## Features

- **Program Setup:** Download and unzip all available programs from the chaos-data project.
- **Search for Programs:** Search for specific programs by name (e.g., Tesla).
- **Download Data:** Download relevant subdomain data based on your search query.
- **Subdomain Comparison:** Compare newly downloaded subdomains with your existing subdomain data to identify new findings.
- **Custom Directory Structure:** Organize downloaded and processed data into directories for easy management.
***
## Prerequisites

Ensure the following tools are installed on your system:

- **jq:** For parsing JSON files.
- **anew:** To identify and save new subdomains.
- **wget:** For downloading files.
- **unzip:** For extracting downloaded zip files.

## Installation

Install the required tools with the following commands:

```bash
sudo apt-get install jq wget unzip
```
***
## Usage

### Setting Up the domain_chaos_list Directory
The first step is to set up the domain_chaos_list directory, where all subdomain data from the chaos-data project will be stored.
[Chaos Programs](https://chaos.projectdiscovery.io/#/)
#### Steps : 
- Run the domain_chaos_list.sh script:
  ```bash ./domain_chaos_list.sh ```
  
### Running the Subdomain Enumeration Script
Once your domain_chaos_list is set up, you can use the subdomain-enumeration.sh script to search for new subdomains and compare them with your existing records.
#### Steps : 
- Run the domain_chaos_list.sh script:
  ```bash subdomain-enumeration.sh ```
- Follow the prompts:
  Enter the name of the program you're searching for (e.g., Tesla).
  > The script will download the relevant data, extract it, and compare it with your existing subdomains in the domain_chaos_list directory.
- Output:
  > If new subdomains are found, they will be saved in a new directory within your current working directory "PWD".
  >
  > If no new subdomains are found, the script will clean up unnecessary files and notify you.

## Disclaimer
>This script is intended for educational and ethical hacking purposes only. Ensure that you have proper authorization before running this script against any target.
