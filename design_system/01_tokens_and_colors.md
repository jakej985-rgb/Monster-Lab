# 01 - Tokens and Colors

## 1. Color Palette

The Monster Lab color palette balances high-energy playful vibrance with strict WCAG AA/AAA legibility standards.

### 1.1 Brand & Accent Tokens
| Token Name | Hex Code | Purpose / Application | Contrast on Surface |
|---|---|---|---|
| `primaryViolet` | `#6C5CE7` | Primary brand accent, primary CTA buttons, Byte mascot | 4.8:1 on Light Surface |
| `primaryVioletDark` | `#4834D4` | Hover / Pressed button state, high contrast header text | 7.6:1 on Light Surface |
| `accentCyan` | `#00CEC9` | Secondary accent, wire traces, active connections, Sparky | 3.1:1 (Used with dark text) |
| `accentCyanDark` | `#0984E3` | Interactive link text, secondary navigation highlights | 4.5:1 on Light Surface |
| `energyAmber` | `#FFA502` | XP counters, star ratings, Bolt mascot, active badges | 3.2:1 (Used with dark text) |
| `energyGold` | `#FDCB6E` | Milestone celebration highlights, level badges | Decorative / Accent |

### 1.2 Surface & Background Tokens
| Token Name | Hex Code | Purpose / Application |
|---|---|---|
| `surfaceLight` | `#FFFFFF` | Card backgrounds, dialog containers, breadboard background |
| `backgroundLight`| `#F8F9FD` | Main app scaffold background with subtle dot-matrix grid |
| `surfaceContainerLight` | `#EDF2F7` | Input fields, inactive tabs, code block backgrounds |
| `surfaceDark` | `#1E1E2E` | Dark lab mode cards, code editor container background |
| `backgroundDark` | `#12121C` | Dark lab scaffold background |
| `textPrimaryLight` | `#2D3436` | Main body text in light mode (high contrast 14:1) |
| `textSecondaryLight` | `#636E72` | Helper text, subtitles, estimated time |

### 1.3 Physical Wire Color Standard
To eliminate confusion during breadboard assembly, digital wire representations strictly match the physical jumper wires provided in the Monster kit:

| Wire Signal Type | Wire Color Name | Hex Token | Physical Jumper Representation |
|---|---|---|---|
| **5V / VCC Power** | `wireRed` | `#FF4757` | Standard Red Jumper Cable |
| **GND / Ground** | `wireBlack` | `#2F3542` | Standard Black Jumper Cable |
| **Analog / PWM** | `wireYellow` | `#ECCC68` | Standard Yellow Jumper Cable |
| **Digital Signal** | `wireGreen` | `#2ED573` | Standard Green Jumper Cable |
| **I2C Bus (SDA/SCL)** | `wireBlue` | `#1E90FF` | Standard Blue Jumper Cable |
| **SPI / High-Speed** | `wireOrange` | `#FFA502` | Standard Orange Jumper Cable |
| **Alternative Signal**| `wireWhite` | `#CED6E0` | Standard White Jumper Cable |

### 1.4 Tier & Difficulty Hues
- **Rookie (Beginner)**: `tierRookie` (`#00B894` — Mint Green)
- **Builder (Intermediate)**: `tierBuilder` (`#0984E3` — Cobalt Blue)
- **Engineer (Advanced)**: `tierEngineer` (`#6C5CE7` — Electric Violet)
- **Monster Master**: `tierMaster` (`#E84393` — Royal Magenta / Gold)

---

## 2. Typography System

The typography uses friendly rounded geometry for headings and high-legibility clean strokes for instructional body text.

### Font Families
- **Headings & Mascots**: `Fredoka` or `Nunito` (Rounded sans-serif)
- **Body & Instructions**: `Plus Jakarta Sans` or `Inter` (Humanist sans-serif)
- **Code & Serial Stream**: `JetBrains Mono` or `Fira Code` (Monospace with tabular figures)

### Type Scale Specification
| Style Name | Font Size | Line Height | Weight | Letter Spacing | Target Usage |
|---|---|---|---|---|---|
| `displayLarge` | 34 sp | 42 sp | Bold (700) | -0.5 sp | Splash titles, victory screens |
| `displayMedium` | 28 sp | 36 sp | Bold (700) | -0.25 sp | Section headers, lab entrance |
| `headlineLarge` | 24 sp | 32 sp | Semi-Bold (600) | 0.0 sp | Screen titles, project titles |
| `headlineMedium`| 20 sp | 28 sp | Semi-Bold (600) | 0.15 sp | Card titles, step headers |
| `titleLarge` | 18 sp | 24 sp | Medium (500) | 0.15 sp | Dialog titles, subheadings |
| `bodyLarge` | 16 sp | 24 sp | Regular (400) | 0.5 sp | Lesson instructions, stories |
| `bodyMedium` | 14 sp | 20 sp | Regular (400) | 0.25 sp | Metadata, parts descriptions |
| `labelLarge` | 16 sp | 22 sp | Bold (700) | 0.1 sp | Primary action buttons |
| `labelMedium` | 13 sp | 18 sp | Semi-Bold (600) | 0.5 sp | Badges, chip tags, pin labels |
| `codeLarge` | 15 sp | 22 sp | Medium (500) | 0.0 sp | Arduino sketch code blocks |
| `codeMedium` | 13 sp | 18 sp | Regular (400) | 0.0 sp | In-line code, serial monitor |

---

## 3. Spacing & Elevation

### Spacing Scale
- `space2`: 2 dp (tight padding)
- `space4`: 4 dp (badge padding, micro-spacing)
- `space8`: 8 dp (gap between list items)
- `space12`: 12 dp (internal card spacing)
- `space16`: 16 dp (standard screen margins, card padding)
- `space24`: 24 dp (section spacing)
- `space32`: 32 dp (major module separation)
- `space48`: 48 dp (hero spacing, minimum touch target dimension)

### Corner Radius
- `radiusSmall`: 8 dp (chips, small badges, pin tags)
- `radiusMedium`: 16 dp (cards, modal sheets, code blocks)
- `radiusLarge`: 24 dp (interactive lab widgets, hero cards)
- `radiusPill`: 999 dp (buttons, search inputs, XP progress bar)

### Elevations & Shadows
- `elevationLow`: `0 2px 8px rgba(108, 92, 231, 0.08)` (resting cards)
- `elevationMedium`: `0 6px 16px rgba(108, 92, 231, 0.12)` (hovered cards, dialogs)
- `elevationHigh`: `0 12px 28px rgba(108, 92, 231, 0.18)` (floating action buttons, modal bottom sheets)
