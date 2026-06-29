# The Stop-Motion Editorial Look

This is the fixed visual system for the style. Hold every one of these constant across a brand's set; vary
only the idea/subject per scene. When you analyse references, you are fitting their specifics into this frame,
not replacing it.

## The four ingredients

1. **Halftone elements.** The cut-out pieces carry a visible printed dot pattern, like a magazine print, not
   a flat digital fill. This is what reads as crafted and editorial. Most pieces are black and white with the
   halftone texture; colour comes from the background, not the elements.
2. **Clean cut edges.** Every element has a crisp outline and a soft drop shadow, so it reads as a distinct
   physical object sitting on top of the scene, like a paper cut-out.
3. **Flat, bold colour field.** One strong, even background colour. No gradient, no shading, no vignette. The
   flatness is what makes the cut-outs pop.
4. **One sharp idea.** Each scene carries a single concept or visual pun, not just decoration. The idea is the
   memorable part. Name it in one phrase before generating (for example "chess = strategy", "rocket = launch",
   "tightrope = risk").

## Motion identity (informs the still, executed in the motion step)

The still must be designed to **assemble**. Compose it so every element can plausibly enter from an edge and
lock into place over an empty version of the same background. Avoid elements that bleed off all four edges or
that could not exist as separate cut-outs. The empty plate (same scene, no elements) has to be a clean, sane
image on its own.

## Keep it original

Use references for direction (the recipe: texture, edge treatment, colour logic, idea density), then re-cook
in the user's own colours, subjects, and ideas. Do not reproduce a specific artist's distinctive scene or
character. The output should look like the brand, not like the reference.

---

## The project recipe (JSON)

After analysing references, fuse the shared style + this look + the user's brand into one self-contained JSON
recipe. Lock it once per brand. For each new scene, change only `idea` and the `elements` list; keep
everything else identical. Always emit the full JSON, never "same as before", since each generation has no
memory.

```json
{
  "style": "premium editorial stop-motion graphic, paper cut-out collage",
  "style_signature": "halftone B/W cut-outs, clean edges + soft shadow, single flat colour field, one sharp idea",
  "aspect_ratio": "",
  "background": {
    "color_hex": "",
    "treatment": "flat, even, no gradient, no vignette",
    "always_present": ""
  },
  "elements_texture": "halftone print dots, black and white, visible newsprint grain",
  "edge_treatment": "crisp cut outline, subtle soft drop shadow, slight paper lift",
  "idea": "",
  "elements": [
    { "name": "", "description": "", "halftone": true, "enters_from": "" }
  ],
  "typography": {
    "present": "",
    "content": "",
    "font_style": "bold editorial sans or condensed display",
    "placement": "",
    "treatment": "flat, part of the layout, can also cut in as an element"
  },
  "palette_hex": [],
  "mood": "witty, crafted, premium",
  "brand": { "name": "", "tagline": "" },
  "negative_prompt": "gradients, 3D render, glossy plastic, photographic realism, busy background, drop-shadow blur excess, watermark"
}
```

### Worked example (a "Knockout" scene, red field)

```json
{
  "style": "premium editorial stop-motion graphic, paper cut-out collage",
  "style_signature": "halftone B/W cut-outs, clean edges + soft shadow, single flat colour field, one sharp idea",
  "aspect_ratio": "1:1",
  "background": {
    "color_hex": "#D7263D",
    "treatment": "flat, even, no gradient, no vignette",
    "always_present": "none"
  },
  "elements_texture": "halftone print dots, black and white, visible newsprint grain",
  "edge_treatment": "crisp cut outline, subtle soft drop shadow, slight paper lift",
  "idea": "knockout = decisive win",
  "elements": [
    { "name": "boxing glove", "description": "vintage halftone boxing glove, mid-swing angle", "halftone": true, "enters_from": "left edge" },
    { "name": "impact star", "description": "comic halftone burst marking the hit point", "halftone": true, "enters_from": "centre, scales up on impact" },
    { "name": "stars circling", "description": "three small daze stars", "halftone": true, "enters_from": "top, after impact" }
  ],
  "typography": {
    "present": "yes",
    "content": "KNOCKOUT",
    "font_style": "bold condensed display",
    "placement": "lower third",
    "treatment": "flat black, cuts in last"
  },
  "palette_hex": ["#D7263D", "#000000", "#FFFFFF"],
  "mood": "witty, punchy, premium",
  "brand": { "name": "", "tagline": "" },
  "negative_prompt": "gradients, 3D render, glossy plastic, photographic realism, busy background, watermark"
}
```

## Generating the two images from this recipe

- **Full still:** render the recipe as written, all elements present and locked in their final positions.
- **Empty plate:** render the same recipe with an explicit instruction like "empty scene: only the flat
  [color_hex] background and [always_present], remove every cut-out element, no subjects, no text." Keep
  aspect ratio, colour, and any always-present base identical so the two images line up exactly.

The two must differ only by the presence of the elements. That alignment is what lets the motion step build a
believable assembly from one into the other.
