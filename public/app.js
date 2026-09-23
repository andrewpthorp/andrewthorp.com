/* ===========================================================================
   andrewthorp.com — an interactive terminal
   Vanilla JS, no dependencies. All content lives in COMMANDS below.
   =========================================================================== */
(function () {
  "use strict";

  const $ = (sel) => document.querySelector(sel);
  const screen = $("#screen");
  const output = $("#output");
  const promptLine = $("#prompt-line");
  const chipsEl = $("#chips");
  const input = $("#cmd");
  const caret = $("#fakecaret");
  const themeToggle = $("#theme-toggle");

  const prefersReduced = window.matchMedia(
    "(prefers-reduced-motion: reduce)"
  ).matches;

  /* --- helpers ------------------------------------------------------------ */
  const esc = (s) =>
    s.replace(
      /[&<>"]/g,
      (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]
    );
  const link = (href, text, label) =>
    `<a href="${href}" target="_blank" rel="noopener noreferrer"${label ? ` class="${label}"` : ""}>${esc(text)}</a>`;

  function print(html, className) {
    const div = document.createElement("div");
    div.className = "line" + (className ? " " + className : "");
    div.innerHTML = html;
    output.appendChild(div);
    return div;
  }
  const spacer = () =>
    output.appendChild(
      Object.assign(document.createElement("div"), { className: "spacer" })
    );
  const scrollDown = () => {
    screen.scrollTop = screen.scrollHeight;
  };

  /* --- the content -------------------------------------------------------- */
  const NEOFETCH = () => {
    const info = [
      ["Role", "Software engineer"],
      ["Doing", "Building things on the internet"],
      ["Location", "Nashville, TN"],
      [
        "Now",
        `${link("https://meter.com", "Meter", "external")} — internet infrastructure`,
      ],
      [
        "Before",
        `${link("https://stripe.com", "Stripe", "external")} — payments (2012–2020)`,
      ],
    ]
      .map(
        ([label, val]) =>
          `<div class="row"><span class="label">${esc(label)}</span><span>${val}</span></div>`
      )
      .join("");
    return (
      `<div class="info">` +
      `<div class="row head"><span class="label"> </span><span>Andrew Thorp</span></div>` +
      info +
      `</div>`
    );
  };

  const COMMANDS = {
    help: {
      desc: "list everything you can do here",
      run() {
        const items = Object.entries(COMMANDS)
          .filter(([, c]) => !c.hidden)
          .map(
            ([name, c]) =>
              `  <span class="key">${name.padEnd(10)}</span><span class="dim">${c.desc}</span>`
          )
          .join("\n");
        print(`Available commands:\n${items}`, "");
        spacer();
        print(
          `<span class="dim">Tip: use <span class="key">Tab</span> to complete, <span class="key">↑ ↓</span> for history, or just tap a chip below.</span>`
        );
      },
    },

    whoami: {
      desc: "who is this guy",
      run() {
        print(
          `<span class="head">Andrew Thorp</span> — software engineer building things on the internet.`
        );
        print(
          `Currently in <span class="accent">Nashville, TN</span>. Previously a lot of places on the internet.`
        );
        spacer();
        print(
          `<span class="dim">Try <span class="key">work</span>, <span class="key">projects</span>, <span class="key">interests</span>, or <span class="key">links</span>.</span>`
        );
      },
    },

    work: {
      desc: "where I've spent my keystrokes",
      run() {
        print(`<span class="head">💼  work</span>`);
        spacer();
        print(
          `${link("https://meter.com", "Meter", "external")}  <span class="dim">· now</span>`
        );
        print(`   Building internet infrastructure.`);
        spacer();
        print(
          `${link("https://stripe.com", "Stripe", "external")}  <span class="dim">· 2012–2020</span>`
        );
        print(
          `   Built payment infrastructure for millions of businesses worldwide.`
        );
      },
    },

    projects: {
      desc: "things I'm building on the side",
      run() {
        print(`<span class="head">🚀  side projects</span>`);
        spacer();
        print(`${link("https://tryground.io", "tryground.io", "external")}`);
        print(`   AI-powered micro journaling for emotional well-being.`);
        print(`   <span class="muted">Reach out if you want to try it!</span>`);
      },
    },

    interests: {
      desc: "what I care about outside work",
      run() {
        print(`<span class="head">interests</span>`);
        spacer();
        const rows = [
          "Family, watching my kids grow up",
          "Philly sports (birds, phillies, sixers, flyers, in that order)",
          `${link("https://www.darkageofcamelot.com", "Dark Age of Camelot", "external")} still, after all these years`,
          "Exploring new technology (AI, blockchain, systems, infra, product)",
          "Gym, running, long walks",
        ];
        rows.forEach((r) => print(`  <span class="accent">▹</span> ${r}`));
      },
    },

    links: {
      desc: "find me elsewhere",
      run() {
        print(`<span class="head">🔗  links</span>`);
        spacer();
        print(
          `  GitHub      ${link("https://github.com/andrewpthorp", "github.com/andrewpthorp", "external")}`
        );
        print(
          `  X           ${link("https://x.com/andrewpthorp", "x.com/andrewpthorp", "external")}`
        );
        print(
          `  Instagram   ${link("https://instagram.com/andrewpthorp", "instagram.com/andrewpthorp", "external")}`
        );
      },
    },

    neofetch: {
      desc: "the little system-info flex",
      run() {
        print(NEOFETCH());
      },
    },

    clear: {
      desc: "wipe the screen",
      run() {
        output.innerHTML = "";
      },
    },

    fireworks: {
      desc: "🎆 set off some fireworks",
      run() {
        print(`<span class="accent">🎆  boom.</span>`);
        if (prefersReduced) return;
        launchFireworks();
      },
    },

    simplify: {
      desc: "strip it down to a bare, full-pane terminal",
      run() {
        const on = document.body.classList.toggle("simple");
        if (on) {
          print(
            `<span class="dim">Simplified — chrome off, full pane. Run <span class="key">simplify</span> again to bring the window back.</span>`
          );
        } else {
          print(`<span class="dim">Window restored.</span>`);
        }
        scrollDown();
      },
    },

    /* --- easter eggs (hidden from help) ---------------------------------- */
    gobirds: {
      hidden: true,
      desc: "",
      run() {
        print(`<span class="accent">🦅  E-A-G-L-E-S  EAGLES! 🦅</span>`);
        print(`<span class="dim">Fly, Eagles, fly.</span>`);
      },
    },
    daoc: {
      hidden: true,
      desc: "",
      run() {
        print(
          `<span class="head">Dark Age of Camelot</span> — Albion, Hibernia, Midgard.`
        );
        print(
          `<span class="dim">Relic raids at 2am. Some of the best years of gaming. ⚔️</span>`
        );
      },
    },
    sudo: {
      hidden: true,
      desc: "",
      run() {
        print(
          `<span class="dim">andrew is not in the sudoers file. This incident will be reported.</span>`
        );
        print(
          `<span class="muted">(nice try — but you don't need root to read a personal site 😄)</span>`
        );
      },
    },
    echo: {
      hidden: true,
      desc: "",
      run(args) {
        print(esc(args.join(" ")));
      },
    },
    exit: {
      hidden: true,
      desc: "",
      run() {
        print(`<span class="dim">There is no exit. Only more internet.</span>`);
      },
    },
  };

  /* aliases */
  const ALIASES = {
    ls: "help",
    "?": "help",
    about: "whoami",
    me: "whoami",
    contact: "links",
    social: "links",
    cls: "clear",
  };

  /* --- typing effect for the boot sequence -------------------------------- */
  function typeLine(html, { speed = 14, className = "" } = {}) {
    return new Promise((resolve) => {
      const el = print("", className);
      if (prefersReduced) {
        el.innerHTML = html;
        scrollDown();
        return resolve(el);
      }
      // Type the visible text but keep HTML tags intact.
      const tokens = html.match(/<[^>]+>|&[^;]+;|[\s\S]/g) || [];
      let i = 0;
      let acc = ""; // canonical source so far — keeps open tags open
      el.classList.add("type-caret");
      (function step() {
        if (i >= tokens.length) {
          el.classList.remove("type-caret");
          scrollDown();
          return resolve(el);
        }
        // append tags instantly, characters on a tick
        while (i < tokens.length && tokens[i][0] === "<") acc += tokens[i++];
        if (i < tokens.length) acc += tokens[i++];
        el.innerHTML = acc;
        scrollDown();
        setTimeout(step, speed + Math.random() * speed);
      })();
    });
  }

  const wait = (ms) =>
    new Promise((r) => setTimeout(r, prefersReduced ? 0 : ms));

  /* --- fireworks ---------------------------------------------------------- */
  function launchFireworks(count = 14) {
    const canvas = document.createElement("canvas");
    canvas.className = "fx-canvas";
    document.body.appendChild(canvas);
    const ctx = canvas.getContext("2d");

    let W, H, dpr;
    function resize() {
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      W = canvas.width = window.innerWidth * dpr;
      H = canvas.height = window.innerHeight * dpr;
      canvas.style.width = window.innerWidth + "px";
      canvas.style.height = window.innerHeight + "px";
    }
    resize();
    window.addEventListener("resize", resize);

    const rand = (a, b) => a + Math.random() * (b - a);
    const colors = ["#6ee7b7", "#7cc4ff", "#f7b955", "#ff8fd0", "#ff6b6b", "#b98cff", "#fff1a8"];
    const rockets = [];
    const sparks = [];
    let launched = 0;
    let lastLaunch = 0;
    let raf = 0;
    let running = true;

    function gravity() { return 0.05 * dpr; }

    function spawnRocket() {
      rockets.push({
        x: rand(W * 0.15, W * 0.85),
        y: H,
        vx: rand(-0.4, 0.4) * dpr,
        vy: rand(-13, -9) * dpr,
        color: colors[(Math.random() * colors.length) | 0],
      });
    }

    function explode(r) {
      const n = 60 + ((Math.random() * 40) | 0);
      for (let i = 0; i < n; i++) {
        const a = (Math.PI * 2 * i) / n;
        const sp = rand(1.5, 5) * dpr * rand(0.4, 1);
        sparks.push({
          x: r.x, y: r.y,
          vx: Math.cos(a) * sp,
          vy: Math.sin(a) * sp,
          life: 1, decay: rand(0.008, 0.02),
          color: r.color, size: rand(1.5, 3) * dpr,
        });
      }
    }

    function frame(ts) {
      if (!running) return;
      if (launched < count && ts - lastLaunch > rand(120, 260)) {
        spawnRocket();
        launched++;
        lastLaunch = ts;
      }
      ctx.clearRect(0, 0, W, H);
      ctx.globalCompositeOperation = "lighter";

      for (let i = rockets.length - 1; i >= 0; i--) {
        const r = rockets[i];
        r.x += r.vx;
        r.y += r.vy;
        r.vy += gravity();
        ctx.globalAlpha = 1;
        ctx.fillStyle = r.color;
        ctx.beginPath();
        ctx.arc(r.x, r.y, 2 * dpr, 0, 7);
        ctx.fill();
        if (r.vy >= 0) {
          explode(r);
          rockets.splice(i, 1);
        }
      }
      for (let i = sparks.length - 1; i >= 0; i--) {
        const s = sparks[i];
        s.x += s.vx;
        s.y += s.vy;
        s.vy += gravity() * 0.7;
        s.vx *= 0.99;
        s.life -= s.decay;
        if (s.life <= 0) {
          sparks.splice(i, 1);
          continue;
        }
        ctx.globalAlpha = Math.max(0, s.life);
        ctx.fillStyle = s.color;
        ctx.beginPath();
        ctx.arc(s.x, s.y, s.size, 0, 7);
        ctx.fill();
      }
      ctx.globalAlpha = 1;

      if (launched >= count && rockets.length === 0 && sparks.length === 0) {
        cleanup();
        return;
      }
      raf = requestAnimationFrame(frame);
    }

    function cleanup() {
      if (!running) return;
      running = false;
      cancelAnimationFrame(raf);
      window.removeEventListener("resize", resize);
      canvas.remove();
    }

    raf = requestAnimationFrame(frame);
    setTimeout(cleanup, 10000); // hard safety stop
  }

  async function boot() {
    print(NEOFETCH());
    scrollDown();
    await wait(120);
    spacer();
    await typeLine(
      `<span class="dim">Type <span class="key">help</span> to look around, or tap a suggestion below.</span>`,
      { speed: 10 }
    );
    spacer();
    revealPrompt();
  }

  /* --- suggestion chips --------------------------------------------------- */
  const CHIP_CMDS = [
    "whoami",
    "work",
    "projects",
    "interests",
    "links",
    "help",
  ];
  function renderChips() {
    chipsEl.innerHTML = CHIP_CMDS.map(
      (c) =>
        `<button class="chip" data-cmd="${c}"><span class="k">›</span> ${c}</button>`
    ).join("");
    chipsEl.hidden = false;
  }
  chipsEl.addEventListener("click", (e) => {
    const btn = e.target.closest(".chip");
    if (!btn) return;
    runInput(btn.dataset.cmd);
  });

  /* --- command execution -------------------------------------------------- */
  function echoCommand(raw) {
    print(
      `<span class="prompt-mini"><span class="p-user">andrewthorp@</span><span class="p-sep">:</span><span class="p-path">~</span> $</span> <span class="typed">${esc(raw)}</span>`,
      "cmd-echo"
    );
  }

  function execute(raw) {
    const trimmed = raw.trim();
    if (!trimmed) return;
    const [name, ...args] = trimmed.split(/\s+/);
    const key = ALIASES[name.toLowerCase()] || name.toLowerCase();
    const cmd = COMMANDS[key];
    if (cmd) {
      cmd.run(args);
    } else {
      print(
        `<span class="dim">command not found: <span class="key">${esc(name)}</span>. Try <span class="key">help</span>.</span>`
      );
    }
    spacer();
    scrollDown();
  }

  function runInput(raw) {
    echoCommand(raw);
    if (raw.trim()) {
      history.push(raw);
      histIdx = history.length;
    }
    execute(raw);
  }

  /* --- prompt + input handling ------------------------------------------- */
  const history = [];
  let histIdx = 0;

  function revealPrompt() {
    promptLine.hidden = false;
    renderChips();
    focusInput();
    syncCaret();
  }
  function focusInput() {
    input.focus({ preventScroll: true });
  }

  // Tap/click anywhere in the terminal focuses the input (except on links,
  // chips, or while selecting text). Using `click` and focusing *synchronously*
  // inside the gesture is what lets the mobile soft keyboard open.
  screen.addEventListener("click", (e) => {
    if (e.target.closest("a") || e.target.closest(".chip")) return;
    if (window.getSelection().toString()) return; // allow text selection
    focusInput();
  });

  input.addEventListener("input", syncCaret);
  input.addEventListener("focus", syncCaret);
  input.addEventListener("blur", () => (caret.style.opacity = "0.35"));

  // measure text width to position the block caret after the typed text
  const measurer = document.createElement("span");
  measurer.style.cssText =
    "position:absolute;visibility:hidden;white-space:pre;font:inherit;";
  function syncCaret() {
    caret.style.opacity = "";
    // match the input's real font so the caret lines up even when the
    // input is sized differently (e.g. 16px on mobile to avoid zoom).
    const cs = getComputedStyle(input);
    measurer.style.fontSize = cs.fontSize;
    measurer.style.fontFamily = cs.fontFamily;
    measurer.style.fontWeight = cs.fontWeight;
    measurer.style.letterSpacing = cs.letterSpacing;
    input.parentElement.appendChild(measurer);
    measurer.textContent = input.value.slice(
      0,
      input.selectionStart ?? input.value.length
    );
    caret.style.left =
      Math.min(measurer.offsetWidth, input.offsetWidth - 4) + "px";
  }
  document.addEventListener("selectionchange", () => {
    if (document.activeElement === input) syncCaret();
  });

  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const raw = input.value;
      input.value = "";
      runInput(raw);
      syncCaret();
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      if (histIdx > 0) {
        histIdx--;
        input.value = history[histIdx] || "";
        moveCaretEnd();
      }
    } else if (e.key === "ArrowDown") {
      e.preventDefault();
      if (histIdx < history.length) {
        histIdx++;
        input.value = history[histIdx] || "";
        moveCaretEnd();
      }
    } else if (e.key === "Tab") {
      e.preventDefault();
      autocomplete();
    } else if (e.key === "l" && (e.ctrlKey || e.metaKey)) {
      e.preventDefault();
      output.innerHTML = "";
    }
  });

  function moveCaretEnd() {
    requestAnimationFrame(() => {
      input.selectionStart = input.selectionEnd = input.value.length;
      syncCaret();
    });
  }

  function autocomplete() {
    const frag = input.value.trim().toLowerCase();
    if (!frag) return;
    const names = [
      ...Object.keys(COMMANDS).filter((n) => !COMMANDS[n].hidden),
      ...Object.keys(ALIASES),
    ];
    const matches = names.filter((n) => n.startsWith(frag));
    if (matches.length === 1) {
      input.value = matches[0] + " ";
      moveCaretEnd();
    } else if (matches.length > 1) {
      echoCommand(input.value);
      print(
        `<span class="dim">${matches.map((m) => `<span class="key">${m}</span>`).join("   ")}</span>`
      );
      spacer();
      scrollDown();
    }
  }

  /* --- theme -------------------------------------------------------------- */
  function applyTheme(t) {
    document.body.dataset.theme = t;
    try {
      localStorage.setItem("att-theme", t);
    } catch (_) {}
  }
  themeToggle.addEventListener("click", () => {
    applyTheme(document.body.dataset.theme === "light" ? "dark" : "light");
    focusInput();
  });
  try {
    const saved = localStorage.getItem("att-theme");
    if (saved) applyTheme(saved);
  } catch (_) {}

  /* --- go ----------------------------------------------------------------- */
  boot();
})();
