#!/bin/bash
#############################
# TShark PCAP Search Script #
#############################
# This script automates the process of searching for specific IP addresses and domain names (Indicators of Compromise, or IoCs) within a given PCAP file using `tshark`, the command-line version of Wireshark. It is designed to streamline the analysis of network traffic by eliminating the need for repetitive manual searches in the Wireshark GUI.

### Features:
# - **IP Address Search**: Iterates through a list of IP addresses and checks if they appear in the specified PCAP file.
# - **Domain Name Search**: Iterates through a list of domain names and checks if they appear in DNS queries within the PCAP file.
# - **Customizable IoCs**: Users can easily add or modify the list of IP addresses and domain names to search for.
# - **Simple Output**: For each IP or domain, the script outputs whether it was found or not.
# - **Tshark Integration**: Leverages `tshark` for efficient packet analysis.

### How It Works:
# 1. The script defines two arrays: one for IP addresses (`ips`) and one for domain names (`domains`).
# 2. It uses a `for` loop to iterate over each IP address and domain name.
# 3. For each IP, it runs a `tshark` command with a filter (`ip.addr == $ip`) to check if the IP is present in the PCAP file.
# 4. For each domain, it runs a `tshark` command with a filter (`dns.qry.name == $domain`) to check if the domain is present in DNS queries.
# 5. The script outputs whether each IP or domain was found in the PCAP file.

### Usage:
# 1. Add the desired IP addresses and domain names to the `ips` and `domains` arrays in the script.
# 2. Specify the PCAP file path directly in the `tshark` command (or modify the script to use a variable for the file path).
# 3. Add the Execute Permission to the File and Run the script in a terminal:
#    chmod +x tshark_search.sh
#   ./tshark_search.sh
# 4. View the results in the terminal, which will indicate whether each IP or domain was found.

### Example Output:
# Searching for: 5.42.64.45
# 5.42.64.45 Found
# Searching for: 5.42.64.83
# 5.42.64.83 Not Found
# Searching for: aptonic.xyz
# aptonic.xyz Found
# Searching for: arcbrowser.pro
# arcbrowser.pro Not Found

### Requirements:
# - `tshark` must be installed on the system.
# - The PCAP file to be analyzed must be accessible.
# This script is particularly useful for cybersecurity analysts and network engineers who need to quickly identify IoCs in network traffic captures.

ips=(
  # Include IoC IP Addresses Here
)
domains=(
  # Include IoC Domain Names Here
)
pcap_file="" # Include the Name / Path to Your PCAP File Here

for ip in "${ips[@]}"; do
    echo "Searching for: $ip"
    if tshark -r "$pcap_file" -Y "ip.addr == $ip" | grep -q .; then
        echo "$ip Found"
    else
        echo "$ip Not Found"
    fi
done

for domain in "${domains[@]}"; do
    echo "Searching for: $domain"
    if tshark -r "$pcap_file" -Y "dns.qry.name == $domain" | grep -q .; then
        echo "$domain Found"
    else
        echo "$domain Not Found"
    fi
done
