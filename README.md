# 🔥 Ultimate Multi-GPU Inference.net Setup

**The Revolutionary Auto-Persistence Installer That Changes Everything**

## ⚠️ IMPORTANT: RAM Requirements

**Before installing, check your system RAM with `free -h`. Each inference container uses 4-6GB of memory. For 16GB systems, run maximum 2-3 containers to avoid system slowdowns. For 32GB+ systems, you can run 4-8 containers. If your system becomes slow after deployment, immediately stop some containers with `docker stop "container_name` and run fewer containers. More RAM = more containers = higher earnings, but stability is more important than quantity.**
## 🚀 One-Command Installation

```bash
wget https://raw.githubusercontent.com/bokiko/Multi-GPU-Inference.net/main/ultimate-gpu-installer.sh && chmod +x ultimate-gpu-installer.sh && ./ultimate-gpu-installer.sh
```

## 🎯 What Makes This Ultimate?

- **🤖 Interactive Installation** - No manual editing required
- **💾 Auto-Saves Configuration** - Remembers your setup forever  
- **🔄 Auto-Starts on Boot** - Deploy once, mine forever
- **📊 Smart Restart Logic** - Use existing config or start fresh
- **🎮 Beautiful User Interface** - Colored prompts and validation

## 📱 Quick Demo

### First Run
```
🔥 ULTIMATE INFERENCE.NET INSTALLER 🔥
========================================

🔍 Detecting GPUs...
✅ Detected 8 GPU(s):
   GPU 0: NVIDIA GeForce RTX 3070 (8192 MiB)
   GPU 1: NVIDIA GeForce RTX 3070 (8192 MiB)
   GPU 2: NVIDIA GeForce RTX 3060 Ti (8192 MiB)
   GPU 3: NVIDIA GeForce RTX 3060 Ti (8192 MiB)
   GPU 4: NVIDIA GeForce RTX 3070 Ti (8192 MiB)
   GPU 5: NVIDIA GeForce RTX 3070 Ti (8192 MiB)
   GPU 6: NVIDIA GeForce RTX 3070 Ti (8192 MiB)
   GPU 7: NVIDIA GeForce RTX 3070 (8192 MiB)

❓ How many GPUs do you want to use for mining?
   (Enter a number between 1 and 8): 
   > 8

🔑 Now we need worker codes for each GPU
   Go to: https://devnet.inference.net/dashboard
   1. Click 'Workers' tab
   2. Create a worker for each GPU
   3. Select 'Docker' deployment
   4. Copy the code after '--code'

🎯 Enter worker code for GPU 0:
   (Paste the code after '--code' from dashboard)
   > xxxxxxxx-703d-4bff-xxxx-8cfde328xxxx
   ✅ Worker code for GPU 0 saved!

🎯 Enter worker code for GPU 1:
   > f3b74029-xxxx-xxxx-86c0-3be66ea0xxxx
   ✅ Worker code for GPU 1 saved!

... (continues for all GPUs)

🏷️ Container Naming:
   Do you want custom container names? (y/n)
   > y
   Enter a prefix for container names (e.g., 'rig', 'miner', 'kuzco'):
   > kuzco
   ✅ Will use prefix: kuzco

📋 DEPLOYMENT SUMMARY:
=====================
   GPUs to use: 8
   Container prefix: kuzco
   Worker codes: 8 codes collected

   GPU 0: kuzco-0 (xxxed789...)
   GPU 1: kuzco-1 (fxxx4029...)
   GPU 2: kuzco-2 (97xxx966...)
   GPU 3: kuzco-3 (84dxxxd9...)
   GPU 4: kuzco-4 (bxxx5fb5...)
   GPU 5: kuzco-5 (1fdxxxca...)
   GPU 6: kuzco-6 (bd4bxxxx...)
   GPU 7: kuzco-7 (1e83xxxx...)

❓ Ready to deploy? (y/n)
   > y

🚀 DEPLOYING CONTAINERS...
   🎯 Deploying GPU 0 as 'kuzco-0'...
   ✅ GPU 0 deployed successfully!
   🎯 Deploying GPU 1 as 'kuzco-1'...
   ✅ GPU 1 deployed successfully!
   ... (continues for all GPUs)

🔄 Setting up auto-start on boot...
   ✅ Auto-start service created and enabled!

📊 Creating monitoring script...
   ✅ Monitor script created: ./monitor-rig.sh

🎉 DEPLOYMENT COMPLETE!

💰 Your mining rig will now auto-start on boot!
🔄 Reboot to test: sudo reboot
```

### Subsequent Runs
```
🔥 ULTIMATE INFERENCE.NET INSTALLER 🔥
========================================

📋 EXISTING CONFIGURATION FOUND:
================================
   Created: 2025-06-08 15:30:45
   GPUs: 8
   Prefix: kuzco
   Workers: 8 configured

   GPU 0: kuzco-0 (7x3ed789...)
   GPU 1: kuzco-1 (fxbxx029...)
   GPU 2: kuzco-2 (9x2fxxx6...)
   GPU 3: kuzco-3 (84d2xxx9...)
   GPU 4: kuzco-4 (b7115xxx...)
   GPU 5: kuzco-5 (1xd86xxx...)
   GPU 6: kuzco-6 (bx4b7xxx...)
   GPU 7: kuzco-7 (1x833xxx...)

❓ Use existing configuration? (y/n)
   y = Deploy with saved settings
   n = Start fresh interactive setup
   > y

🔄 Using existing configuration...
🛑 Stopping existing containers with prefix 'kuzco'...
   ✅ Stopped existing containers

🚀 DEPLOYING CONTAINERS...
   🎯 Deploying GPU 0 as 'kuzco-0'...
   ✅ GPU 0 deployed successfully!
   ... (continues for all GPUs)

🎉 All containers deployed successfully!

📊 Container Status:
NAMES      STATUS         RUNNINGFOR
kuzco-7    Up 3 seconds   
kuzco-6    Up 10 seconds  
kuzco-5    Up 18 seconds  
kuzco-4    Up 29 seconds  
kuzco-3    Up 36 seconds  
kuzco-2    Up 46 seconds  
kuzco-1    Up 53 seconds  
kuzco-0    Up About a minute

💰 Your mining rig is now earning! Check the dashboard for worker status.
```

## 🔧 Prerequisites

### System Requirements
- **Ubuntu 20.04/22.04 LTS** (recommended)
- **NVIDIA Drivers** (version 530+)  
- **Docker** with NVIDIA runtime
- **Multiple NVIDIA GPUs** (RTX 3060 Ti or higher)

### Auto-Installation Check
The script automatically checks and reports:
- ✅ NVIDIA drivers installed
- ✅ Docker installed and accessible
- ✅ GPU detection working
- ✅ Required packages (jq for JSON parsing)

## 🎮 Features

✅ **Automatic GPU Detection** - Shows all available GPUs with specs  
✅ **Interactive Worker Code Collection** - Validates UUID format  
✅ **Custom Container Naming** - Choose your own prefix  
✅ **Configuration Persistence** - Saves to JSON file  
✅ **Auto-Boot Deployment** - Systemd service creation  
✅ **Comprehensive Monitoring** - Generated monitoring script  
✅ **Error Handling & Recovery** - Graceful failure handling  
✅ **Smart Restart Logic** - Use saved config or start fresh  

## 📊 Generated Files

After installation, these files are created automatically:

### Configuration File
**Location**: `~/.inference-mining-config.json`
```json
{
  "timestamp": "2025-06-08 15:30:45",
  "gpu_count": 8,
  "container_prefix": "kuzco",
  "worker_codes": [
    "793ed789-703d-xxxx-xxxx-8cfde328xxxx",
    "f3b74029-997f-xxxx-xxxx-3be66ea0xxxx",
    "972f7966-3f13-xxxx-xxxx-5d26a30fxxxx",
    "84d2b8d9-3a8a-xxxx-xxxx-9077e3d8xxxx",
    "b7115fb5-d633-xxxx-xxxx-c415f66cxxxx",
    "1fd86aca-74b1-xxxx-xxxx-c8484bb7xxxx",
    "bd4b7549-b665-xxxx-xxxx-59f0f940xxxx",
    "1e8337aa-9e28-xxxx-xxxx-490eb453xxxx"
  ],
  "script_path": "/home/user/ultimate-gpu-installer.sh"
}
```

### Auto-Start Service
**Location**: `/etc/systemd/system/inference-mining.service`
- Starts containers automatically on boot
- Handles Docker and NVIDIA service dependencies
- Logs all activities for troubleshooting

### Monitoring Script
**Location**: `./monitor-rig.sh`
- Real-time GPU status with temperature and utilization
- Container health and running time
- System resource usage
- Auto-start service status

### Log File
**Location**: `~/inference-installer.log`
- Timestamps all installation activities
- Tracks deployment success/failures
- Useful for troubleshooting issues

## 🎯 Supported Hardware

### Recommended GPUs
- **RTX 4090, 4080, 4070 Ti, 4070**
- **RTX 3090, 3080, 3070 Ti, 3070, 3060 Ti**
- **RTX A6000, A5000, A4000**
- **Tesla V100, A100** (datacenter deployments)

### Example Configurations

#### 8-GPU Beast Rig (Like KUZCO Empire)
```
3x RTX 3070 (8GB VRAM each)
2x RTX 3060 Ti (8GB VRAM each)  
3x RTX 3070 Ti (8GB VRAM each)
Expected: ~123-164 jobs/hour
Power: ~2000W+ PSU recommended
```

#### 4-GPU Mid-Range Setup
```
4x RTX 3060 Ti (8GB VRAM each)
Expected: ~48-64 jobs/hour
Power: ~1000W PSU recommended
```

#### 2-GPU Starter Setup
```
2x RTX 3070 (8GB VRAM each)
Expected: ~30-40 jobs/hour
Power: ~750W PSU recommended
```

## 📊 Monitoring & Management

### Real-Time Monitoring Commands
```bash
# GPU usage monitoring
watch -n 1 nvidia-smi

# Container performance
docker stats

# Generated monitor script (comprehensive)
./monitor-rig.sh

# Check specific container logs
docker logs kuzco-0 -f
```

### Management Commands
```bash
# Restart installer (use existing config or fresh setup)
./ultimate-gpu-installer.sh

# Stop all containers
docker stop $(docker ps -q --filter 'name=kuzco')

# Remove all containers
docker rm $(docker ps -aq --filter 'name=kuzco')

# Check auto-start service
sudo systemctl status inference-mining

# View service logs
sudo journalctl -u inference-mining -f

# View saved configuration
cat ~/.inference-mining-config.json

# Manual container restart
docker restart kuzco-0 kuzco-1 kuzco-2 kuzco-3 kuzco-4 kuzco-5 kuzco-6 kuzco-7
```

## 💰 Expected Performance & ROI

### Performance Estimates (Per Hour)
- **RTX 4090**: ~30-40 jobs = ~$XX.XX
- **RTX 4080**: ~25-35 jobs = ~$XX.XX  
- **RTX 3090**: ~25-30 jobs = ~$XX.XX
- **RTX 3080**: ~20-25 jobs = ~$XX.XX
- **RTX 3070 Ti**: ~18-24 jobs = ~$XX.XX
- **RTX 3070**: ~15-20 jobs = ~$XX.XX
- **RTX 3060 Ti**: ~12-16 jobs = ~$XX.XX

### 8-GPU Beast Rig Daily Potential
```
Conservative Estimate: ~2,900 jobs/day
Optimistic Estimate: ~4,000+ jobs/day
Monthly Potential: ~87,000-120,000+ jobs
```

*Performance varies based on network demand, job availability, and GPU efficiency*

## 🔧 Troubleshooting

### Common Issues

#### Docker Permission Denied
```bash
# Fix: Add user to docker group
sudo usermod -aG docker $USER
# Then logout and login again
```

#### NVIDIA Driver Issues
```bash
# Check drivers
nvidia-smi

# If driver/library mismatch:
sudo reboot

# If still broken, reinstall drivers
sudo ubuntu-drivers autoinstall
sudo reboot
```

#### Service Won't Start on Boot
```bash
# Check service status
sudo systemctl status inference-mining

# Check service logs
sudo journalctl -u inference-mining -f

# Re-enable service
sudo systemctl enable inference-mining
```

#### Container Deployment Failures
```bash
# Check Docker daemon
sudo systemctl status docker

# Check available resources
df -h
free -h

# Clean up Docker
docker system prune -f

# Re-run installer
./ultimate-gpu-installer.sh
```

## 💡 Pro Tips for Maximum Earnings

### Hardware Optimization
1. **Quality PSU** - Use 80+ Gold rated with 20% headroom
2. **Proper Cooling** - Maintain GPU temps under 80°C
3. **Stable Internet** - Use wired connection, avoid WiFi
4. **UPS Backup** - Prevent shutdowns during power outages

### Software Optimization
1. **Set GPU Power Limits** - `sudo nvidia-smi -pl 300` (adjust per GPU)
2. **Enable Persistence Mode** - `sudo nvidia-smi -pm 1`
3. **Monitor Regularly** - Check dashboard daily for worker status
4. **Update Drivers** - Keep NVIDIA drivers current

### Maintenance Schedule
- **Daily**: Check dashboard for worker status and earnings
- **Weekly**: Run `./monitor-rig.sh` and review logs
- **Monthly**: Update system packages and check temperatures
- **Quarterly**: Clean dust from GPUs and review performance

## 🌐 Resources & Links

- **Inference.net Dashboard**: https://devnet.inference.net/dashboard
- **Official Documentation**: https://docs.inference.net
- **NVIDIA Driver Downloads**: https://www.nvidia.com/drivers
- **Docker Installation**: https://docs.docker.com/engine/install/ubuntu/
- **Ubuntu Server Download**: https://ubuntu.com/download/server

## 📈 Success Stories

###  8 GPU Beast Rig
```
Configuration: 3x RTX 3070, 2x RTX 3060 Ti, 3x RTX 3070 Ti
Installation: Single command deployment
Uptime: 99.9% with auto-restart

```

## 🤝 Contributing

Found a bug or want to improve the installer? 
- **Report Issues**: Create GitHub issues for problems
- **Submit PRs**: Improvements and optimizations welcome
- **Share Configs**: Post your successful setups in discussions

## 📄 License

MIT License - Use, modify, and distribute freely.

---

**🔥 Install Once, Mine Forever! 💰**

*Created by [Bokiko](https://github.com/bokiko) 

---

### ⭐ If this helped you earn money, please star the repo! ⭐
