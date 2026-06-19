# DemoBoost

A self-contained HTML **site rotator and demo analytics tool**, packaged as a Dataverse / Power Platform solution. Add a list of URLs, set an interval, and DemoBoost cycles through them in an embedded preview — capturing per-page load times, render times, and rotation analytics so you can hydrate caches and stress-test your demo path before going live.

> **Latest release: [v1.0.0.5](../../releases/latest)**

## Download

Install files are published as **[GitHub Release assets](../../releases/latest)**:

| Build | File | Use when |
|---|---|---|
| **Unmanaged** | `DemoBoost_1_0_0_5.zip` | Demo / POC environments · you want the web resource to stay editable |

## What's new in v1.0.0.5

- Expanded help overlay with full **export / import**, **analytics panel**, and **persistent site cache** documentation
- **Render Done** metric — measures when DOM activity and animations fully settle, complementing the standard `load` event
- **vs Baseline** comparison — current render time vs. the slowest seen this session, so you can see the warm-cache speedup
- Collapsible left (Sites) and right (Analytics) panels for a bigger live preview
- Drag-to-reorder rotation sequence and friendly **Site Name** labels

---

## What It Does

DemoBoost is a single HTML web resource (`new_DemoBoost`) that runs inside any Power Platform / Dynamics 365 environment. It:

- **Rotates** through a list of sites in an embedded preview on a configurable interval
- **Hydrates caches** ahead of a live demo so first-touch latency disappears
- **Captures analytics** — total rotations, session time, per-page view counts, load and render timings, and a "vs baseline" comparison
- **Exports and imports** demo sessions as JSON so a polished rotation can be shared with the team
- **Persists** site lists and last-loaded content in local storage between sessions

> **⚠️ IMPORTANT DISCLAIMER**
>
> This solution is provided **as-is** for demonstration and enablement purposes only. It is **not an official Microsoft product** and is **not supported by Microsoft Product Support Services**. By installing this solution, you acknowledge that:
>
> - This is a **community / field-developed solution** — not a 1st-party Microsoft offering
> - Any modifications, customizations, or deployments are **your organization's responsibility**
> - Microsoft makes **no warranties**, express or implied, regarding this solution's fitness for production use
> - You should **test thoroughly in a non-production environment** before deploying to production
> - **Support** for this solution is limited to the GitHub Issues tab on this repository
>
> **USE AT YOUR OWN RISK.**

---

## What Is Deployed

### Web Resource

| Resource | Logical Name | Description |
|----------|--------------|-------------|
| **DemoBoost** | `new_DemoBoost` | Single-file HTML site rotator with embedded CSS, JS, analytics, and help overlay |

### Solution Metadata

| Property | Value |
|----------|-------|
| Solution unique name | `DemoBoost` |
| Solution version | `1.0.0.5` |
| Solution type | Unmanaged |
| Custom tables | None |
| Custom option sets | None |
| Plug-ins / workflows | None |

There are **no custom Dataverse tables, columns, or processes** — uninstalling cleanly removes the single web resource and leaves no orphaned schema.

---

## Prerequisites

### Required

| Dependency | Notes |
|------------|-------|
| **Any Power Platform / Dataverse environment** | The solution installs as an unmanaged solution; no specific D365 first-party app required |
| **Modern browser** | The web resource uses standard HTML5, CSS, and JS (no external CDN dependencies) |

### NOT Required

- Field Service, Customer Service, Sales, or any other first-party D365 app
- Power BI
- Azure resources
- Internet connectivity beyond reaching the sites you choose to rotate

### Permissions

The installing user needs:
- **System Administrator** or **System Customizer** security role
- Access to **make.powerapps.com** for the target environment

End users need:
- Permission to view web resources in the target environment

---

## Installation

### Step 1: Download the solution

Get the latest ZIP from **[Releases](../../releases/latest)**:

| Build | File |
|---|---|
| **Unmanaged** | `DemoBoost_1_0_0_5.zip` |

### Step 2: Import

#### Option A: Power Apps maker portal

1. Download the ZIP from [Releases](../../releases/latest)
2. Go to [make.powerapps.com](https://make.powerapps.com) → **Solutions** → **Import solution**
3. Upload `DemoBoost_1_0_0_5.zip` → **Next** → **Import**
4. **Publish all customizations** when prompted

#### Option B: PAC CLI

```bash
# Authenticate
pac auth create --url https://your-org.crm.dynamics.com

# Import the solution
pac solution import --path DemoBoost_1_0_0_5.zip --publish-changes
```

### Step 3: Open DemoBoost

After import, open the `new_DemoBoost` web resource directly:

```
https://<your-org>.crm.dynamics.com/WebResources/new_DemoBoost
```

Or open it from inside the **DemoBoost** solution → **Web resources** → **DemoBoost** → **Preview**.

---

## How to Use

### 1. Add sites
- Paste a URL into **Add New Site** in the left Sites panel.
- Optionally give it a friendly **Site Name**.
- Click **➕ Add Site** (or press **Enter**) to save it.
- Use **Edit** / **Delete** on any item, or **🗑️ Clear All** to start fresh.
- Drag the **⋮⋮** handle to reorder the rotation sequence.

### 2. Start the rotator
- Set the **⏱️ Interval** (in seconds) — how long each site is displayed before advancing.
- Click **Apply**, then **▶ Start** to begin rotating.
- The header countdown shows time until the next rotation; the active site is highlighted in the list.
- Click **⏹ Stop** any time to pause.

### 3. Manual navigation
- While rotating, click any site's **Go** button to jump to it immediately. The rotator continues from there on the next tick.

### 4. Export & import
- Label the session with **Demo Name**.
- **📥 Export** downloads a `.json` file with your sites, name, and interval.
- **📤 Import** loads a previously exported file and restores the full configuration.

### 5. Analytics panel
- The right **📊 Analytics** panel tracks total rotations, session time, per-page view counts, and load timings.
- **Load Event** — time until the page's network resources finish loading.
- **Render Done** — time until all DOM activity and animations settle (a more complete "ready" signal).
- **vs Baseline** — compares the most recent render time against the slowest seen this session; a positive percentage means the page is now faster than its worst recorded run (i.e. the cache is hydrated).
- **🔄 Reset Analytics** clears all metrics.

### 6. Collapsing panels
- Click the thin vertical tab strip on the inner edge of either panel to collapse / expand it for a bigger live preview.

### 7. Persistent site cache
- Site lists, names, and the last-loaded content persist in browser local storage between sessions on the same machine and browser profile.

### 8. Tip
- For best results, paste the URL from a site's **"Share"** function — that usually gives you the canonical, cache-friendly URL.

---

## Repository Structure

```
demoboost/
  README.md
  src/
    new_DemoBoost.html              <- DemoBoost web resource source (single-file HTML)
  release/v1.0.0.5/
    DemoBoost_1_0_0_5.zip           <- Mirror of the published release asset

# Install zip is also published as a GitHub Release asset
# — see the Releases tab.
```

---

## How It Works (Technical)

- **Single-file HTML web resource** — all CSS, JS, and markup live in `new_DemoBoost.html`. No external CDN, framework, or build step.
- **Embedded preview** renders each rotated URL in an `<iframe>`. Sites that send `X-Frame-Options: DENY` or restrictive `Content-Security-Policy: frame-ancestors` headers cannot be embedded — that is a property of the target site, not DemoBoost.
- **Analytics** use the standard `performance` and `PerformanceObserver` APIs to capture load and render timings per URL.
- **Persistence** uses `localStorage` for site lists, session names, intervals, theme, and panel collapse state.
- **Export / Import** uses a plain JSON schema so configurations can be diffed, hand-edited, and shared.

---

## Contributing & Support

- **Issues / feature requests**: open a [GitHub Issue](../../issues).
- **Pull requests** welcome — keep the web resource a single self-contained HTML file with no external dependencies.

---

## License

This solution is provided as-is for demonstration and enablement. See the disclaimer above. No warranty, express or implied.
