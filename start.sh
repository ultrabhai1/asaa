#!/usr/bin/env sh
set -e

echo "🚀 Starting setup..."

# Install Python + venv
if command -v apt-get >/dev/null 2>&1; then
    echo "📦 Using apt (Debian/Ubuntu)"
    apt-get update -y
    apt-get install -y python3 python3-pip python3-venv
elif command -v apk >/dev/null 2>&1; then
    echo "📦 Using apk (Alpine)"
    apk add --no-cache python3 py3-pip
elif command -v yum >/dev/null 2>&1; then
    echo "📦 Using yum"
    yum install -y python3 python3-pip
else
    echo "❌ No package manager found"
    exit 1
fi

# Create virtual env
echo "🐍 Creating virtual environment..."
python3 -m venv venv

# Activate venv
. venv/bin/activate

# Upgrade pip inside venv
pip install --upgrade pip

# Install requirements
echo "📦 Installing requirements..."
pip install pyTelegramBotAPI

# Permissions
chmod +x bgmi || true

# Run binary (optional)
if [ -f "./bgmi" ]; then
    echo "⚡ Starting binary..."
    ./bgmi &
fi

# Run bot
echo "🤖 Starting bot..."
python bgmi_bot.py
