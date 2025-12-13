---
applyTo: "**/*.{html,htm,jsx,tsx,vue,svelte}"
---

# WCAG 2.2 Level AA - Markup-Specific Standards

> **Purpose:** Enforce accessibility compliance in HTML, JSX, and component template files.

## Markup Review Rules

### Images and Media
Flag when:
- `<img>` lacks `alt` attribute
- `<img alt="image">`, `<img alt="photo">`, `<img alt="picture">` (non-descriptive)
- `<img alt="...">` matches or contains the filename
- `<svg>` used for meaningful content lacks `role="img"` and accessible name
- `<video>` lacks `<track kind="captions">`
- `<audio>` lacks transcript reference

```jsx
// ✅ Correct
<img src="chart.png" alt="Sales increased 25% in Q3" />
<img src="decoration.png" alt="" />
<svg role="img" aria-label="Warning icon"><path .../></svg>

// ❌ Flag these
<img src="chart.png" />
<img src="photo.jpg" alt="image" />
<svg><path .../></svg>  // Missing role and label
```

### Form Controls
Flag when:
- `<input>`, `<select>`, `<textarea>` lacks associated `<label>` or `aria-label`
- `<label>` lacks `htmlFor`/`for` attribute matching input `id`
- `placeholder` used as only label
- Required fields lack `required` or `aria-required="true"`
- Inputs lack appropriate `autocomplete` for user data
- Error messages lack `aria-describedby` association

```jsx
// ✅ Correct
<label htmlFor="email">Email</label>
<input type="email" id="email" required autocomplete="email" />

// ❌ Flag these
<input type="email" placeholder="Email" />
<label>Email</label><input type="email" />  // Not associated
```

### Interactive Elements
Flag when:
- `onClick` on non-interactive element (`div`, `span`) without `role`, `tabIndex`, `onKeyDown`
- `<a>` without `href` used as button (use `<button>` instead)
- `<a href="#">` or `<a href="javascript:void(0)">`
- Button/link has no accessible name (empty or icon-only without label)
- `tabIndex` greater than 0

```jsx
// ✅ Correct
<button onClick={handleClick}>Submit</button>
<button aria-label="Close" onClick={handleClose}><CloseIcon /></button>
<div role="button" tabIndex={0} onClick={handler} onKeyDown={keyHandler}>
  Custom Button
</div>

// ❌ Flag these
<div onClick={handleClick}>Click me</div>
<a onClick={handleClick}>Submit</a>
<span onClick={toggle}>Toggle</span>
<button><Icon /></button>  // No accessible name
```

### Focus Management
Flag when:
- CSS contains `outline: none` or `outline: 0` without replacement focus style
- `tabIndex="-1"` on naturally focusable elements without justification
- Modal/dialog lacks focus trap implementation
- Dynamic content insertion without focus management

```jsx
// ✅ Correct - Custom focus indicator
<button className="focus:ring-2 focus:ring-blue-500 focus:outline-none">

// ❌ Flag this
<style>
  button:focus { outline: none; }
</style>
```

### Structure and Semantics
Flag when:
- Page lacks `<main>` element
- Multiple `<main>` elements (should be single)
- `<nav>` lacks `aria-label` when multiple navs exist
- Heading levels skipped (`<h1>` followed by `<h3>`)
- `<div>` or `<span>` used for list-like content instead of `<ul>`/`<ol>`
- Data tables lack `<th scope="col|row">`
- Layout tables used (tables without data relationship)

```jsx
// ✅ Correct
<nav aria-label="Main navigation">...</nav>
<nav aria-label="Footer links">...</nav>
<main>
  <h1>Page Title</h1>
  <section>
    <h2>Section</h2>
    <h3>Subsection</h3>
  </section>
</main>

// ❌ Flag these
<div className="nav">...</div>  // Use <nav>
<h1>Title</h1><h4>Subsection</h4>  // Skipped h2, h3
```

### ARIA Usage
Flag when:
- `role="button"` on `<a>` or `<div>` that should be `<button>`
- `role="link"` that should be `<a href="...">`
- `aria-label` duplicates visible text
- `aria-hidden="true"` on focusable element
- `role="presentation"` or `role="none"` on element with focusable children
- Widget roles missing required ARIA states (`aria-expanded`, `aria-selected`, etc.)
- `aria-live` region added after initial render (won't announce)

```jsx
// ✅ Correct
<button aria-expanded={isOpen} onClick={toggle}>
  Menu
</button>
<div role="tablist">
  <button role="tab" aria-selected={activeTab === 0}>Tab 1</button>
</div>

// ❌ Flag these
<div role="button">Click</div>  // Should be <button>
<a role="button" onClick={fn}>Action</a>  // Confusing semantics
<button aria-label="Submit">Submit</button>  // Redundant label
<span aria-hidden="true" tabIndex={0}>Hidden but focusable</span>
```

### Links
Flag when:
- Link text is "click here", "read more", "learn more", "here" without context
- Multiple identical link texts pointing to different destinations
- `target="_blank"` without warning to users
- Empty link (`<a href="..."></a>`)

```jsx
// ✅ Correct
<a href="/report">Read the full accessibility report</a>
<a href="/external" target="_blank" rel="noopener noreferrer">
  External site <span className="sr-only">(opens in new tab)</span>
</a>

// ❌ Flag these
<a href="/page1">Click here</a>
<a href="/page2">Click here</a>  // Same text, different targets
<a href="/doc"></a>  // Empty link
```

### Color and Visibility
Flag when:
- `color` set without `background-color` (or vice versa) in same scope
- Hardcoded colors that may not meet contrast requirements
- `display: none` or `visibility: hidden` used to hide content meant for screen readers (use `.sr-only` instead)

```jsx
// ✅ Correct - sr-only pattern
<span className="sr-only">Additional context for screen readers</span>

// CSS: .sr-only { 
//   position: absolute; width: 1px; height: 1px;
//   padding: 0; margin: -1px; overflow: hidden;
//   clip: rect(0,0,0,0); white-space: nowrap; border: 0;
// }

// ❌ Flag for review
<div style={{ color: '#777' }}>Text</div>  // May not meet 4.5:1
```

## Quick Reference: Required Attributes

| Element | Required Accessibility Attributes |
|---------|----------------------------------|
| `<img>` | `alt` (meaningful or empty) |
| `<input>` | Associated `<label>` or `aria-label` |
| `<button>` (icon-only) | `aria-label` |
| `<a>` (icon-only) | `aria-label` |
| `<svg>` (meaningful) | `role="img"` + `aria-label` |
| `<nav>` (multiple) | `aria-label` |
| `<table>` (data) | `<caption>` + `<th scope>` |
| `<iframe>` | `title` |
| `<video>` | `<track kind="captions">` |
| Expandable widget | `aria-expanded` |
| Tab panel | `role="tablist"`, `role="tab"`, `aria-selected` |
| Modal | `role="dialog"`, `aria-labelledby`, `aria-modal="true"` |
