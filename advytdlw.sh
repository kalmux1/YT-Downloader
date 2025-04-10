#!/bin/bash

# === CONFIG ===
OUTPUT_DIR="$HOME/Downloads"
COOKIES_FILE="./cookies.txt"  # optional

# === CHECK DEPENDENCIES ===
command -v yt-dlp >/dev/null 2>&1 || { echo "❌ yt-dlp not found. Install with: pip install yt-dlp"; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo "❌ ffmpeg not found. Install with: sudo apt install ffmpeg"; exit 1; }

# === INTRO ===
echo "🎞️ YouTube Video Downloader with Resolution Selector"
echo "====================================================="
echo "📍 Downloads go to: $OUTPUT_DIR"
echo ""

# === GET URL ===
read -p "📎 Paste YouTube Video URL: " VIDEO_URL
if [[ -z "$VIDEO_URL" ]]; then
    echo "❌ No URL entered. Exiting."
    exit 1
fi

# === GET RESOLUTION ===
echo ""
echo "📐 Choose resolution:"
echo "1. 360p"
echo "2. 480p"
echo "3. 720p (HD)"
echo "4. 1080p (Full HD)"
echo "5. 1440p (2K)"
echo "6. 2160p (4K)"
read -p "➡️  Your choice (1-6): " RES_CHOICE

# Map choice to actual resolution
case $RES_CHOICE in
    1) RES="360" ;;
    2) RES="480" ;;
    3) RES="720" ;;
    4) RES="1080" ;;
    5) RES="1440" ;;
    6) RES="2160" ;;
    *) echo "❌ Invalid choice. Defaulting to 1080p"; RES="1080" ;;
esac

# === COOKIES ===
echo ""
echo "🔐 Is this video age-restricted, private, or Premium-only?"
echo "1. No (Public/Unlisted)"
echo "2. Yes (Use cookies.txt)"
read -p "➡️  Choose an option (1 or 2): " OPTION
echo ""

# === DOWNLOAD ===
echo "📥 Starting download in ${RES}p..."

if [[ "$OPTION" == "2" ]]; then
    if [[ ! -f "$COOKIES_FILE" ]]; then
        echo "❌ cookies.txt not found! Export it from your browser using a cookies.txt extension."
        exit 1
    fi
    yt-dlp --cookies "$COOKIES_FILE" \
        -f "bestvideo[height=$RES]+bestaudio/best" \
        -o "$OUTPUT_DIR/%(title)s.%(ext)s" \
        "$VIDEO_URL"
else
    yt-dlp \
        -f "bestvideo[height=$RES]+bestaudio/best" \
        -o "$OUTPUT_DIR/%(title)s.%(ext)s" \
        "$VIDEO_URL"
fi

echo ""
echo "✅ Download complete! Check your Downloads folder."
