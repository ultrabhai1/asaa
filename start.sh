#!/usr/bin/env sh
set -e

echo "🚀 Starting setup..."

# ---- Install Python (based on distro) ----
if command -v apt-get >/dev/null 2>&1; then
    echo "📦 Using apt (Debian/Ubuntu)"
    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip ca-certificates
elif command -v apk >/dev/null 2>&1; then
    echo "📦 Using apk (Alpine)"
    apk add --no-cache python3 py3-pip ca-certificates
elif command -v yum >/dev/null 2>&1; then
    echo "📦 Using yum (CentOS/RHEL)"
    yum install -y python3 python3-pip ca-certificates
else
    echo "❌ No supported package manager found (apt/apk/yum)."
    exit 1
fi

# ---- Ensure python command exists ----
if ! command -v python >/dev/null 2>&1; then
    ln -sf "$(command -v python3)" /usr/bin/python || true
fi

echo "🐍 Python version:"
python -V || python3 -V

# ---- Upgrade pip safely ----
python -m ensurepip --upgrade || true
python -m pip install --upgrade pip

# ---- Install requirements ----
echo "📦 Installing requirements..."
python -m pip install --no-cache-dir pyTelegramBotAPI

# ---- Permissions (only if file exists) ----
if [ -f "./bgmi" ]; then
    chmod +x ./bgmi
fi

# ---- Start bot ----
echo "🤖 Starting bot..."
exec python bgmi_bot.py
