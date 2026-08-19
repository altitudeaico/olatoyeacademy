/**
 * Olatoye Academy — Cloudflare Worker API Proxy
 *
 * Sits between the browser app and api.anthropic.com
 * Handles CORS so GitHub Pages can call Claude directly.
 *
 * DEPLOY:
 * 1. Go to https://workers.cloudflare.com — sign up free
 * 2. Create a new Worker, paste this whole file
 * 3. Go to Worker Settings → Variables → add secret:
 *    Name: ANTHROPIC_API_KEY   Value: your Anthropic API key (from console.anthropic.com)
 * 4. Deploy — copy your Worker URL (e.g. https://oa-proxy.YOUR-NAME.workers.dev)
 * 5. In index.html, replace PROXY_URL with your Worker URL
 *
 * COST: Free tier = 100,000 requests/day. More than enough.
 */

const ANTHROPIC_URL = 'https://api.anthropic.com/v1/messages';

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

export default {
  async fetch(request, env) {
    // Handle preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: CORS });
    }

    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405, headers: CORS });
    }

    try {
      const body = await request.json();

      const response = await fetch(ANTHROPIC_URL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': env.ANTHROPIC_API_KEY,
          'anthropic-version': '2023-06-01',
        },
        body: JSON.stringify({
          model: body.model || 'claude-sonnet-4-6',
          max_tokens: body.max_tokens || 1000,
          messages: body.messages,
        }),
      });

      const data = await response.json();
      return new Response(JSON.stringify(data), {
        headers: { 'Content-Type': 'application/json', ...CORS },
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: err.message }), {
        status: 500,
        headers: { 'Content-Type': 'application/json', ...CORS },
      });
    }
  },
};
