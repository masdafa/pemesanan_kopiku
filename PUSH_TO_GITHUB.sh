#!/bin/bash
# 🚀 PUSH_TO_GITHUB.sh
# Quick script untuk push Kopi Kang Dafa ke GitHub

# ⚠️  SEBELUM MENJALANKAN SCRIPT INI:
# 1. Buat repository baru di https://github.com/new
# 2. Copy repository URL
# 3. Edit REPO_URL di bawah dengan URL Anda

REPO_URL="https://github.com/YOUR_USERNAME/pemesanan_kopiku.git"
PROJECT_NAME="Kopi Kang Dafa"
PROJECT_DIR="."

echo "🚀 Starting push to GitHub for: $PROJECT_NAME"
echo ""

# Step 1: Verify git status
echo "📋 Checking git status..."
git status
echo ""

# Step 2: Add remote if not exists
echo "🔗 Setting up remote repository..."
git remote remove origin 2>/dev/null || true
git remote add origin $REPO_URL

# Step 3: Rename branch to main (GitHub standard)
echo "🔄 Renaming branch to 'main'..."
git branch -M main

# Step 4: Push to GitHub
echo "📤 Pushing code to GitHub..."
git push -u origin main

# Step 5: Verify
echo ""
echo "✅ Done! Check your repository at:"
echo "   $REPO_URL"
echo ""
echo "🎉 Project '$PROJECT_NAME' is now on GitHub!"
