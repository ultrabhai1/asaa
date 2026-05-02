#!/data/data/com.termux/files/usr/bin/bash
echo "Compiling C flood tool..."
gcc -O3 -pthread -o udp_flood udp_flood.c
if [ $? -eq 0 ]; then
    echo "✅ Compilation success"
else
    echo "❌ Compilation failed. Install gcc: pkg install gcc"
    exit 1
fi

echo "Installing Python requirements..."
pip install pyTelegramBotAPI

echo "All set. Run: python bgmi_bot.py"
