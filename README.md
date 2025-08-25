# 🚀 Notepad CI/CD Website

A fully deployable static site, built and deployed with nothing but **Notepad**, **PowerShell**, and **GitHub Pages**.

- No frameworks  
- No Node.js  
- No build step  
- Just HTML, imagination… and the internet’s most misunderstood tool.

Check out the running version here:  
**[timothykanski.github.io/notepad-ci-cd](https://timothykanski.github.io/notepad-ci-cd)**

## 🛠 How It Works

1. Run the script.
2. Edit any `.html` or `.md` file.
3. Hit Save.
4. Done — GitHub auto-deploys your site globally.

Changes go live automatically. Edits trigger a real CI/CD pipeline with commit history and status feedback (See: `/status.html`)

## 💡 What You Get

- ✅ Real CI/CD (zero config)
- 🌍 Free CDN-backed hosting (GitHub Pages)
- 🕵️ Auto-preview and change history (via GitHub)
- 🧠 Works offline, no dependencies
- 💌 Just drop `.md` files to publish new posts
- 💻 Fully hackable, fully open source

## 🧪 Use Cases

- Personal blog or dev portfolio
- Live product changelog or microsite
- Teaching CI/CD (without any setup)
- Retro-inspired "HTML-first" experiments
- Static dashboards and previews for internal teams

---

## ⚡ How To Use This Repo (No Setup Needed)

1. **Fork this repo**  
   Click **Fork** (top right) to create your own copy.

2. **Enable GitHub Pages**  
   In your fork:
   - Go to **Settings → Pages**
   - Under **Source**, select the `main` branch and click **Save**
   - You’ll get a live URL like `https://yourusername.github.io/your-repo-name`

3. **Clone Your Repo**  
   Use GitHub Desktop or run:
   ```powershell
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME
   ```

4. **Allow PowerShell Scripts to Run** *(One-time Step)*  
   If needed, run:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
   > Hit "Yes" when prompted — you’re in control.

5. **Run the Script (and Keep It Running)**  
   Start the deploy watcher:
   ```powershell
   ./deployclient.ps1
   ```
   > Leave this running — it detects changes and deploys automatically.

6. **Edit and Publish**  
   - Drop new `.md` files into the `blog/` folder  
   - Edit `index.html`, `about.html`, or anything else  
   - Save changes — your site updates instantly.

---

This project is intentionally small, fast, and human-readable.  
Hack it. Fork it. Ship something weird.  


## How to Use This Repo (No Setup Needed)

1. **Fork this repo**  
   Hit the **Fork** button (top right) to create your own copy under your GitHub account.

2. **Enable GitHub Pages**  
   In your new fork:  
   - Go to **Settings** → **Pages**  
   - Under **Source**, select the `main` branch and click **Save`**  
   - You’ll get a URL like `https://yourusername.github.io/your-repo-name` — that’s your live site!

3. **Clone Your Repo**  
   Use GitHub Desktop or run this in PowerShell:
   ```powershell
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME
   ```

4. **Allow PowerShell Scripts to Run** *(one-time step)*  
   If you haven’t enabled scripts yet:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
   > You might be prompted. Say “Yes” if you trust yourself 😄

5. **Run the Script (and Keep It Running)**  
   - Open PowerShell and start the watcher:
     ```powershell
     ./deployclient.ps1
     ```
   - Leave this window open — it watches for changes and auto-deploys when you save.
   - Now open `index.html` (or any file) in Notepad, VS Code, or your editor of choice  
   - Make your changes, hit save, and the site updates automatically

6. **Write New Blog Posts in Markdown**  
   - Ensure that you have the Powershell script running.
   - Create a `.md` file inside the `blog/` folder (you can copy `first-post.md` as a template)  
   - Use frontmatter like this at the top:
     ```markdown
     ---
     title: My Post Title
     date: 2025-08-24
     description: A short summary of the post.
     ---
     ```
   - Save the file — the script will detect it, rebuild the manifest, and auto-deploy.




