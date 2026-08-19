# Olatoye Academy App — Setup Guide

## Getting the AI features working (10 minutes, all free)

### Step 1 — Get a free Groq API key
1. Go to **console.groq.com**
2. Sign up free (no credit card needed)
3. Go to API Keys → Create API Key
4. Copy the key (starts with `gsk_...`)

### Step 2 — Add your key to the app
1. Open `index.html` in any text editor
2. Find this line near the top of the `<script>` section:
   ```
   const GROQ_KEY = 'YOUR_GROQ_API_KEY';
   ```
3. Replace `YOUR_GROQ_API_KEY` with your actual key
4. Save the file

### Step 3 — Push to GitHub
```bash
git add index.html
git commit -m "Add Groq API key"
git push
```

### What each feature uses
| Feature | Powered by | Cost |
|---|---|---|
| Search our knowledge base | Fuse.js (in-browser, instant) | Free forever |
| Pressure-test a decision | Groq free tier (Llama 3.1 8B) | Free (14,000 tokens/min) |
| Build a plan | Groq free tier | Free |
| Find external resources | Groq free tier | Free |
| Session logging | Browser storage | Free |

### Groq free tier limits
- 14,400 requests per day
- 14,000 tokens per minute
- More than enough for a family app

### No Anthropic credits used
The app uses your own knowledge corpus (30 scholar profiles baked in) for instant search,
and Groq's free LLM tier for AI reasoning. Zero Anthropic API calls.
