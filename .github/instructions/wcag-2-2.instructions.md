# WCAG 2.2 Level AA Compliance Standards for Code Review

> **Purpose:** Ensure all code changes meet Web Content Accessibility Guidelines (WCAG) 2.2 Level AA requirements to create inclusive, accessible digital experiences.

## Overview

WCAG 2.2 is the current W3C accessibility standard (published October 5, 2023) with 86 success criteria organized under four principles: Perceivable, Operable, Understandable, and Robust (POUR). Level AA compliance is the globally accepted standard required by most accessibility laws including ADA, Section 508, EN 301 549, and the European Accessibility Act. When reviewing code, prioritize issues that create barriers for users with visual, auditory, motor, or cognitive disabilities.

## Core Principles

1. **Semantic HTML First:** Use native HTML elements with built-in accessibility before adding ARIA attributes
2. **Keyboard Accessible:** All functionality must be operable via keyboard alone
3. **Programmatically Determinable:** Structure, relationships, and states must be conveyed to assistive technologies
4. **Visible and Understandable:** Content must be perceivable and interactions predictable
5. **No ARIA is Better Than Bad ARIA:** Incorrect ARIA causes more harm than missing ARIA

## Review Categories

### Category 1: Text Alternatives and Non-Text Content
**Priority: Critical**

When reviewing code, check for:
- All `<img>` elements have meaningful `alt` attributes or `alt=""` for decorative images
- Icon-only buttons and links have accessible names via `aria-label` or visually hidden text
- Complex images (charts, graphs, diagrams) have extended descriptions
- `<svg>` elements used meaningfully have `role="img"` and accessible name
- Background images conveying information have text alternatives
- `<canvas>` elements have fallback content or accessible descriptions

**Correct Pattern:**
```html
<!-- Meaningful image -->
<img src="chart.png" alt="Q3 sales increased 25% compared to Q2">

<!-- Decorative image -->
<img src="decorative-border.png" alt="">

<!-- Icon button with accessible name -->
<button aria-label="Close dialog">
  <svg aria-hidden="true" focusable="false"><!-- icon --></svg>
</button>

<!-- Complex image with extended description -->
<figure>
  <img src="org-chart.png" alt="Company organizational structure">
  <figcaption>
    <details>
      <summary>Detailed description</summary>
      <p>The CEO reports to the board. Three VPs report to the CEO...</p>
    </details>
  </figcaption>
</figure>
```

**Incorrect Pattern:**
```html
<!-- Missing alt attribute -->
<img src="logo.png">

<!-- Non-descriptive alt text -->
<img src="graph.png" alt="graph">
<img src="photo.jpg" alt="image">

<!-- Icon button without accessible name -->
<button>
  <svg><!-- X icon --></svg>
</button>

<!-- Decorative image with redundant alt -->
<img src="bullet.png" alt="bullet point image">
```

### Category 2: Color and Contrast
**Priority: Critical**

When reviewing code, check for:
- Text contrast ratio of at least 4.5:1 (normal text) or 3:1 (large text: 18pt+ or 14pt+ bold)
- UI component contrast ratio of at least 3:1 against adjacent colors
- Focus indicators have 3:1 contrast against adjacent colors
- Information is not conveyed by color alone
- Links distinguished from surrounding text by more than color (underline, 3:1 contrast + additional indicator on focus/hover)

**Correct Pattern:**
```css
/* Sufficient text contrast */
.body-text {
  color: #333333; /* 12.6:1 against white */
  background-color: #ffffff;
}

/* Large text can use 3:1 minimum */
h1 {
  font-size: 24px;
  color: #767676; /* 4.5:1 against white - acceptable for large text */
}

/* Focus indicator with sufficient contrast */
button:focus {
  outline: 3px solid #0066cc; /* 4.5:1 against white background */
  outline-offset: 2px;
}

/* Link distinguished by more than color */
a {
  color: #0066cc;
  text-decoration: underline;
}
```

**Incorrect Pattern:**
```css
/* Insufficient contrast - FAILS */
.light-text {
  color: #999999; /* 2.8:1 against white - fails 4.5:1 */
  background-color: #ffffff;
}

/* Removing focus outline without replacement - FAILS */
button:focus {
  outline: none;
}

/* Link only distinguished by color - FAILS */
a {
  color: #0066cc;
  text-decoration: none;
}
```

### Category 3: Keyboard Accessibility
**Priority: Critical**

When reviewing code, check for:
- All interactive elements are keyboard focusable (natively or via `tabindex="0"`)
- Custom widgets follow ARIA Authoring Practices keyboard patterns
- No keyboard traps (users can navigate away from all components)
- Focus order follows logical reading/visual order
- Focus is managed appropriately when content changes dynamically
- Skip links or landmark navigation available for repetitive content

**Correct Pattern:**
```html
<!-- Native keyboard-accessible button -->
<button type="button" onclick="handleClick()">Submit</button>

<!-- Custom interactive element made keyboard accessible -->
<div role="button" tabindex="0" 
     onclick="handleClick()" 
     onkeydown="handleKeyDown(event)">
  Custom Button
</div>

<!-- Skip link -->
<a href="#main-content" class="skip-link">Skip to main content</a>

<!-- Proper landmarks for navigation -->
<header role="banner">...</header>
<nav role="navigation" aria-label="Main">...</nav>
<main role="main" id="main-content">...</main>
<footer role="contentinfo">...</footer>
```

```javascript
// Keyboard handler for custom widget
function handleKeyDown(event) {
  if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault();
    handleClick();
  }
}

// Focus management when opening modal
function openModal() {
  const modal = document.getElementById('modal');
  modal.hidden = false;
  const firstFocusable = modal.querySelector('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
  firstFocusable?.focus();
}
```

**Incorrect Pattern:**
```html
<!-- Click-only handler on non-focusable element - FAILS -->
<div onclick="handleClick()">Click me</div>

<!-- Using positive tabindex - disrupts natural order -->
<button tabindex="5">First</button>
<button tabindex="1">Second</button>

<!-- Keyboard trap - no way to exit -->
<div onkeydown="event.preventDefault()">
  Trapped content
</div>
```

### Category 4: Forms and Input Assistance
**Priority: Critical**

When reviewing code, check for:
- All form inputs have associated `<label>` elements or accessible names
- Required fields indicated programmatically (`required` or `aria-required="true"`) and visually
- Error messages identify the field in error and describe how to fix
- Input purpose identified for autofill (`autocomplete` attribute)
- Form instructions provided before input, not just as placeholder
- Redundant entry: previously entered info auto-populated or selectable (WCAG 2.2)

**Correct Pattern:**
```html
<!-- Properly labeled input with instructions -->
<div class="form-group">
  <label for="email">Email address <span aria-hidden="true">*</span></label>
  <span id="email-hint" class="hint">We'll never share your email</span>
  <input type="email" 
         id="email" 
         name="email"
         required
         aria-required="true"
         aria-describedby="email-hint email-error"
         autocomplete="email">
  <span id="email-error" class="error" role="alert" hidden>
    Please enter a valid email address (e.g., name@example.com)
  </span>
</div>

<!-- Grouped related inputs -->
<fieldset>
  <legend>Shipping Address</legend>
  <label for="street">Street</label>
  <input type="text" id="street" autocomplete="street-address">
  <!-- more fields -->
</fieldset>

<!-- Checkbox with accessible label -->
<input type="checkbox" id="terms" required aria-required="true">
<label for="terms">I agree to the <a href="/terms">terms of service</a></label>
```

**Incorrect Pattern:**
```html
<!-- Missing label - FAILS -->
<input type="text" placeholder="Enter your name">

<!-- Label not properly associated - FAILS -->
<label>Email</label>
<input type="email" name="email">

<!-- Error message doesn't identify field or solution - FAILS -->
<span class="error">Invalid input</span>

<!-- Instructions only in placeholder - FAILS -->
<input type="tel" placeholder="Format: (555) 555-5555">
```

### Category 5: Focus Management and Visibility (WCAG 2.2 New)
**Priority: High**

When reviewing code, check for:
- Focus indicators are always visible (never `outline: none` without replacement)
- Focused elements not obscured by sticky headers/footers or overlays (2.4.11 Focus Not Obscured)
- Focus indicator meets minimum area and contrast requirements
- Focus moves logically when content is added/removed dynamically

**Correct Pattern:**
```css
/* Custom focus indicator with sufficient visibility */
:focus {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}

:focus:not(:focus-visible) {
  outline: none;
}

:focus-visible {
  outline: 3px solid #005fcc;
  outline-offset: 2px;
}

/* Ensure sticky elements don't obscure focus */
.sticky-header {
  position: sticky;
  top: 0;
}

main {
  scroll-padding-top: 80px; /* Height of sticky header */
}
```

```javascript
// Scroll focused element into view when needed
function ensureFocusVisible(element) {
  element.focus();
  element.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
}
```

**Incorrect Pattern:**
```css
/* Removing focus indicator entirely - FAILS */
*:focus {
  outline: none;
}

/* Focus can be hidden by sticky element - FAILS */
.sticky-footer {
  position: fixed;
  bottom: 0;
  height: 100px;
  z-index: 1000;
}
/* No scroll padding compensation */
```

### Category 6: Target Size and Pointer Accessibility (WCAG 2.2 New)
**Priority: High**

When reviewing code, check for:
- Interactive targets at least 24×24 CSS pixels (2.5.8 Target Size Minimum)
- Adequate spacing between small targets to prevent accidental activation
- Drag operations have single-pointer alternatives (2.5.7 Dragging Movements)
- No functionality requires specific motion or gestures without alternatives

**Correct Pattern:**
```css
/* Minimum target size */
button, a, input[type="checkbox"], input[type="radio"] {
  min-width: 24px;
  min-height: 24px;
}

/* Icon button with adequate target size */
.icon-button {
  padding: 12px;
  min-width: 44px; /* 24px minimum, 44px recommended */
  min-height: 44px;
}

/* Small icon with touch-friendly padding */
.small-icon-link {
  display: inline-flex;
  padding: 10px;
}
.small-icon-link svg {
  width: 16px;
  height: 16px;
}
```

```html
<!-- Draggable list with button alternatives -->
<ul role="list" aria-label="Reorderable items">
  <li draggable="true">
    <span>Item 1</span>
    <button aria-label="Move Item 1 up">↑</button>
    <button aria-label="Move Item 1 down">↓</button>
  </li>
</ul>
```

**Incorrect Pattern:**
```css
/* Target too small - FAILS */
.tiny-checkbox {
  width: 12px;
  height: 12px;
}

/* Closely spaced small targets - FAILS */
.icon-row button {
  width: 20px;
  height: 20px;
  margin: 0 2px;
}
```

### Category 7: Semantic Structure and ARIA
**Priority: High**

When reviewing code, check for:
- Heading hierarchy is logical (`<h1>` to `<h6>` without skipping levels)
- Lists use proper list elements (`<ul>`, `<ol>`, `<dl>`)
- Tables used for tabular data with proper headers (`<th scope="...">`)
- Landmarks identify page regions (`<header>`, `<nav>`, `<main>`, `<footer>`, `<aside>`)
- ARIA roles match element behavior
- ARIA states updated dynamically (e.g., `aria-expanded`, `aria-selected`)

**Correct Pattern:**
```html
<!-- Proper heading hierarchy -->
<h1>Page Title</h1>
<main>
  <section aria-labelledby="section1">
    <h2 id="section1">Section Heading</h2>
    <h3>Subsection</h3>
  </section>
</main>

<!-- Data table with proper structure -->
<table>
  <caption>Quarterly Sales by Region</caption>
  <thead>
    <tr>
      <th scope="col">Region</th>
      <th scope="col">Q1</th>
      <th scope="col">Q2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">North</th>
      <td>$10,000</td>
      <td>$12,000</td>
    </tr>
  </tbody>
</table>

<!-- Accordion with proper ARIA -->
<div class="accordion">
  <h3>
    <button aria-expanded="false" aria-controls="panel1">
      Section Title
    </button>
  </h3>
  <div id="panel1" hidden>
    Panel content
  </div>
</div>
```

**Incorrect Pattern:**
```html
<!-- Skipped heading level - FAILS -->
<h1>Title</h1>
<h4>Subsection</h4>

<!-- Using ARIA role on wrong element - FAILS -->
<a href="/page" role="button">Click me</a>

<!-- Table for layout - FAILS -->
<table>
  <tr><td>Logo</td><td>Navigation</td></tr>
  <tr><td colspan="2">Content</td></tr>
</table>

<!-- Missing ARIA state updates - FAILS -->
<button onclick="toggleMenu()">Menu</button>
<!-- aria-expanded never updated -->
```

### Category 8: Authentication and Cognitive Load (WCAG 2.2 New)
**Priority: High**

When reviewing code, check for:
- Authentication doesn't rely solely on cognitive function tests (3.3.8 Accessible Authentication)
- Allow password managers and paste in password fields
- Provide alternative authentication methods (email link, biometric)
- Help mechanisms consistent across pages (3.2.6 Consistent Help)
- Previously entered data auto-populated (3.3.7 Redundant Entry)

**Correct Pattern:**
```html
<!-- Allow password managers -->
<input type="password" 
       id="password" 
       autocomplete="current-password"
       aria-describedby="password-help">
<span id="password-help">
  Use your password manager or 
  <a href="/magic-link">sign in with email link</a>
</span>

<!-- CAPTCHA with alternatives -->
<div class="captcha-container">
  <div id="recaptcha"></div>
  <p>Can't complete CAPTCHA? 
    <a href="/audio-captcha">Try audio version</a> or 
    <a href="/contact">contact support</a>
  </p>
</div>

<!-- Consistent help placement across pages -->
<footer>
  <nav aria-label="Help">
    <a href="/help">Help Center</a>
    <a href="/contact">Contact Us</a>
    <a href="tel:+15551234567">Call: (555) 123-4567</a>
  </nav>
</footer>
```

**Incorrect Pattern:**
```html
<!-- Blocking paste in password - FAILS -->
<input type="password" onpaste="return false">

<!-- CAPTCHA without alternatives - FAILS -->
<div class="captcha">
  <img src="captcha.png" alt="Type the letters shown">
  <input type="text" required>
</div>

<!-- Requiring re-entry of data - FAILS -->
<!-- Step 1: User enters address -->
<!-- Step 3: User must re-type entire address with no autofill -->
```

### Category 9: Time and Motion
**Priority: Medium**

When reviewing code, check for:
- Moving/auto-updating content can be paused, stopped, or hidden
- Time limits can be extended, adjusted, or turned off
- No content flashes more than 3 times per second
- Animations can be disabled (respect `prefers-reduced-motion`)

**Correct Pattern:**
```css
/* Respect reduced motion preference */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

.animated-element {
  animation: slide-in 0.3s ease-out;
}

@media (prefers-reduced-motion: reduce) {
  .animated-element {
    animation: none;
  }
}
```

```html
<!-- Carousel with pause control -->
<div class="carousel" role="region" aria-label="Featured content">
  <button aria-pressed="false" onclick="togglePause()">
    Pause slideshow
  </button>
  <div class="slides">...</div>
</div>

<!-- Session timeout with extension -->
<div role="alertdialog" aria-labelledby="timeout-title">
  <h2 id="timeout-title">Session Expiring</h2>
  <p>Your session will expire in <span id="countdown">60</span> seconds.</p>
  <button onclick="extendSession()">Extend Session</button>
  <button onclick="logout()">Log Out</button>
</div>
```

**Incorrect Pattern:**
```css
/* Ignoring motion preferences - FAILS */
.spinner {
  animation: spin 1s infinite linear;
  /* No reduced-motion consideration */
}
```

```html
<!-- Auto-advancing content without controls - FAILS -->
<div class="carousel">
  <!-- No pause button, auto-advances every 3 seconds -->
</div>
```

### Category 10: Multimedia Accessibility
**Priority: Medium**

When reviewing code, check for:
- Pre-recorded video has captions
- Pre-recorded audio has transcripts
- Audio descriptions available for video (when visuals not described in audio track)
- Media players are keyboard accessible
- Autoplay disabled or easily stopped

**Correct Pattern:**
```html
<!-- Video with captions -->
<video controls>
  <source src="video.mp4" type="video/mp4">
  <track kind="captions" src="captions.vtt" srclang="en" label="English" default>
  <track kind="descriptions" src="descriptions.vtt" srclang="en" label="Audio Descriptions">
</video>

<!-- Audio with transcript link -->
<figure>
  <audio controls>
    <source src="podcast.mp3" type="audio/mpeg">
  </audio>
  <figcaption>
    <a href="/transcript/episode-1">Read transcript</a>
  </figcaption>
</figure>

<!-- Accessible media player wrapper -->
<div role="region" aria-label="Video player">
  <video id="video" tabindex="-1"></video>
  <div class="controls" role="group" aria-label="Video controls">
    <button aria-label="Play">▶</button>
    <button aria-label="Mute">🔊</button>
    <input type="range" aria-label="Volume" min="0" max="100">
  </div>
</div>
```

## Common Violations to Flag

1. **Missing form labels:** Input elements without associated `<label>` or `aria-label`
2. **Insufficient color contrast:** Text below 4.5:1 ratio (or 3:1 for large text)
3. **Missing alt text:** Images without `alt` attribute or with non-descriptive values
4. **Removed focus indicators:** `outline: none` without visible replacement
5. **Non-keyboard-accessible controls:** Click handlers on non-focusable elements
6. **Missing heading structure:** Pages without `<h1>` or skipped heading levels
7. **Inaccessible custom widgets:** Dropdowns, tabs, modals without proper ARIA
8. **Missing landmark regions:** Pages without `<main>`, missing navigation labels
9. **Links without context:** Multiple "Read more" or "Click here" links
10. **Improper ARIA usage:** Wrong roles, missing required attributes, stale states
11. **Small touch targets:** Interactive elements under 24×24 pixels
12. **Missing skip links:** No way to bypass repetitive navigation
13. **Autoplay media:** Video/audio that plays automatically without controls
14. **Inaccessible error messages:** Errors not associated with inputs or lacking clear guidance
15. **Keyboard traps:** Focus cannot leave a component via keyboard

## Testing Requirements

- Run automated accessibility scan (axe-core, WAVE) on all modified pages
- Test all interactive components with keyboard-only navigation
- Verify screen reader announces content correctly (test with NVDA, VoiceOver, or JAWS)
- Check color contrast ratios using browser dev tools or contrast checker
- Test at 200% zoom and ensure content remains usable
- Verify focus is visible and never obscured
- Test with `prefers-reduced-motion: reduce` enabled
- Validate HTML for proper nesting and structure

## Documentation Requirements

- Document accessible name source for complex components
- Note any ARIA patterns used and link to ARIA Authoring Practices
- Document keyboard interaction patterns for custom widgets
- Include accessibility testing results in PR description
- Note any known limitations and planned remediation

## Review Checklist

Use this checklist when reviewing code changes:

- [ ] All images have appropriate `alt` text (or empty `alt` for decorative)
- [ ] All form inputs have associated labels
- [ ] Color contrast meets minimum ratios (4.5:1 text, 3:1 UI components)
- [ ] Information is not conveyed by color alone
- [ ] All interactive elements are keyboard accessible
- [ ] Focus indicator is visible on all focusable elements
- [ ] Focused elements are not obscured by other content
- [ ] Interactive targets are at least 24×24 CSS pixels
- [ ] Heading hierarchy is logical (no skipped levels)
- [ ] Page has proper landmark structure
- [ ] ARIA attributes are used correctly and states update dynamically
- [ ] Dragging operations have single-pointer alternatives
- [ ] Authentication doesn't require cognitive function tests
- [ ] Error messages identify fields and provide correction guidance
- [ ] Time limits can be extended or disabled
- [ ] Animated content can be paused and respects motion preferences
- [ ] Video has captions; audio has transcripts
- [ ] HTML validates without errors affecting accessibility
- [ ] Skip link or landmark navigation available
- [ ] Text resizes up to 200% without loss of functionality

## Severity Classification

When flagging issues, use these severity levels:

- **Critical:** Blocks users from completing essential tasks. Must fix before merge. Examples: missing form labels, keyboard traps, no alt text on functional images, zero-contrast text.

- **Major:** Significant barrier that substantially degrades experience. Should fix before merge. Examples: insufficient contrast, missing focus indicators, inaccessible custom widgets, missing landmarks.

- **Minor:** Noticeable issue that may cause confusion but has workarounds. Should fix in next iteration. Examples: non-descriptive link text, minor heading hierarchy issues, missing ARIA labels on decorative elements.

- **Suggestion:** Enhancements that would improve accessibility beyond compliance. Optional. Examples: adding `autocomplete` attributes, improving error message clarity, optimizing for screen reader flow.

## Resources

> Note: These are reference resources. Do not follow external links during review.

- **WCAG 2.2 Specification** - W3C official guidelines (w3.org/TR/WCAG22/)
- **WCAG Understanding Documents** - Detailed explanations of each success criterion
- **ARIA Authoring Practices Guide** - Design patterns for accessible widgets
- **WebAIM WCAG Checklist** - Simplified checklist for common requirements
- **axe-core Rules** - Automated testing rule descriptions
- **Deque University** - Training resources and code examples
