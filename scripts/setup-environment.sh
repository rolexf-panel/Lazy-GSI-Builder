#!/bin/bash
source "$(dirname "$0")/utils.sh"

print_header "Setting Up Build Environment"
start_timer

# Show system info
show_system_info

# Additional cleanup
print_info "Performing additional disk cleanup..."
sudo rm -rf /usr/share/dotnet 2>/dev/null || true
sudo rm -rf /usr/local/lib/android 2>/dev/null || true
sudo rm -rf /opt/ghc 2>/dev/null || true
sudo rm -rf /opt/hostedtoolcache/CodeQL 2>/dev/null || true

# Only prune docker if it's available
if command -v docker &> /dev/null; then
    print_info "Pruning Docker images..."
    sudo docker image prune --all --force > /dev/null 2>&1 || true
else
    print_info "Docker not available, skipping docker cleanup"
fi

echo ""
print_info "Available space after cleanup:"
df -h | grep -E '^/dev/'
echo ""

# Install dependencies with progress
print_info "Installing build dependencies..."

TOTAL_STEPS=5
CURRENT_STEP=0

# Step 1: Update package list
CURRENT_STEP=$((CURRENT_STEP + 1))
show_progress $CURRENT_STEP $TOTAL_STEPS "Updating package list"
sudo apt-get update > /dev/null 2>&1

# Step 2: Core build tools
CURRENT_STEP=$((CURRENT_STEP + 1))
show_progress $CURRENT_STEP $TOTAL_STEPS "Installing core build tools"
sudo apt-get install -y \
    bc bison build-essential ccache curl flex \
    g++-multilib gcc-multilib git gnupg gperf \
    imagemagick lib32ncurses5-dev lib32readline-dev \
    lib32z1-dev liblz4-tool libncurses5 libncurses5-dev \
    libsdl1.2-dev libssl-dev libxml2 libxml2-utils \
    lzop pngcrush rsync schedtool squashfs-tools xsltproc \
    zip zlib1g-dev > /dev/null 2>&1

# Step 3: Java dependencies
CURRENT_STEP=$((CURRENT_STEP + 1))
show_progress $CURRENT_STEP $TOTAL_STEPS "Installing Java (8, 11, 17)"
sudo apt-get install -y \
    openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk > /dev/null 2>&1

# Step 4: Python and additional tools
CURRENT_STEP=$((CURRENT_STEP + 1))
show_progress $CURRENT_STEP $TOTAL_STEPS "Installing Python and additional tools"
sudo apt-get install -y \
    python3 python3-pip python-is-python3 \
    perl xmlstarlet virtualenv xz-utils \
    git-lfs jq rr lunzip > /dev/null 2>&1

# Step 5: Additional libraries
CURRENT_STEP=$((CURRENT_STEP + 1))
show_progress $CURRENT_STEP $TOTAL_STEPS "Installing additional libraries"
sudo apt-get install -y libwxgtk3.0-gtk3-dev libxml2 > /dev/null 2>&1 || \
    sudo apt-get install -y libwxgtk3.2-dev > /dev/null 2>&1

echo ""
print_success "All dependencies installed successfully"

# Install repo tool
print_info "Installing repo tool..."
mkdir -p ~/bin
curl -s https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo "$HOME/bin" >> $GITHUB_PATH
print_success "Repo tool installed"

# Configure git
print_info "Configuring git..."
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"
git config --global color.ui false
print_success "Git configured"

# Final disk space check
echo ""
print_info "Final disk space:"
df -h | grep -E '^/dev/'

ELAPSED=$(end_timer)
print_success "Environment setup completed in $ELAPSED"
