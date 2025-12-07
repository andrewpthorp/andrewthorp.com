# andrewthorp.com

My personal website, built with a terminal-inspired interface.

## About

A simple, interactive terminal-style website that tells my story. Built with vanilla JavaScript, no frameworks needed.

## Features

- Interactive terminal interface with command history
- Responsive design (works great on mobile and desktop)
- Easter eggs for Philly sports fans
- Zero dependencies on the frontend
- Lightweight and fast

## Local Development

```bash
npm install
npm start
```

Visit `http://localhost:3000`

## Deployment

This site is designed to deploy easily to fly.io:

```bash
# Install flyctl if you haven't already
# https://fly.io/docs/getting-started/installing-flyctl/

# Login to fly.io
fly auth login

# Launch the app (first time only)
fly launch

# Deploy updates
fly deploy
```

## Commands

Try these commands on the site:
- `help` - See all available commands
- `about` - Learn about me
- `work` - My professional journey
- `sports` - Go Birds!
- `projects` - Side projects
- `contact` - Get in touch

## Tech Stack

- Node.js + Express
- Vanilla JavaScript
- CSS with gradients and animations
- Deployed on fly.io

## License

MIT License - Copyright (c) 2025 Andrew Thorp
