# 🔧 Troubleshooting Guide

## Quick Diagnostics

### Run System Check
```bash
# Download and run the monitoring script
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/monitor-rig.sh
chmod +x monitor-rig.sh
./monitor-rig.sh
```

### Check All Prerequisites
```bash
# Check NVIDIA drivers
nvidia-smi

# Check Docker
docker --version
docker ps

# Check GPU accessibility from Docker
docker run --rm --gpus all nvidia/cuda:11.0-base-ubuntu20.04 nvidia-smi

# Check configuration file
cat ~/.inference-mining-config.json

# Check auto-start service
sudo systemctl status inference-mining
```

## Common Issues & Solutions

### 1. NVIDIA Driver Issues

#### Problem: "nvidia-smi: command not found"
```bash
# Solution: Install NVIDIA drivers
sudo apt update
sudo apt install ubuntu-drivers-common
sudo ubuntu-drivers autoinstall
sudo reboot

# Verify installation
nvidia-smi
```

#### Problem: "NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver"
```bash
# Solution: Driver/kernel mismatch - reboot first
sudo reboot

# If still broken, reinstall drivers
sudo apt purge nvidia-* libnvidia-*
sudo apt autoremove
sudo ubuntu-drivers autoinstall
sudo reboot
```

#### Problem: Driver version incompatibility
```bash
# Check current driver version
nvidia-smi

# Check available drivers
ubuntu-drivers devices

# Install specific version (example)
sudo apt install nvidia-driver-530
sudo reboot
```

### 2. Docker Issues

#### Problem: "docker: command not found"
```bash
# Solution: Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Apply group changes
newgrp docker
# OR logout and login again
```

#### Problem: "permission denied while trying to connect to Docker daemon"
```bash
# Solution: Add user to docker group
sudo usermod -aG docker $USER

# Apply changes immediately
newgrp docker

# Or restart session
exit
# SSH back in

# Verify access
docker ps
```

#### Problem: "docker: Error response from daemon: could not select device driver"
```bash
# Solution: Install NVIDIA Container Runtime
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

# Test NVIDIA Docker integration
docker run --rm --gpus all nvidia/cuda:11.0-base-ubuntu20.04 nvidia-smi
```

### 3. Container Deployment Issues

#### Problem: Containers fail to start
```bash
# Check container logs
docker logs inference-gpu-0

# Common fixes:
# 1. Check available memory
free -h

# 2. Check disk space
df -h

# 3. Clean up Docker
docker system prune -f

# 4. Restart Docker service
sudo systemctl restart docker

# 5. Re-run installer
./ultimate-gpu-installer.sh
```

#### Problem: "No such container" errors
```bash
# Check what containers exist
docker ps -a

# Check your configuration
cat ~/.inference-mining-config.json

# Verify container naming
container_prefix=$(jq -r '.container_prefix' ~/.inference-mining-config.json)
docker ps --filter "name=$container_prefix"

# Re-deploy if needed
./ultimate-gpu-installer.sh
```

#### Problem: Containers keep restarting
```bash
# Check restart policy
docker inspect inference-gpu-0 | jq '.[0].HostConfig.RestartPolicy'

# Check container logs for errors
docker logs inference-gpu-0 --tail 50

# Common causes:
# - Invalid worker codes
# - Network connectivity issues
# - Insufficient GPU memory
# - Worker already registered elsewhere
```

### 4. Configuration Issues

#### Problem: "jq: command not found"
```bash
# Solution: Install jq
sudo apt update && sudo apt install -y jq

# Verify installation
jq --version
```

#### Problem: Invalid configuration file
```bash
# Check if file exists and is valid JSON
if [ -f ~/.inference-mining-config.json ]; then
    jq . ~/.inference-mining-config.json
else
    echo "Configuration file not found"
fi

# If corrupted, remove and re-run installer
rm ~/.inference-mining-config.json
./ultimate-gpu-installer.sh
```

#### Problem: Worker codes not accepted
```bash
# Verify worker code format (should be UUID)
# Valid format: 793ed789-703d-4bff-a6f1-8cfde3289a79

# Check worker codes in config
jq -r '.worker_codes[]' ~/.inference-mining-config.json

# Re-create workers on dashboard if needed
# https://devnet.inference.net/dashboard
```

### 5. Auto-Start Service Issues

#### Problem: Service fails to start on boot
```bash
# Check service status
sudo systemctl status inference-mining

# Check service logs
sudo journalctl -u inference-mining -f

# Common fixes:
# 1. Verify service file
sudo cat /etc/systemd/system/inference-mining.service

# 2. Reload systemd daemon
sudo systemctl daemon-reload

# 3. Re-enable service
sudo systemctl enable inference-mining

# 4. Test manual start
sudo systemctl start inference-mining
```

#### Problem: Service starts but containers don't deploy
```bash
# Check service logs for errors
sudo journalctl -u inference-mining -n 50

# Verify configuration file exists
ls -la ~/.inference-mining-config.json

# Check Docker daemon status
sudo systemctl status docker

# Manual test of auto-start
./ultimate-gpu-installer.sh --auto-start
```

### 6. Performance Issues

#### Problem: Low GPU utilization
```bash
# Check GPU status
nvidia-smi

# Monitor GPU usage over time
watch -n 1 nvidia-smi

# Check container resource limits
docker stats

# Possible causes:
# - Network connectivity issues
# - Insufficient jobs available
# - GPU memory constraints
# - Thermal throttling
```

#### Problem: High temperatures
```bash
# Monitor temperatures
nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits

# Check cooling:
# - Verify all fans working
# - Clean dust from heatsinks
# - Improve case airflow
# - Check thermal paste

# Reduce power limits if needed
sudo nvidia-smi -pl 250  # Adjust value per GPU
```

#### Problem: System instability
```bash
# Check system logs
sudo dmesg | tail -50
sudo journalctl -xe

# Monitor system resources
htop

# Common causes:
# - Insufficient PSU wattage
# - Overheating
# - RAM issues
# - Power delivery problems

# Stress test individual components
# Test GPUs one by one
```

### 7. Network Issues

#### Problem: Cannot connect to Inference.net
```bash
# Test internet connectivity
ping google.com

# Test Inference.net connectivity
curl -I https://devnet.inference.net

# Check firewall rules
sudo ufw status

# If using corporate network:
# - Check proxy settings
# - Verify HTTPS (443) is allowed
# - Contact network administrator
```

#### Problem: Containers can't reach network
```bash
# Check Docker network
docker network ls

# Test container networking
docker run --rm alpine ping google.com

# Restart Docker networking
sudo systemctl restart docker

# Check DNS settings
cat /etc/resolv.conf
```

### 8. Update and Maintenance Issues

#### Problem: Old installer version
```bash
# Download latest version
wget -O ultimate-gpu-installer-new.sh https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh

# Compare versions (if available)
diff ultimate-gpu-installer.sh ultimate-gpu-installer-new.sh

# Replace with new version
mv ultimate-gpu-installer-new.sh ultimate-gpu-installer.sh
chmod +x ultimate-gpu-installer.sh
```

#### Problem: System package conflicts
```bash
# Update package lists
sudo apt update

# Check for held packages
apt-mark showhold

# Resolve package conflicts
sudo apt --fix-broken install

# Upgrade system carefully
sudo apt upgrade
```

## Advanced Diagnostics

### System Information Gathering
```bash
# Create diagnostic report
cat > diagnostic-report.sh << 'EOF'
#!/bin/bash
echo "=== SYSTEM DIAGNOSTIC REPORT ==="
echo "Date: $(date)"
echo ""

echo "=== SYSTEM INFO ==="
uname -a
lsb_release -a 2>/dev/null
echo ""

echo "=== GPU INFO ==="
nvidia-smi
echo ""

echo "=== DOCKER INFO ==="
docker --version
docker info 2>/dev/null
echo ""

echo "=== CONTAINER STATUS ==="
docker ps -a
echo ""

echo "=== CONFIGURATION ==="
if [ -f ~/.inference-mining-config.json ]; then
    cat ~/.inference-mining-config.json
else
    echo "No configuration file found"
fi
echo ""

echo "=== SERVICE STATUS ==="
systemctl status inference-mining --no-pager
echo ""

echo "=== RECENT LOGS ==="
if [ -f ~/inference-installer.log ]; then
    echo "Installer logs:"
    tail -10 ~/inference-installer.log
fi
echo ""

echo "=== SYSTEM RESOURCES ==="
free -h
df -h
echo ""
EOF

chmod +x diagnostic-report.sh
./diagnostic-report.sh > diagnostic-report.txt
```

### Container Deep Diagnostics
```bash
# Inspect specific container
docker inspect inference-gpu-0

# Check container resource usage
docker stats --no-stream

# Access container shell for debugging
docker exec -it inference-gpu-0 /bin/bash

# Check container filesystem
docker exec inference-gpu-0 df -h

# Monitor container logs live
docker logs inference-gpu-0 -f --tail 100
```

### Network Diagnostics
```bash
# Test container network connectivity
docker run --rm alpine nslookup devnet.inference.net

# Check Docker daemon logs
sudo journalctl -u docker -f

# Test GPU accessibility from container
docker run --rm --gpus all nvidia/cuda:11.0-base-ubuntu20.04 \
  bash -c "nvidia-smi && echo 'GPU accessible from container'"
```

## Emergency Recovery

### Complete System Reset
```bash
# DANGER: This removes all containers and data
# Only use if system is completely broken

# Stop all containers
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

# Remove all images (optional)
docker rmi $(docker images -q)

# Clean Docker system
docker system prune -af

# Remove configuration
rm ~/.inference-mining-config.json

# Remove auto-start service
sudo systemctl stop inference-mining
sudo systemctl disable inference-mining
sudo rm /etc/systemd/system/inference-mining.service
sudo systemctl daemon-reload

# Start fresh
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh
chmod +x ultimate-gpu-installer.sh
./ultimate-gpu-installer.sh
```

### Backup and Restore
```bash
# Backup current configuration
cp ~/.inference-mining-config.json ~/config-backup-$(date +%Y%m%d).json

# Backup service file
sudo cp /etc/systemd/system/inference-mining.service ~/service-backup-$(date +%Y%m%d).service

# Restore from backup
cp ~/config-backup-20250608.json ~/.inference-mining-config.json
./ultimate-gpu-installer.sh  # Will use existing config
```

## Getting Help

### Information to Gather Before Seeking Help
1. **System Information**:
   ```bash
   uname -a
   lsb_release -a
   nvidia-smi
   docker --version
   ```

2. **Error Messages**: Copy exact error messages from:
   - Installer output
   - Container logs: `docker logs inference-gpu-0`
   - System logs: `sudo journalctl -xe`
   - Service logs: `sudo journalctl -u inference-mining`

3. **Configuration**: 
   ```bash
   cat ~/.inference-mining-config.json
   ```

4. **System Status**:
   ```bash
   ./monitor-rig.sh
   ```

### Community Support
- **GitHub Issues**: https://github.com/bokiko/Multi-GPU-Inference.net/issues
- **Discussions**: https://github.com/bokiko/Multi-GPU-Inference.net/discussions
- **Discord**: [Join the community Discord]

### Creating a Good Bug Report
```markdown
**System Information:**
- OS: Ubuntu 22.04
- GPUs: 2x RTX 3070
- Docker Version: 24.0.5
- NVIDIA Driver: 530.30.02

**Issue Description:**
Clear description of the problem

**Steps to Reproduce:**
1. Run installer
2. Select 2 GPUs
3. Enter worker codes
4. See error

**Error Output:**
```
[Paste exact error messages here]
```

**Configuration:**
```json
[Paste configuration file if relevant]
```
```

---

**💡 Most issues can be resolved by following this guide systematically. Start with the basics and work your way up!**
