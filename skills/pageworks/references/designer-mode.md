# Designer Mode — Custom Themes, Styling Tokens & CSS Personalization

Use this when: Personalizing wiki branding, configuring custom CSS stylesheets, selecting color palettes, or applying design presets (Stripe Indigo, Nordic Slate, Minimalist Monochrome).

---

## 1. The Designer Architecture

Pageworks treats documentation as a branded product. Designer Mode provides customizable styling tokens across both Docs-as-Code engines:

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
/* Pageworks Designer Mode — MkDocs Material */
:root {
  /* Brand Palettes */
  --md-primary-fg-color:        #4f46e5;
  --md-primary-fg-color--light:  #6366f1;
  --md-primary-fg-color--dark:   #4338ca;
  --md-accent-fg-color:         #06b6d4;

  /* Typography */
  --md-text-font:               'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --md-code-font:               'JetBrains Mono', 'Fira Code', monospace;
}

[data-md-color-scheme="slate"] {
  --md-primary-fg-color:        #6366f1;
  --md-default-bg-color:        #0f172a;
  --md-default-fg-color:        #f8fafc;
}

/* Polished Card Radii & Admonitions */
.md-typeset pre > code {
  border-radius: 8px;
  font-size: 0.88em;
}

.md-typeset .admonition {
  border-radius: 8px;
  box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1);
}
```

---

## 4. Docusaurus v3+ Customization (`src/css/custom.css`)

```css
/* Pageworks Designer Mode — Docusaurus */
:root {
  --ifm-color-primary: #4f46e5;
  --ifm-color-primary-dark: #4338ca;
  --ifm-color-primary-light: #6366f1;
  --ifm-font-family-base: 'Inter', system-ui, sans-serif;
  --ifm-code-font-size: 92%;
}

[data-theme='dark'] {
  --ifm-color-primary: #6366f1;
  --ifm-background-color: #0f172a;
  --ifm-background-surface-color: #1e293b;
}
```

---

## 5. Applying Custom Presets

1. Run `pageworks export mkdocs` or `pageworks export docusaurus`.
2. Edit `docs/stylesheets/custom.css` (or `src/css/custom.css`) to match your company brand guidelines.
3. Pin manual edits by adding `# pageworks: do-not-overwrite` as line 1.
