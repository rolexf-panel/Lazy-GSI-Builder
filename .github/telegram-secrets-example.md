# Telegram Secrets Configuration

This file shows how to configure Telegram notification secrets in your repository.

## Required Secrets

Add these secrets in: **Settings** → **Secrets and variables** → **Actions**

### 1. TELEGRAM_BOT_TOKEN

**Name:** `TELEGRAM_BOT_TOKEN`

**Value:** Your bot token from @BotFather
```
Example: 1234567890:ABCdefGHIjklMNOpqrsTUVwxyz1234567890
```

**How to get:**
1. Open Telegram and find @BotFather
2. Send: `/newbot`
3. Follow the instructions
4. Copy the token provided

### 2. TELEGRAM_CHAT_ID

**Name:** `TELEGRAM_CHAT_ID`

**Value:** Your Telegram Chat ID
```
Example: 123456789
```

**How to get:**
1. Search @myidbot on Telegram
2. Send: `/start`
3. Copy the numeric ID shown

## Quick Setup Commands

```bash
# Step 1: Get bot token
Open Telegram → Search @BotFather → /newbot

# Step 2: Get chat ID  
Open Telegram → Search @myidbot → /start

# Step 3: Add to GitHub
Go to your repository → Settings → Secrets and variables → Actions
Click "New repository secret"

Secret 1:
  Name: TELEGRAM_BOT_TOKEN
  Value: <paste your bot token>

Secret 2:
  Name: TELEGRAM_CHAT_ID  
  Value: <paste your chat ID>
```

## Verification

After adding secrets:

1. **Start your bot:**
   - Find your bot on Telegram
   - Send: `/start`

2. **Test with a build:**
   - Run a workflow
   - You should receive a notification!

## Optional: Disable Notifications

If you don't want Telegram notifications:

**Option 1:** Don't add the secrets
- Workflow will automatically skip notification steps
- No error will occur

**Option 2:** Comment out in workflow
```yaml
# In build.yml, comment these lines:
# - name: Send Success Notification
#   if: success()
#   run: ...
```

## Troubleshooting

**No notifications received?**
1. Check secrets are added correctly
2. Make sure you started the bot with `/start`
3. Verify bot token is valid
4. Check workflow logs for errors

**Invalid bot token error?**
- Token should be in format: `NUMBER:STRING`
- Example: `123456789:ABCdefghIJKlmnOPQRstuVWXyz`
- No spaces or newlines

**Invalid chat ID error?**
- Should be a number (can be negative for groups)
- Example: `123456789` or `-123456789`
- No quotes or spaces

For detailed setup guide, see: [TELEGRAM_SETUP.md](../../TELEGRAM_SETUP.md)

## Security Notes

⚠️ **Never commit these values to git!**
- Always use GitHub Secrets
- Don't share your bot token publicly
- Keep your chat ID private

✅ **Best practices:**
- Use unique bot per repository
- Regularly check repository access
- Revoke and recreate if token is exposed
