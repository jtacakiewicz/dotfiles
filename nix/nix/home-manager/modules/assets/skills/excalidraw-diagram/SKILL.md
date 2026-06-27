---
name: excalidraw-diagram
description: Generate Excalidraw diagrams from text content. Supports three output modes - Obsidian (.md), Standard (.excalidraw), and Animated (.excalidraw with animation order). Triggers on "Excalidraw", "draw", "flowchart", "mind map", "visualize", "diagram", "Standard Excalidraw", "standard excalidraw", "Excalidraw Animated", "animated diagram", "animate".
metadata:
  version: 1.2.1
---

# Excalidraw Diagram Generator

Create Excalidraw diagrams from text content with multiple output formats.

## Output Modes

Select output mode based on the user's trigger words:

| Trigger Words | Output Mode | File Format | Usage |
|--------|----------|----------|------|
| `Excalidraw`, `draw`, `flowchart`, `mind map` | **Obsidian** (default) | `.md` | Open directly in Obsidian |
| `Standard Excalidraw`, `standard excalidraw` | **Standard** | `.excalidraw` | Open/edit/share on excalidraw.com |
| `Excalidraw Animated`, `animated diagram`, `animate` | **Animated** | `.excalidraw` | Drag to excalidraw-animate to generate animation |

## Workflow

1. **Detect output mode** from trigger words (see Output Modes table above)
2. Analyze content - identify concepts, relationships, hierarchy
3. Choose diagram type (see Diagram Types below)
4. Generate Excalidraw JSON (add animation order if Animated mode)
5. Output in correct format based on mode
6. **Automatically save to current working directory**
7. Notify user with file path and usage instructions

## Output Formats

### Mode 1: Obsidian Format (Default)

**Strictly output according to the following structure without any modifications:**

```markdown
---
excalidraw-plugin: parsed
tags: [excalidraw]
---
==⚠  Switch to EXCALIDRAW VIEW in the MORE OPTIONS menu of this document. ⚠== You can decompress Drawing data with the command palette: 'Decompress current Excalidraw file'. For more info check in plugin settings under 'Saving'

# Excalidraw Data

## Text Elements
%%
## Drawing
\`\`\`json
{complete JSON data}
\`\`\`
%%
```

**Key Points:**
- Frontmatter must contain `tags: [excalidraw]`
- Warning message must be complete
- JSON must be surrounded by `%%` markers
- Do not use frontmatter settings other than `excalidraw-plugin: parsed`
- **File extension**: `.md`

### Mode 2: Standard Excalidraw Format

Output pure JSON file directly, openable in excalidraw.com:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [...],
  "appState": {
    "gridSize": null,
    "viewBackgroundColor": "#ffffff"
  },
  "files": {}
}
```

**Key Points:**
- `source` uses `https://excalidraw.com` (not Obsidian plugin)
- Pure JSON, no Markdown wrapping
- **File extension**: `.excalidraw`

### Mode 3: Animated Excalidraw Format

Same as Standard format, but each element adds a `customData.animate` field to control animation order:

```json
{
  "id": "element-1",
  "type": "rectangle",
  "customData": {
    "animate": {
      "order": 1,
      "duration": 500
    }
  },
  ...other standard fields
}
```

**Animation Order Rules:**
- `order`: Animation playback order (1, 2, 3...), lower numbers appear first
- `duration`: Drawing duration for this element (milliseconds), default 500
- Elements with the same `order` appear simultaneously
- Suggested order: Title → Main framework → Connection lines → Detail text

**Usage:**
1. Generate `.excalidraw` file
2. Drag to https://dai-shi.github.io/excalidraw-animate/
3. Click Animate to preview, then export SVG or WebM

**File extension**: `.excalidraw`

---

## Diagram Types & Selection Guide

Choose the appropriate diagram type to enhance understanding and visual appeal.

| Type | English | Use Case | Approach |
|------|------|---------|------|
| **Flowchart** | Flowchart | Step instructions, workflows, task execution order | Connect steps with arrows, clearly express process flow |
| **Mind Map** | Mind Map | Concept expansion, topic categorization, brainstorming | Radiate outward from a central core, radial structure |
| **Hierarchy** | Hierarchy | Org charts, content levels, system decomposition | Build hierarchical nodes top-down or left-to-right |
| **Relationship** | Relationship | Influences, dependencies, interactions between elements | Use lines to show connections between shapes, arrows with explanations |
| **Comparison** | Comparison | Side-by-side analysis of approaches or options | Left-right columns or table format, label comparison dimensions |
| **Timeline** | Timeline | Event progression, project milestones, evolution | Use time as axis, mark key time points and events |
| **Matrix** | Matrix | 2D categorization, priority grids, positioning | Establish X and Y dimensions, place items on coordinate plane |
| **Freeform** | Freeform | Scattered ideas, initial exploration, informal notes | No structural constraints, freely place blocks and arrows |

## Design Rules

### Text & Format
- **All text elements must use** `fontFamily: 5` (Excalifont handwriting font)
- **Double quote replacement rule**: `"` replaced with `""`
- **Parentheses replacement rule**: `()` replaced with `''`
- **Font size rules** (hard minimum, below this is unreadable at normal zoom):
  - Title: 20-28px (minimum 20px)
  - Subtitle: 18-20px
  - Body/Label: 16-18px (minimum 16px)
  - Minor annotations: 14px (only for unimportant supplementary text, use sparingly)
  - **Absolutely forbidden below 14px**
- **Line height**: Use `lineHeight: 1.25` for all text
- **Text centering estimation**: Standalone text elements do not auto-center, x coordinate must be calculated manually:
  - Estimate text width: `estimatedWidth = text.length * fontSize * 0.5` (use `* 1.0` for CJK characters)
  - Centering formula: `x = centerX - estimatedWidth / 2`
  - Example: Text "Hello" (5 chars, fontSize 20) centered at x=300 → `estimatedWidth = 5 * 20 * 0.5 = 50` → `x = 300 - 25 = 275`

### Layout & Design
- **Canvas range**: All elements recommended within 0-1200 x 0-800 area
- **Minimum shape size**: Rectangles/ellipses with text at least 120x60px
- **Element spacing**: Minimum 20-30px gap to prevent overlap
- **Clear hierarchy**: Use different colors and shapes to distinguish different levels of information
- **Graphic elements**: Use rectangles, circles, arrows etc. appropriately to organize information
- **No Emoji**: Do not use any Emoji symbols in diagram text; use simple shapes (circles, squares, arrows) or color differentiation for visual markers instead

### Color Palette

**Text Colors (strokeColor for text):**

| Purpose | Value | Description |
|------|------|------|
| Title | `#1e40af` | Deep Blue |
| Subtitle/Connection lines | `#3b82f6` | Bright Blue |
| Body text | `#374151` | Dark Gray (minimum `#757575` on white background) |
| Emphasis/Highlight | `#f59e0b` | Gold |

**Shape Fill Colors (backgroundColor, fillStyle: "solid"):**

| Value | Semantic | Use Case |
|------|------|---------|
| `#a5d8ff` | Light Blue | Input, data source, main nodes |
| `#b2f2bb` | Light Green | Success, output, completed |
| `#ffd8a8` | Light Orange | Warning, pending, external dependencies |
| `#d0bfff` | Light Purple | Processing, middleware, special items |
| `#ffc9c9` | Light Red | Error, critical, alert |
| `#fff3bf` | Light Yellow | Notes, decisions, planning |
| `#c3fae8` | Light Cyan | Storage, data, cache |
| `#eebefa` | Light Pink | Analysis, metrics, statistics |

**Area Background Colors (large rectangle + opacity: 30, for layered diagrams):**

| Value | Semantic |
|------|------|
| `#dbe4ff` | Frontend/UI layer |
| `#e5dbff` | Logic/Processing layer |
| `#d3f9d8` | Data/Tool layer |

**Contrast Rules:**
- On white background, text should be no lighter than `#757575` or it will be unreadable
- On light fills, use darker text variants (e.g., light green background use `#15803d`, not `#22c55e`)
- Avoid light gray text (`#b0b0b0`, `#999`) on white backgrounds

Reference: [references/excalidraw-schema.md](references/excalidraw-schema.md)

## JSON Structure

**Obsidian Mode:**
```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://github.com/zsviczian/obsidian-excalidraw-plugin",
  "elements": [...],
  "appState": { "gridSize": null, "viewBackgroundColor": "#ffffff" },
  "files": {}
}
```

**Standard / Animated Mode:**
```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://excalidraw.com",
  "elements": [...],
  "appState": { "gridSize": null, "viewBackgroundColor": "#ffffff" },
  "files": {}
}
```

## Element Template

Each element requires these fields (do NOT add extra fields like `frameId`, `index`, `versionNonce`, `rawText` -- they may cause issues on excalidraw.com. `boundElements` must be `null` not `[]`, `updated` must be `1` not timestamps):

```json
{
  "id": "unique-id",
  "type": "rectangle",
  "x": 100, "y": 100,
  "width": 200, "height": 50,
  "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 1,
  "opacity": 100,
  "groupIds": [],
  "roundness": {"type": 3},
  "seed": 123456789,
  "version": 1,
  "isDeleted": false,
  "boundElements": null,
  "updated": 1,
  "link": null,
  "locked": false
}
```

`strokeStyle` values: `"solid"` (solid line, default) | `"dashed"` (dashed line) | `"dotted"` (dotted line). Dashed lines are suitable for optional paths, async flows, weak associations, etc.

Text elements add:
```json
{
  "text": "display text",
  "fontSize": 20,
  "fontFamily": 5,
  "textAlign": "center",
  "verticalAlign": "middle",
  "containerId": null,
  "originalText": "display text",
  "autoResize": true,
  "lineHeight": 1.25
}
```

**Animated mode additionally adds** `customData` field:
```json
{
  "id": "title-1",
  "type": "text",
  "customData": {
    "animate": {
      "order": 1,
      "duration": 500
    }
  },
  ...other fields
}
```

See [references/excalidraw-schema.md](references/excalidraw-schema.md) for all element types.

---

## Additional Technical Requirements

### Text Elements Handling
- The `## Text Elements` section in Markdown **must be left empty**, use only `%%` as delimiter
- Obsidian ExcaliDraw plugin **automatically fills text elements** based on JSON data
- No need to manually list all text content

### Coordinates & Layout
- **Coordinate system**: Origin at top-left (0,0)
- **Recommended range**: All elements within 0-1200 x 0-800 pixel range
- **Element ID**: Each element needs a unique `id` (can be strings like `title`, `box1`, etc.)

### Required Fields for All Elements

**IMPORTANT**: Do NOT include `frameId`, `index`, `versionNonce`, or `rawText` fields. Use `boundElements: null` (not `[]`), and `updated: 1` (not timestamps).

```json
{
  "id": "unique-identifier",
  "type": "rectangle|text|arrow|ellipse|diamond",
  "x": 100, "y": 100,
  "width": 200, "height": 50,
  "angle": 0,
  "strokeColor": "#color-hex",
  "backgroundColor": "transparent|#color-hex",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid|dashed|dotted",
  "roughness": 1,
  "opacity": 100,
  "groupIds": [],
  "roundness": {"type": 3},
  "seed": 123456789,
  "version": 1,
  "isDeleted": false,
  "boundElements": null,
  "updated": 1,
  "link": null,
  "locked": false
}
```

### Text-Specific Properties
Text elements (type: "text") require additional properties (do NOT include `rawText`):
```json
{
  "text": "display text",
  "fontSize": 20,
  "fontFamily": 5,
  "textAlign": "center",
  "verticalAlign": "middle",
  "containerId": null,
  "originalText": "display text",
  "autoResize": true,
  "lineHeight": 1.25
}
```

### appState Configuration
```json
"appState": {
  "gridSize": null,
  "viewBackgroundColor": "#ffffff"
}
```

### files Field
```json
"files": {}
```

## Common Mistakes to Avoid

- **Text offset** — Standalone text element's `x` is the left edge, not center. Must be manually calculated using the centering formula, otherwise text will be skewed
- **Element overlap** — Elements with similar y coordinates easily stack. Check for at least 20px spacing from surrounding elements before placing new ones
- **Insufficient canvas margin** — Content should not be placed against canvas edges. Leave 50-80px padding around all sides
- **Title not centered over diagram** — Title should be centered over the full width of the diagram below, not fixed at x=0
- **Arrow label overflow** — Long text labels (e.g., "ATP + NADPH") will overflow short arrows. Keep labels brief or increase arrow length
- **Insufficient contrast** — Light text on white background is nearly invisible. Keep text color no lighter than `#757575`, use dark variants for colored text
- **Font too small** — Below 14px is unreadable at normal zoom; body text minimum 16px

## Implementation Notes

### Auto-save & File Generation Workflow

When generating Excalidraw diagrams, **the following steps must be executed automatically**:

#### 1. Choose the appropriate diagram type
- Based on the characteristics of user-provided content, refer to the "Diagram Types & Selection Guide" table above
- Analyze the core requirements of the content, choose the most suitable visualization form

#### 2. Generate meaningful filenames

Select file extension based on output mode:

| Mode | Filename Format | Example |
|------|-----------|------|
| Obsidian | `[topic].[type].md` | `business-model.relationship.md` |
| Standard | `[topic].[type].excalidraw` | `business-model.relationship.excalidraw` |
| Animated | `[topic].[type].animate.excalidraw` | `business-model.relationship.animate.excalidraw` |

- Use descriptive English names for clarity

#### 3. Use Write tool to auto-save files
- **Save location**: Current working directory (auto-detected from environment)
- **Full path**: `{current_directory}/[filename].md`
- This enables flexible migration without hardcoded paths

#### 4. Ensure Markdown structure is exactly correct
**Must be generated in the following format** (no modifications allowed):

```markdown
---
excalidraw-plugin: parsed
tags: [excalidraw]
---
==⚠  Switch to EXCALIDRAW VIEW in the MORE OPTIONS menu of this document. ⚠== You can decompress Drawing data with the command palette: 'Decompress current Excalidraw file'. For more info check in plugin settings under 'Saving'

# Excalidraw Data

## Text Elements
%%
## Drawing
\`\`\`json
{complete JSON data}
\`\`\`
%%
```

#### 5. JSON Data Requirements
- Include complete Excalidraw JSON structure
- All text elements use `fontFamily: 5`
- Replace `"` with `""` in text
- Replace `()` with `''` in text
- JSON must be valid and pass syntax checking
- All elements must have unique `id`
- Include `appState` and `files: {}` fields

#### 6. User Feedback & Confirmation
Report to the user:
- Diagram has been generated
- Exact save location
- How to view in Obsidian
- Explanation of design choices (what type of diagram was selected and why)
- Whether adjustments or modifications are needed

### Example Output Messages

**Obsidian Mode:**
```
Excalidraw diagram generated!

Save location: business-model.relationship.md

Usage:
1. Open this file in Obsidian
2. Click the MORE OPTIONS menu in the top right
3. Select Switch to EXCALIDRAW VIEW
```

**Standard Mode:**
```
Excalidraw diagram generated!

Save location: business-model.relationship.excalidraw

Usage:
1. Open https://excalidraw.com
2. Click top-left menu → Open → Select this file
3. Or drag and drop the file onto excalidraw.com page
```

**Animated Mode:**
```
Excalidraw animated diagram generated!

Save location: business-model.relationship.animate.excalidraw

Animation order: Title(1) → Main framework(2-4) → Connection lines(5-7) → Description text(8-10)

Generate animation:
1. Open https://dai-shi.github.io/excalidraw-animate/
2. Click Load File to select this file
3. Preview the animation
4. Click Export to export SVG or WebM
```
