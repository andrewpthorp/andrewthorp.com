# andrewthorp.com

My personal website — reimagined as an interactive terminal. Type a command to look around.

## About

Instead of a static page, the site boots like a shell: a typed welcome, a `neofetch`-style
info card, and a live prompt. Visitors explore by running commands (`work`, `projects`,
`interests`, `links`) — with command history, tab-completion, a light/dark toggle, tappable
suggestion chips for mobile, and a couple of easter eggs. Pure vanilla HTML/CSS/JS, no frameworks.

## Commands

- `help` — list everything you can do
- `whoami` — the short intro
- `work` — Meter (now), Stripe (2012–2020)
- `projects` — tryground.io
- `interests` — family, Philly sports, DAoC, building things, outdoors, systems
- `links` — GitHub, X, Instagram
- `neofetch` — the little system-info flex
- `fireworks` — set off fireworks from the bottom of the screen
- `simplify` — strip the UI down to a bare, full-pane terminal (run again to restore)
- `clear` — wipe the screen
- ...and a few hidden ones. Poke around.

Keyboard: `Tab` completes · `↑`/`↓` walk history · `Ctrl/⌘+L` clears.

## Local Development

```bash
npm install
npm start
```

Visit `http://localhost:3000` (or `PORT=8080 npm start` for a different port).

It's a static site — Express (`server.js`) just serves the `public/` folder. You can also
open `public/index.html` directly, or serve it with any static file server.

## Deployment

Deployed to fly.io. CI (`.github/workflows/fly-deploy.yml`) deploys on push to `master`.

```bash
# https://fly.io/docs/flyctl/install/
fly auth login
fly deploy        # first time: fly launch
```

## Tech Stack

- Vanilla HTML / CSS / JavaScript — no frameworks, no build step
- Node.js + Express (static file server only)
- Deployed on fly.io

## License

MIT License — Copyright (c) 2025 Andrew Thorp
