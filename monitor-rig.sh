#!/bin/bash

# 🔥 INFERENCE.NET RIG MONITORING SCRIPT 🔥
# Created by: Bokiko
# Repository: https://github.com/bokiko/Multi-GPU-Inference.net
# Description: Comprehensive monitoring for multi-GPU mining rigs

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration file location
CONFIG_FILE="$HOME/.inference-mining-config.json"

# Function to print colored output
print_colored() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Function to get container prefix from config
get_container_prefix() {
    if [ -f "$CONFIG_FILE" ]; then
        jq -r '.container_prefix' "$CONFIG_FILE" 2>/dev/null || echo "inference-gpu"
    else
        echo "inference-gpu"
    fi
}

# Clear screen and show header
clear
print_colored $CYAN "========================================"
print_colored $CYAN "🔥 INFERENCE.NET RIG STATUS MONITOR 🔥"
print_colored $CYAN "    github.com/bokiko/Multi-GPU       "
print_colored $CYAN "========================================"
echo ""

# Show configuration information
if [ -f "$CONFIG_FILE" ]; then
    print_colored $PURPLE "📋 Configuration:"
    echo "Created: $(jq -r '.timestamp' "$CONFIG_FILE" 2>/dev/null)"
    echo "GPUs: $(jq -r '.gpu_count' "$CONFIG_FILE" 2>/dev/null)"
    echo "Prefix: $(jq -r '.container_prefix' "$CONFIG_FILE" 2>/dev/null)"
    echo ""
else
    print_colored $YELLOW "⚠️  No configuration file found"
    echo "Run the installer first: ./ultimate-gpu-installer.sh"
    echo ""
fi

# GPU Status Section
print_colored $YELLOW "📊 GPU Status:"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi --query-gpu=index,name,temperature.gpu,power.draw,utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | \
    while IFS=, read -r index name temp power util mem_used mem_total; do
        # Calculate memory percentage
        if [ "$mem_total" != "0" ] && [ "$mem_total" != "" ]; then
            mem_percent=$(awk "BEGIN {printf \"%.1f\", ($mem_used/$mem_total)*100}")
        else
            mem_percent="N/A"
        fi
        
        # Color code based on utilization
        if [ "$util" != "" ] && [ "$util" != "N/A" ]; then
            if [ "${util%.*}" -ge 80 ]; then
                util_color=$GREEN
            elif [ "${util%.*}" -ge 50 ]; then
                util_color=$YELLOW
            else
                util_color=$RED
            fi
        else
            util_color=$NC
        fi
        
        printf "   GPU %s: %s\n" "$index" "$name"
        printf "          Temp: %s°C | Power: %sW | Util: ${util_color}%s%%${NC} | Mem: %s/%sMB (%s%%)\n" \
               "$temp" "$power" "$util" "$mem_used" "$mem_total" "$mem_percent"
    done
else
    print_colored $RED "❌ nvidia-smi not found"
fi
echo ""

# Container Status Section
print_colored $YELLOW "📦 Container Status:"
container_prefix=$(get_container_prefix)
if command -v docker &> /dev/null; then
    containers=$(docker ps --filter "name=$container_prefix" --format "table {{.Names}}\t{{.Status}}\t{{.RunningFor}}" 2>/dev/null)
    
    if [ -n "$containers" ]; then
        echo "$containers"
        
        # Count running vs total containers
        total_containers=$(docker ps -a --filter "name=$container_prefix" --format "{{.Names}}" | wc -l)
        running_containers=$(docker ps --filter "name=$container_prefix" --format "{{.Names}}" | wc -l)
        
        echo ""
        if [ "$running_containers" -eq "$total_containers" ] && [ "$total_containers" -gt 0 ]; then
            print_colored $GREEN "✅ All containers running ($running_containers/$total_containers)"
        elif [ "$running_containers" -gt 0 ]; then
            print_colored $YELLOW "⚠️  Partial deployment ($running_containers/$total_containers running)"
        else
            print_colored $RED "❌ No containers running"
        fi
    else
        print_colored $RED "❌ No containers found with prefix '$container_prefix'"
        echo "   Run the installer: ./ultimate-gpu-installer.sh"
    fi
else
    print_colored $RED "❌ Docker not found"
fi
echo ""

# System Resources Section
print_colored $YELLOW "💻 System Resources:"

# CPU Usage
if command -v top &> /dev/null; then
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
    echo "CPU: ${cpu_usage}% usage"
else
    echo "CPU: Unable to determine"
fi

# Memory Usage
if command -v free &> /dev/null; then
    memory_info=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    memory_percent=$(free | awk '/^Mem:/ {printf "%.1f", ($3/$2)*100}')
    echo "RAM: $memory_info (${memory_percent}% used)"
else
    echo "RAM: Unable to determine"
fi

# Disk Usage
if command -v df &> /dev/null; then
    disk_info=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')
    echo "Disk: $disk_info"
else
    echo "Disk: Unable to determine"
fi

# Network status
if command -v ping &> /dev/null; then
    if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        print_colored $GREEN "Network: ✅ Connected"
    else
        print_colored $RED "Network: ❌ No internet connection"
    fi
else
    echo "Network: Unable to test"
fi
echo ""

# Docker System Info
print_colored $YELLOW "🐳 Docker System:"
if command -v docker &> /dev/null; then
    # Docker version
    docker_version=$(docker --version | awk '{print $3}' | sed 's/,//')
    echo "Version: $docker_version"
    
    # Docker system usage
    if docker system df &> /dev/null; then
        images_size=$(docker system df | awk '/Images/ {print $3}')
        containers_size=$(docker system df | awk '/Containers/ {print $3}')
        echo "Images: $images_size | Containers: $containers_size"
    fi
    
    # Docker daemon status
    if docker info &> /dev/null; then
        print_colored $GREEN "Daemon: ✅ Running"
    else
        print_colored $RED "Daemon: ❌ Not accessible"
    fi
else
    print_colored $RED "❌ Docker not found"
fi
echo ""

# Auto-Start Service Status
print_colored $YELLOW "🔄 Auto-Start Service:"
if systemctl is-enabled inference-mining >/dev/null 2>&1; then
    if systemctl is-active inference-mining >/dev/null 2>&1; then
        print_colored $GREEN "✅ Auto-start: ENABLED and ACTIVE"
        last_run=$(systemctl show inference-mining --property=ExecMainStartTimestamp --value)
        if [ -n "$last_run" ] && [ "$last_run" != "" ]; then
            echo "   Last run: $last_run"
        fi
    else
        print_colored $YELLOW "⚠️  Auto-start: ENABLED but INACTIVE"
    fi
else
    print_colored $RED "❌ Auto-start: DISABLED"
    echo "   Enable with: sudo systemctl enable inference-mining"
fi
echo ""

# Recent Logs (if available)
print_colored $YELLOW "📋 Recent Activity:"
if [ -f "$HOME/inference-installer.log" ]; then
    echo "Latest installer log entries:"
    tail -n 3 "$HOME/inference-installer.log" | while read -r line; do
        echo "   $line"
    done
else
    echo "No installer log found"
fi

# Container logs summary
if [ -n "$(docker ps --filter "name=$container_prefix" -q 2>/dev/null)" ]; then
    first_container=$(docker ps --filter "name=$container_prefix" --format "{{.Names}}" | head -1)
    if [ -n "$first_container" ]; then
        echo ""
        echo "Latest container activity ($first_container):"
        docker logs "$first_container" --tail 2 2>/dev/null | while read -r line; do
            echo "   $line"
        done
    fi
fi
echo ""

# Performance Summary
print_colored $YELLOW "📈 Performance Summary:"
if [ -f "$CONFIG_FILE" ]; then
    gpu_count=$(jq -r '.gpu_count' "$CONFIG_FILE" 2>/dev/null)
    if [ "$gpu_count" != "null" ] && [ "$gpu_count" != "" ]; then
        echo "Configured GPUs: $gpu_count"
        
        # Estimate performance based on GPU utilization
        total_util=0
        gpu_with_util=0
        
        if command -v nvidia-smi &> /dev/null; then
            while read -r util; do
                if [ "$util" != "" ] && [ "$util" != "N/A" ]; then
                    total_util=$((total_util + ${util%.*}))
                    gpu_with_util=$((gpu_with_util + 1))
                fi
            done < <(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
            
            if [ $gpu_with_util -gt 0 ]; then
                avg_util=$((total_util / gpu_with_util))
                echo "Average GPU utilization: ${avg_util}%"
                
                if [ $avg_util -ge 80 ]; then
                    print_colored $GREEN "✅ Excellent performance"
                elif [ $avg_util -ge 50 ]; then
                    print_colored $YELLOW "⚠️  Moderate performance"
                else
                    print_colored $RED "❌ Low performance - check for issues"
                fi
            fi
        fi
    fi
fi
echo ""

# Quick Action Commands
print_colored $YELLOW "🛠️  Quick Actions:"
echo "Monitor continuously: watch -n 5 $0"
echo "Real-time GPU monitor: watch -n 1 nvidia-smi"
echo "Container stats: docker stats"
echo "Restart installer: ./ultimate-gpu-installer.sh"
echo "Check service logs: sudo journalctl -u inference-mining -f"
echo ""

# Footer with links
print_colored $CYAN "🌐 Resources:"
print_colored $CYAN "Dashboard: https://devnet.inference.net/dashboard"
print_colored $CYAN "Repository: https://github.com/bokiko/Multi-GPU-Inference.net"
print_colored $CYAN "Issues: https://github.com/bokiko/Multi-GPU-Inference.net/issues"
echo ""

# Final status summary
if [ -f "$CONFIG_FILE" ] && [ -n "$(docker ps --filter "name=$container_prefix" -q 2>/dev/null)" ]; then
    print_colored $GREEN "🎉 System Status: OPERATIONAL - Mining in progress!"
else
    print_colored $YELLOW "⚠️  System Status: INCOMPLETE - Run installer to start mining"
fi

echo ""
print_colored $PURPLE "Last updated: $(date)"
echo ""
