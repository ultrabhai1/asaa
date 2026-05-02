#!/data/data/com.termux/files/usr/bin/bash

echo "Starting binary..."

# Permission do
chmod +x bgmi

# Run karo (agar background me chalana hai)
./bgmi &

echo "Installing Python requirements..."
pip install pyTelegramBotAPI

echo "All set. Run: python bgmi_bot.py"
