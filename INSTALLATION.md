# 🚀 Installation Guide

## Quick Start (One Command)

```bash
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh && chmod +x ultimate-gpu-installer.sh && ./ultimate-gpu-installer.sh
```

## Manual Installation Steps

### Step 1: Download the Script
```bash
# Method 1: Using wget
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh

# Method 2: Using curl
curl -O https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh

# Method 3: Clone the entire repository
git clone https://github.com/bokiko/Multi-GPU-Inference.net.git
cd Multi-GPU-Inference.net
```

### Step 2: Make Executable
```bash
chmod +x ultimate-gpu-installer.sh
```

### Step 3: Run the Installer
```bash
./ultimate-gpu-installer.sh
```

## Prerequisites Installation

### Ubuntu 20.04/22.04 LTS Setup

#### 1. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

#### 2. Install NVIDIA Drivers
```bash
# Install driver detection tools
sudo apt install ubuntu-drivers-common

# Auto-install recommended drivers
sudo ubuntu-drivers autoinstall

# Reboot to activate drivers
sudo reboot

# Verify installation
nvidia-smi
```

#### 3. Install Docker
```bash
# Download and install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install NVIDIA Container Runtime
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

# Log out and back in to refresh group membership
exit
# SSH back into your machine
```

#### 4. Verify Docker + NVIDIA Integration
```bash
# Test NVIDIA Docker support
docker run --rm --gpus all nvidia/cuda:11.0-base-ubuntu20.04 nvidia-smi

# Should display your GPU information
```

## Installation Scenarios

### Scenario 1: Fresh System Setup
```bash
# Complete system setup (run as individual commands)
sudo apt update && sudo apt upgrade -y
sudo ubuntu-drivers autoinstall
sudo reboot

# After reboot:
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Install NVIDIA Docker support
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

# Log out and back in, then:
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh
chmod +x ultimate-gpu-installer.sh
./ultimate-gpu-installer.sh
```

### Scenario 2: Existing Mining Rig
```bash
# If you already have NVIDIA drivers and Docker:
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh
chmod +x ultimate-gpu-installer.sh
./ultimate-gpu-installer.sh
```

### Scenario 3: Upgrade from Old Setup
```bash
# Stop existing containers first
docker stop $(docker ps -q)
docker rm $(docker ps -aq)

# Download new installer
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh
chmod +x ultimate-gpu-installer.sh
./ultimate-gpu-installer.sh
```

## Troubleshooting Installation

### Common Issues

#### NVIDIA Driver Problems
```bash
# Check if drivers are installed
nvidia-smi

# If not working, reinstall:
sudo apt purge nvidia-* libnvidia-*
sudo apt autoremove
sudo ubuntu-drivers autoinstall
sudo reboot
```

#### Docker Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Apply group changes
newgrp docker

# Or logout and login again
```

#### NVIDIA Docker Integration
```bash
# Restart Docker service
sudo systemctl restart docker

# Test integration
docker run --rm --gpus all nvidia/cuda:11.0-base-ubuntu20.04 nvidia-smi
```

#### jq Package Missing
```bash
# Install jq for JSON parsing
sudo apt update && sudo apt install -y jq
```

### System Requirements Check

#### Minimum Requirements
- **OS**: Ubuntu 20.04+ (other Linux distros may work)
- **GPU**: NVIDIA GTX 1060 6GB or better
- **RAM**: 8GB minimum (16GB+ recommended)
- **Storage**: 50GB free space
- **Network**: Stable internet connection

#### Recommended Requirements
- **OS**: Ubuntu 22.04 LTS
- **GPU**: RTX 3060 Ti or better
- **RAM**: 16GB+ (2GB per GPU)
- **Storage**: 500GB+ SSD
- **Network**: Gigabit ethernet
- **PSU**: 80+ Gold rated with 20% headroom

## Advanced Installation Options

### Custom Installation Path
```bash
# Install to specific directory
mkdir ~/mining-setup
cd ~/mining-setup
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh
chmod +x ultimate-gpu-installer.sh
./ultimate-gpu-installer.sh
```

### Headless Installation (No Interactive Prompts)
*Note: This requires pre-existing configuration file*
```bash
# Use existing config (auto-deploy mode)
./ultimate-gpu-installer.sh --auto-start
```

### Installation with Logging
```bash
# Run with comprehensive logging
./ultimate-gpu-installer.sh 2>&1 | tee installation.log
```

## Post-Installation Verification

### Check Installation Success
```bash
# Verify containers are running
docker ps

# Check GPU utilization
nvidia-smi

# Run monitoring script
./monitor-rig.sh

# Check auto-start service
sudo systemctl status inference-mining
```

### Expected Output
After successful installation, you should see:
- All containers running with "Up X minutes" status
- GPUs showing utilization in nvidia-smi
- Auto-start service enabled and active
- Monitor script showing comprehensive status

## Network Configuration

### Firewall Settings
```bash
# Allow Docker traffic (if using UFW)
sudo ufw allow from 172.16.0.0/12
sudo ufw allow from 192.168.0.0/16
```

### Port Requirements
- **Outbound**: HTTPS (443) for Inference.net communication
- **Outbound**: HTTP (80) for updates and downloads
- **Internal**: Docker bridge network communication

## Security Considerations

### File Permissions
```bash
# Verify script permissions
ls -la ultimate-gpu-installer.sh

# Should show: -rwxr-xr-x (executable by owner)
```

### Configuration Security
```bash
# Protect configuration file
chmod 600 ~/.inference-mining-config.json

# Verify systemd service permissions
sudo systemctl show inference-mining | grep User
```

## Backup and Recovery

### Backup Configuration
```bash
# Backup your configuration
cp ~/.inference-mining-config.json ~/inference-config-backup.json

# Backup systemd service
sudo cp /etc/systemd/system/inference-mining.service ~/inference-service-backup.service
```

### Recovery Process
```bash
# Restore configuration
cp ~/inference-config-backup.json ~/.inference-mining-config.json

# Re-run installer to restore setup
./ultimate-gpu-installer.sh
```

## Support and Help

### Log Files
```bash
# View installer logs
cat ~/inference-installer.log

# View systemd service logs
sudo journalctl -u inference-mining -f

# View container logs
docker logs inference-gpu-0 -f
```

### Getting Help
1. **Check logs** for error messages
2. **Read troubleshooting** section above
3. **Create GitHub issue** with logs and system info
4. **Join community discussions** for peer support

---

**🔥 Ready to start mining? Run the installer and let the magic happen! 💰**
