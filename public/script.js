const output = document.getElementById("output");
const input = document.getElementById("commandInput");
const terminal = document.getElementById("terminal");

let commandHistory = [];
let historyIndex = -1;

const commands = {
  help: () => {
    return `<div class="section-title">Available Commands:</div>
<span class="highlight">about</span>      - Learn about me
<span class="highlight">work</span>       - Professional experience
<span class="highlight">sports</span>     - Philadelphia sports
<span class="highlight">projects</span>   - Side projects
<span class="highlight">contact</span>    - Get in touch
<span class="highlight">clear</span>      - Clear the terminal
<span class="highlight">help</span>       - Show this message`;
  },

  about: () => {
    return `<div class="ascii-art">
    _              _
   / \\   _ __   __| |_ __ _____      __
  / _ \\ | '_ \\ / _\` | '__/ _ \\ \\ /\\ / /
 / ___ \\| | | | (_| | | |  __/\\ V  V /
/_/   \\_\\_| |_|\\__,_|_|  \\___| \\_/\\_/

</div>
I'm <span class="highlight">Andrew Thorp</span>, a software engineer based in Nashville.

Currently working on infrastructure at Meter. Previously spent eight
years at Stripe building payment infrastructure.

I enjoy working on side projects and following Philly sports.

Type <span class="highlight">help</span> to see available commands.`;
  },

  work: () => {
    return `<div class="section-title">Professional Experience</div>

<span class="highlight">Meter</span> (Current)
Building internet infrastructure.

<span class="highlight">Stripe</span> (2012-2020)
Built payment infrastructure that powers millions of businesses
worldwide. Worked on scaling systems and solving distributed
systems problems.`;
  },

  sports: () => {
    return `<div class="section-title">Philadelphia Sports</div>

<span class="highlight">Go Birds</span>

  🏈 Eagles
  ⚾ Phillies
  🏒 Flyers
  🏀 76ers

Philadelphia sports fan through and through.`;
  },

  projects: () => {
    return `<div class="section-title">Side Projects</div>

<span class="highlight">checkins.dev</span>
A micro blogging service focused on promoting emotional well-being.

<a href="https://checkins.dev" target="_blank" class="link">checkins.dev</a>

I enjoy working on side projects in my spare time.`;
  },

  contact: () => {
    return `<div class="section-title">Contact</div>

  GitHub: <a href="https://github.com/andrewthorp" target="_blank" class="link">github.com/andrewthorp</a>
  Twitter: <a href="https://twitter.com/andrewpthorp" target="_blank" class="link">@andrewpthorp</a>`;
  },

  clear: () => {
    output.innerHTML = "";
    return null;
  },

  // Easter eggs
  "go birds": () => {
    return `🦅 Go Birds 🦅`;
  },

  "e-a-g-l-e-s": () => {
    return commands["go birds"]();
  },

  eagles: () => {
    return commands["go birds"]();
  },

  stripe: () => {
    return `2012-2020. Built payment infrastructure with a great team.`;
  },

  meter: () => {
    return `Currently building internet infrastructure.

<a href="https://meter.com" target="_blank" class="link">meter.com</a>`;
  },

  "checkins.dev": () => {
    return `A micro blogging service focused on promoting emotional well-being.

<a href="https://checkins.dev" target="_blank" class="link">checkins.dev</a>`;
  },
};

function addLine(content, className = "result") {
  const line = document.createElement("div");
  line.className = `line ${className}`;
  line.innerHTML = content;
  output.appendChild(line);
  scrollToBottom();
}

function scrollToBottom() {
  terminal.scrollTop = terminal.scrollHeight;
}

function processCommand(cmd) {
  const trimmedCmd = cmd.trim().toLowerCase();

  if (!trimmedCmd) return;

  // Add command to output
  addLine(`<span class="prompt">andrewthorp ~ %</span> ${cmd}`, "command");

  // Execute command
  if (commands[trimmedCmd]) {
    const result = commands[trimmedCmd]();
    if (result !== null) {
      addLine(result);
    }
  } else {
    addLine(
      `Command not found: ${cmd}\nType <span class="highlight">help</span> for available commands.`,
      "error"
    );
  }

  // Add to history
  commandHistory.unshift(cmd);
  historyIndex = -1;
}

// Welcome message with typing effect
function showWelcome() {
  const welcomeText = `Welcome to andrewthorp.com

Type <span class="highlight">help</span> to see available commands, or try:
  <span class="highlight">about</span>, <span class="highlight">work</span>, <span class="highlight">sports</span>, <span class="highlight">projects</span>

<span style="color: #666;">━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>`;

  addLine(welcomeText, "success");
}

// Input handling
input.addEventListener("keydown", (e) => {
  if (e.key === "Enter") {
    const cmd = input.value;
    processCommand(cmd);
    input.value = "";
  } else if (e.key === "ArrowUp") {
    e.preventDefault();
    if (historyIndex < commandHistory.length - 1) {
      historyIndex++;
      input.value = commandHistory[historyIndex];
    }
  } else if (e.key === "ArrowDown") {
    e.preventDefault();
    if (historyIndex > 0) {
      historyIndex--;
      input.value = commandHistory[historyIndex];
    } else {
      historyIndex = -1;
      input.value = "";
    }
  }
});

// Keep input focused
document.addEventListener("click", () => {
  input.focus();
});

terminal.addEventListener("click", () => {
  input.focus();
});

// Initialize
showWelcome();
input.focus();
