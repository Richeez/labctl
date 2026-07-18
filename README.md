# LABCTL

Professional Cybersecurity Lab Controller for Kali Linux.

---

## Features

- Network Mode Switching
- NAT
- Host-only
- Contain Mode
- Bridged Mode
- Automatic Verification
- Network Diagnostics
- VM Discovery
- Inventory
- Reporting
- VirtualBox Integration
<!-- - Wazuh Integration -->
<!-- - Plugin Support -->

---

## Installation

```bash
git clone https://github.com/<user>/labctl.git

cd labctl

sudo ./install.sh
```

---

## Usage

```bash
sudo labctl update

sudo labctl contain

labctl status

labctl doctor
```

---

## Project Structure

```
bin/
lib/
plugins/
tests/
docs/
config/
```

---

## Requirements

- Kali Linux
- NetworkManager
- jq
- bash
- iproute2
- nmap
- bats
- shellcheck

---

## License

MIT

---

🚧 Under development (v1.0.0)