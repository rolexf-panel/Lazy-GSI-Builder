# Telegram Notifications - Quick Start Card

⚡ **Get build notifications in 5 minutes!**

## 1️⃣ Create Bot (2 minutes)

```
1. Open Telegram
2. Search: @BotFather
3. Send: /newbot
4. Name: GSI Build Notifier
5. Username: YourName_GSI_Bot
6. Copy the TOKEN (long string)
```

## 2️⃣ Get Chat ID (1 minute)

```
1. Open Telegram
2. Search: @myidbot
3. Send: /start
4. Copy your ID (numbers only)
```

## 3️⃣ Add to GitHub (2 minutes)

```
1. Go to: Your Repository → Settings → Secrets → Actions
2. Click: New repository secret

Secret #1:
  Name:  TELEGRAM_BOT_TOKEN
  Value: [paste token from step 1]
  
Secret #2:
  Name:  TELEGRAM_CHAT_ID
  Value: [paste ID from step 2]
```

## 4️⃣ Start Bot (30 seconds)

```
1. Find your bot on Telegram
2. Send: /start
3. Done! ✅
```

## 5️⃣ Test It!

```
1. Run a workflow
2. Check Telegram for notification! 📱
```

---

## Example Secrets

**TELEGRAM_BOT_TOKEN:**
```
1234567890:ABCdefGHIjklMNOpqrsTUVwxyz1234567890
```

**TELEGRAM_CHAT_ID:**
```
123456789
```

---

## What You'll Get

### ✅ Success Notification
```
✅ Build Completed Successfully!

📱 ROM: LineageOS
🔖 Branch: lineage-23.0
⏱️ Build Time: 1h 45m
🔗 Download Link
```

### ❌ Failure Notification
```
❌ Build Failed

📱 ROM: crDroid
⏱️ Failed After: 35m
🔍 Error details included
📄 Error log file attached
🔗 View Workflow
```

---

## Troubleshooting One-Liners

**No notification?**
→ Did you send `/start` to your bot?

**"Invalid token"?**
→ Copy the FULL token from BotFather (it's long!)

**"Can't send message"?**
→ Start the bot first with `/start`

**Don't want notifications?**
→ Simply don't add the secrets. No errors will occur!

---

## Need More Help?

📖 **Full guide:** [TELEGRAM_SETUP.md](TELEGRAM_SETUP.md)

**Quick test your setup:**
```bash
curl "https://api.telegram.org/botYOUR_TOKEN/sendMessage?chat_id=YOUR_CHAT_ID&text=Test"
```
Replace YOUR_TOKEN and YOUR_CHAT_ID with your values.

If you receive "Test" on Telegram → ✅ Working!

---

**That's it! Simple, right?** 🚀
