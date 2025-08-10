# DragonHunter
DragonHunter: The Ultimate Bug Bounty Scanner A powerful, all-in-one Bash script for bug bounty hunters. DragonHunter automates common reconnaissance tasks, including port scanning, subdomain enumeration, directory brute-forcing, and basic vulnerability checks for SQL injection and XSS
💀💀💀💀💀💀💀💀💀💀💀💀💀💀
📜 How It Works
DragonHunter automates a sequence of reconnaissance steps:

Port Scan: Scans ports 80 and 443 with Nmap.

HTTP Enumeration: Gathers more detailed information about web services using Nmap's HTTP scripts.

Endpoint Discovery: Searches for common web parameters to identify potential injection points.

Vulnerability Checks: Tests for basic SQLi, XSS, and Host Header Injection payloads on discovered endpoints.

Subdomain Scan: Finds subdomains using Subfinder.

Directory Brute-force: Attempts to find common directories and files on the target using Gobuster.

All results are saved to text files in the same directory, making it easy to review the findings after the scan is complete.

🤝 Contribution
Contributions are welcome! If you have suggestions for new features, bug fixes, or improvements, please feel free to open an issue or submit a pull request.

📝 License
This project is licensed under the MIT License. See the LICENSE file for details.

👨‍💻 Author
ALLU444 - Initial work

🎉 Acknowledgments
Thanks to the developers of Nmap, cURL, Gobuster, Subfinder, Figlet, and Lolcat for their amazing tools.

Inspired by the bug bounty community.
