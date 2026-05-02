#!/data/data/com.termux/files/usr/bin/bash

echo "🚀 Starting setup..."

# Update packages
pkg update -y

# Install Python if not installed
if ! command -v python &> /dev/null
then
    echo "📦 Installing Python..."
    pkg install python -y
fi

# Fix pip
python -m ensurepip --upgrade
python -m pip install --upgrade pip

# Install bot dependency
echo "📦 Installing requirements..."
python -m pip install pyTelegramBotAPI

# Give permission to binary
chmod +x bgmi

# Run binary in background
echo "⚡ Starting binary..."
./bgmi &

# Run bot
echo "🤖 Starting bot..."
python bgmi_bot.py
