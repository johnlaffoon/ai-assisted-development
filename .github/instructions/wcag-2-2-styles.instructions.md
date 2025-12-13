---
applyTo: "**/*.{css,scss,sass,less,styled.ts,styled.js,styles.ts,styles.js}"
---

# WCAG 2.2 Level AA - CSS/Styling Standards

> **Purpose:** Ensure CSS and styling code supports accessibility requirements.

## Critical Rules

### Focus Indicators
**Priority: Critical**

Flag any of these patterns:

```css
/* ❌ CRITICAL - Never remove focus without replacement */
*:focus { outline: none; }
button:focus { outline: 0; }
a:focus { outline: none; }
[tabindex]:focus { outline: none; }

/* ✅ CORRECT - Custom focus indicators */
*:focus {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}

/* ✅ CORRECT - Remove outline only when providing visible alternative */
button:focus {
  outline: none;
  box-shadow: 0 0 0 3px #005fcc;
}

/* ✅ CORRECT - Use :focus-visible for keyboard-only focus */
button:focus {
  outline: none;
}
button:focus-visible {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}
```

### Motion and Animation
**Priority: High**

Require `prefers-reduced-motion` handling for any animation:

```css
/* ❌ Flag - Animation without reduced motion consideration */
.spinner {
  animation: spin 1s linear infinite;
}

/* ✅ CORRECT - Respect reduced motion preference */
.spinner {
  animation: spin 1s linear infinite;
}

@media (prefers-reduced-motion: reduce) {
  .spinner {
    animation: none;
  }
}

/* ✅ CORRECT - Global reduced motion handling */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### Color Contrast
**Priority: High**

Flag these patterns for manual review:

```css
/* ⚠️ Review - Light gray text may fail contrast */
.muted { color: #999; }
.light-text { color: #aaa; }
.placeholder { color: #ccc; }

/* ⚠️ Review - Ensure 4.5:1 minimum (3:1 for large text) */
.hero-text {
  color: #666;
  background-color: #f0f0f0;
}

/* ✅ CORRECT - High contrast colors */
.body-text {
  color: #333;
  background-color: #fff;
}
```

### Target Size
**Priority: High**

```css
/* ❌ Flag - Interactive elements too small */
.icon-btn {
  width: 16px;
  height: 16px;
}

.small-link {
  padding: 2px;
  font-size: 10px;
}

/* ✅ CORRECT - Minimum 24x24px target (44x44px recommended) */
.icon-btn {
  min-width: 24px;
  min-height: 24px;
  padding: 10px; /* Makes effective size larger */
}

.touch-target {
  min-width: 44px;
  min-height: 44px;
}
```

### Content Visibility
**Priority: Medium**

```css
/* ❌ Flag - Hiding content that should be available to screen readers */
.sr-content {
  display: none; /* Hides from everyone including AT */
}

.sr-content {
  visibility: hidden; /* Hides from everyone including AT */
}

/* ✅ CORRECT - Screen reader only class */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* ✅ CORRECT - Skip link that appears on focus */
.skip-link {
  position: absolute;
  left: -10000px;
  top: auto;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

.skip-link:focus {
  position: static;
  width: auto;
  height: auto;
}
```

### Responsive and Zoom
**Priority: Medium**

```css
/* ❌ Flag - Fixed sizing that breaks at 200% zoom */
.container {
  width: 1200px;
  overflow: hidden;
}

.text {
  font-size: 12px; /* Too small, hard to read */
}

/* ✅ CORRECT - Flexible sizing */
.container {
  max-width: 1200px;
  width: 100%;
}

.text {
  font-size: 1rem; /* Respects user preferences */
  line-height: 1.5;
}

/* ✅ CORRECT - Ensure text spacing can be overridden */
p {
  line-height: 1.5; /* Not !important */
  letter-spacing: normal; /* Not !important */
  word-spacing: normal; /* Not !important */
}
```

### Scroll and Overflow
**Priority: Medium**

```css
/* ⚠️ Review - May cause reflow issues at 400% zoom */
.content {
  overflow: hidden;
}

/* ✅ CORRECT - Allow scrolling when content overflows */
.content {
  overflow: auto;
}

/* ✅ CORRECT - Account for sticky elements */
html {
  scroll-behavior: smooth;
  scroll-padding-top: 80px; /* Height of sticky header */
}

@media (prefers-reduced-motion: reduce) {
  html {
    scroll-behavior: auto;
  }
}
```

## Checklist for Style Reviews

- [ ] No `outline: none` without replacement focus indicator
- [ ] Animations have `prefers-reduced-motion` media query
- [ ] Color values reviewed for contrast compliance
- [ ] Interactive elements have minimum 24×24px target size
- [ ] `.sr-only` class uses position-based hiding, not `display: none`
- [ ] Font sizes use relative units (rem, em) not fixed pixels
- [ ] No `!important` on text spacing properties
- [ ] `scroll-padding` accounts for sticky headers
- [ ] `overflow: hidden` justified and tested at zoom levels
