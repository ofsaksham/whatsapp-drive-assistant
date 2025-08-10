# Detailed Setup Guide - WhatsApp-Driven Google Drive Assistant

This guide provides step-by-step instructions for setting up the WhatsApp-Driven Google Drive Assistant using n8n, Docker, Twilio, and Google Drive API.

## 📋 Prerequisites

Before starting, ensure you have the following installed:

### 1. Docker Desktop
- Download from [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Install and start Docker Desktop
- Verify installation: `docker --version`

### 2. ngrok CLI
- Download from [ngrok](https://ngrok.com/download)
- Extract and add to PATH
- Verify installation: `ngrok version`

### 3. Required Accounts
- **Twilio Account**: [Sign up for free trial](https://www.twilio.com/try-twilio)
- **Google Cloud Project**: [Create project](https://console.cloud.google.com/)
- **OpenAI Account**: [Sign up](https://platform.openai.com/) (optional)

## 🔧 Step-by-Step Setup

### Step 1: Google Cloud Setup

#### 1.1 Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a project" → "New Project"
3. Name your project (e.g., "WhatsApp Drive Assistant")
4. Click "Create"

#### 1.2 Enable Google Drive API
1. In your project, go to "APIs & Services" → "Library"
2. Search for "Google Drive API"
3. Click on it and press "Enable"

#### 1.3 Create OAuth 2.0 Credentials
1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth 2.0 Client IDs"
3. Choose "Desktop application"
4. Name it "n8n Drive Assistant"
5. Click "Create"
6. Download the JSON file and note the Client ID and Client Secret

#### 1.4 Configure OAuth Consent Screen
1. Go to "APIs & Services" → "OAuth consent screen"
2. Choose "External" user type
3. Fill in required fields:
   - App name: "WhatsApp Drive Assistant"
   - User support email: Your email
   - Developer contact information: Your email
4. Add scopes:
   - `https://www.googleapis.com/auth/drive`
   - `https://www.googleapis.com/auth/drive.file`
5. Add test users (your email)
6. Save and continue

### Step 2: Twilio Setup

#### 2.1 Create Twilio Account
1. Go to [Twilio Console](https://console.twilio.com/)
2. Sign up for a free trial
3. Note your Account SID and Auth Token

#### 2.2 Configure WhatsApp Sandbox
1. In Twilio Console, go to "Messaging" → "Try it out"
2. Click "Send a WhatsApp message"
3. Note your WhatsApp number: `+14155238886`
4. Follow the instructions to join the sandbox from your phone

### Step 3: Environment Configuration

#### 3.1 Create Environment File
1. Copy `env.example` to `.env`
2. Edit `.env` with your credentials:

```env
# Twilio Configuration
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
TWILIO_WHATSAPP_NUMBER=+14155238886

# Google Drive Configuration
GOOGLE_DRIVE_CLIENT_ID=your_google_client_id
GOOGLE_DRIVE_CLIENT_SECRET=your_google_client_secret
GOOGLE_DRIVE_REFRESH_TOKEN=your_google_refresh_token

# OpenAI Configuration (Optional)
OPENAI_API_KEY=your_openai_api_key
```

#### 3.2 Get Google Drive Refresh Token
1. Use the Google OAuth Playground: [OAuth 2.0 Playground](https://developers.google.com/oauthplayground/)
2. Click the settings icon (⚙️)
3. Check "Use your own OAuth credentials"
4. Enter your Client ID and Client Secret
5. Close settings
6. Select "Google Drive API v3" → "https://www.googleapis.com/auth/drive"
7. Click "Authorize APIs"
8. Sign in with your Google account
9. Click "Exchange authorization code for tokens"
10. Copy the "Refresh token" value to your `.env` file

### Step 4: Start the Application

#### 4.1 Quick Setup (Recommended)
Run the automated setup script:
```powershell
.\scripts\setup.ps1
```

#### 4.2 Manual Setup
If you prefer manual setup:

1. **Start n8n Container**:
```bash
docker run -it --rm --name n8n-whatsapp-drive \
  -p 5678:5678 \
  -v ${PWD}/.n8n:/home/node/.n8n \
  --env-file .env \
  n8nio/n8n
```

2. **Start ngrok Tunnel**:
```bash
ngrok http 5678
```

### Step 5: Configure n8n Workflow

#### 5.1 Import Workflow
1. Open n8n at `http://localhost:5678`
2. Click "Import from file"
3. Select `workflow.json` from this repository
4. Click "Import"

#### 5.2 Configure Credentials
1. In the workflow, click on each node that needs credentials
2. Configure Google Drive credentials:
   - Click "Create New Credential"
   - Choose "Google Drive OAuth2 API"
   - Enter your Client ID and Client Secret
   - Authorize with your Google account

3. Configure Twilio credentials:
   - Click "Create New Credential"
   - Choose "Twilio Account"
   - Enter your Account SID and Auth Token

#### 5.3 Activate Workflow
1. Click "Active" toggle to enable the workflow
2. Click "Execute workflow" to register the webhook

### Step 6: Configure Twilio Webhook

#### 6.1 Get ngrok URL
1. Open ngrok dashboard: `http://127.0.0.1:4040`
2. Copy your public URL (e.g., `https://abc123.ngrok-free.app`)

#### 6.2 Update Twilio Webhook
1. Go to [Twilio Console](https://console.twilio.com/)
2. Navigate to "Messaging" → "Try it out" → "Send a WhatsApp message"
3. In "Sandbox settings" tab:
   - Set "When a message comes in" to: `https://your-ngrok-url.ngrok-free.app/webhook/whatsapp-webhook`
   - Set HTTP Method to "POST"
   - Click "Save"

## 🧪 Testing the Setup

### Test Commands
Send these messages to `+14155238886`:

1. **HELP** - Should return available commands
2. **LIST** - Should list files in your Google Drive
3. **LIST /folder** - Should list files in specific folder
4. **SUMMARY /document.pdf** - Should return document summary

### Monitor Activity
- **n8n Logs**: Check execution logs in n8n interface
- **ngrok Dashboard**: Monitor incoming requests at `http://127.0.0.1:4040`
- **Twilio Console**: Check message delivery status

## 🔒 Security Considerations

### Environment Variables
- Never commit `.env` file to version control
- Use strong, unique credentials
- Rotate credentials regularly

### Webhook Security
- ngrok provides HTTPS encryption
- Consider adding webhook signature verification
- Monitor for unauthorized access

### Google Drive Permissions
- Use minimal required scopes
- Regularly review app permissions
- Consider using service accounts for production

## 🚨 Troubleshooting

### Common Issues

#### "Docker Engine stopped"
- Start Docker Desktop application
- Wait for Docker to fully initialize
- Check Docker Desktop status

#### "Webhook not registered"
- Click "Execute workflow" in n8n
- Ensure ngrok is running
- Check webhook URL in Twilio console

#### "Twilio daily limit exceeded"
- Free trial limit: 9 messages/day
- Wait until next day for reset
- Upgrade to paid plan for higher limits

#### "OpenAI quota exceeded"
- Free tier has usage limits
- Use mock summary node (already implemented)
- Upgrade OpenAI plan or wait for quota reset

#### "File not found"
- Verify file paths in Google Drive
- Check Google Drive permissions
- Ensure file IDs are correct in workflow

### Debug Steps
1. Check n8n execution logs
2. Verify all credentials are configured
3. Test individual nodes in n8n
4. Monitor ngrok tunnel status
5. Check Twilio console for errors

## 📚 Additional Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Twilio WhatsApp API](https://www.twilio.com/docs/whatsapp)
- [Google Drive API](https://developers.google.com/drive/api)
- [ngrok Documentation](https://ngrok.com/docs)

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review n8n execution logs
3. Verify all credentials and configurations
4. Create an issue in the repository

---

**Note**: This setup guide is designed for development and testing purposes. For production deployment, consider additional security measures and paid service plans.
