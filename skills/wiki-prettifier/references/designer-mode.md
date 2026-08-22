# Designer Mode — Custom Themes, Styling Tokens & CSS Personalization

Use this when: Personalizing wiki branding, styling Markdown portals, selecting color palettes, or applying design presets (Stripe Indigo, Nordic Slate, Minimalist Monochrome).

---

## 1. The Designer Architecture

`wiki-prettifier` formats documentation with modern visual design tokens:

```
docs.yaml (manifest palette)
  ├── MkDocs Material    ──► docs/stylesheets/custom.css (CSS Custom Properties)
  └── Docusaurus (v3+)   ──► src/css/custom.css (Infima Design Variables)
```

---

## 2. Pre-Crafted Design Presets

| Preset Name | Target Vibe | Primary Brand Accent | Dark Mode Background |
|---|---|---|---|
| **Stripe Indigo** (Default) | Polished fintech & SaaS portal | `#4f46e5` (Indigo) | `#0f172a` (Slate 900) |
| **Nordic Cyan** | High-tech developer platform | `#06b6d4` (Cyan) | `#030712` (Zinc 950) |
| **Minimalist Slate** | Clean, content-first enterprise wiki | `#475569` (Slate) | `#18181b` (Zinc 900) |
| **Emerald Terminal** | DevOps & infrastructure runbooks | `#059669` (Emerald) | `#052e16` (Deep Forest) |

---

## 3. MkDocs Material Customization (`docs/stylesheets/custom.css`)

```css
:root {
  --md-primary-fg-color:        #4f46e5;
  --md-primary-fg-color--light:  #6366f1;
  --md-primary-fg-color--dark:   #4338ca;
  --md-accent-fg-color:         #06b6d4;
  --md-text-font:               'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --md-code-font:               'JetBrains Mono', 'Fira Code', monospace;
}

[data-md-color-scheme="slate"] {
  --md-primary-fg-color:        #6366f1;
  --md-default-bg-color:        #0f172a;
  --md-default-fg-color:        #f8fafc;
}
```
