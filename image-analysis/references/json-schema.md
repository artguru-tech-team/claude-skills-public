# JSON Prompt: Field Guide and Worked Example

The JSON prompt is the main deliverable. This file explains what belongs in each field and shows one complete worked example so the level of specificity is clear.

## Calibration principle

Every field should hold something a generator could act on. Compare:

- Weak: `"lighting": { "quality": "nice soft light" }`
- Strong: `"quality": "soft, large source", "key": "4ft octabox at 45 degrees camera-left, slightly above eye line", "contrast_ratio": "moderate, around 3:1, shadows present but open"`

If you would not be able to rebuild the image from a field, it is not specific enough yet.

## Field guide

- **medium**: the physical or digital nature of the image (for example "editorial fashion photograph", "octane 3D render", "layered paper-cut").
- **genre_style**: the genre within the medium (for example "high-fashion editorial", "clean beauty", "premium product").
- **aspect_ratio**: for example "4:5", "3:2", "9:16", "1:1".
- **style_signature**: one compact line summarizing the whole look, meant to be lifted and reused as a style anchor on other prompts (for example "moody desaturated editorial, single hard key, 85mm compression").
- **subjects**: an array, one object per person or main subject. Single-subject images simply have one element. For each: `appearance` covers age range and build and features, `skin_tone` is called out on its own because generators drift on it, and `notable_details` catches the small specifics (a freckle pattern, jewelry, a gesture) that make replication faithful.
- **subject_interaction**: how multiple subjects relate and are arranged in frame. Empty for a single subject.
- **secondary_elements**: props and supporting objects, with their placement.
- **setting**: where it happens, what the background is, the depth layers, and any set construction.
- **composition**: how the frame is organized. Be concrete about where the subject sits in the frame.
- **camera**: angle, height, distance, and the focal-length character (describe the look, for example "85mm portrait compression").
- **lens_optics**: depth of field, where focus lands, the bokeh character, any distortion or flare, and motion blur if anything in frame is moving.
- **lighting**: the full setup. Name the pattern (Rembrandt, clamshell, etc.), the role of each source, direction, hard or soft, the contrast ratio, color temperature, how shadows and highlights behave, and the catchlight shape in the eyes when a subject is present.
- **color**: a hex palette plus dominant and accent, the saturation level, the named grade, white balance, tonal range, and the `intent` (the reason behind the color choices).
- **texture_material**: surface qualities, including skin and fabric.
- **post_processing**: grain, any film emulation, retouching level, halation or bloom, sharpening, and deliberate artifacts.
- **typography_text**: whether text is present and, if so, its content, font style, placement, and treatment.
- **mood_emotion**: the feeling, tied to the techniques that create it.
- **references_era**: the movement, decade, or brand vibe it evokes.
- **technical_quality**: resolution feel and rendering fidelity.
- **negative_prompt**: what to avoid in order to stay faithful (for example "no harsh on-camera flash, no oversaturation, no busy background").

## Worked example

The following is the level of completeness to aim for. (The image being described is a hypothetical editorial portrait, used only to show calibration.)

### Breakdown

**Medium and genre.** A high-fashion editorial photograph, single subject, shot in studio. The styling and restraint place it closer to a magazine fashion story than a commercial beauty ad.

**Composition.** Vertical 4:5 crop. Medium close-up, subject placed slightly left of center on a thirds line, with clean negative space to the right. Calm and balanced, no leading lines, the weight carried by the subject and the empty space.

**Subject and styling.** A woman in her late twenties, warm medium skin, dark hair pulled back tight. Direct, level gaze into the lens, lips relaxed, expression composed and self-possessed. Shoulders squared to camera, chin slightly down. Wardrobe is a structured charcoal blazer with sharp lapels. Hair is sleek with no flyaways. Makeup is matte with a defined brow and a nude lip.

**Color and grade.** Desaturated editorial grade. Palette runs through charcoal (#2E2E30), warm taupe skin (#B98A6E), a soft grey backdrop (#C9C5BE), and a near-black shadow (#15140F). Blacks are very slightly lifted for a matte feel rather than crushed. Cool white balance overall with the skin held just warm enough to stay natural. The intent is restraint and premium calm, color staying out of the way of form.

**Lighting.** A single large soft key, an octabox at roughly 45 degrees camera-left and a little above the eye line, producing a soft loop pattern. Minimal fill, so the shadow side falls off gently into the taupe midtones. A faint rim from behind camera-right separates the hair from the backdrop. Contrast is moderate, around 3:1. Shadows are soft-edged, highlights roll off without clipping. The catchlight is a single soft square in the upper left of each eye, the octabox signature.

**Camera and lens.** Eye-level, square to the subject, shot at a portrait-compression focal length (around 85mm look) from a medium distance, which flattens the features in the flattering editorial way. Shallow depth of field, focus on the eyes, the backdrop falling into smooth even softness with no busy bokeh.

**Texture.** Skin is dewy but real, pores visible, retouching light. The blazer fabric is matte with a faint weave.

**Post-processing.** Clean with a very fine grain layer. A whisper of Portra-like warmth in the skin. No vignette, no halation. Retouching is natural rather than airbrushed.

**Typography.** None.

**Mood.** Premium, composed, quietly confident. The mood comes from the long-lens compression, the single soft directional light, and the restrained grade working together.

### Generic prompt

High-fashion editorial portrait of a woman in her late twenties with warm medium skin and sleek dark hair pulled back, wearing a structured charcoal blazer with sharp lapels, looking directly into the lens with a composed, self-possessed expression. Studio shot on a soft grey backdrop, vertical 4:5 frame, subject left of center with clean negative space to the right. Lit by a single large soft octabox at 45 degrees from the left and slightly above eye level, soft loop lighting, minimal fill, a faint hair rim from the right, moderate 3:1 contrast with soft-edged shadows and gently rolled highlights. Shot at an 85mm portrait-compression look, eye-level, shallow depth of field with focus on the eyes and a smooth soft background. Desaturated premium editorial grade, slightly lifted matte blacks, cool white balance with natural warm skin, dewy real skin texture with light retouching and a very fine grain. Calm, premium, quietly confident mood.

### JSON prompt

```json
{
  "medium": "editorial fashion photograph, studio",
  "genre_style": "high-fashion editorial portrait",
  "aspect_ratio": "4:5",
  "style_signature": "premium desaturated editorial portrait, single soft octabox key, 85mm compression, lifted matte blacks",
  "subjects": [
    {
      "main": "woman, late twenties",
      "appearance": "medium build, sleek dark hair pulled back tight, defined brow",
      "skin_tone": "warm medium, even, natural undertone (around #B98A6E)",
      "expression_gaze": "direct level gaze into lens, composed and self-possessed, relaxed lips",
      "pose_body_language": "shoulders squared to camera, chin slightly down",
      "wardrobe": "structured charcoal blazer with sharp lapels",
      "hair_makeup": "sleek pulled-back hair, matte makeup, defined brow, nude lip",
      "notable_details": "no flyaways, minimal jewelry"
    }
  ],
  "subject_interaction": "none, single subject",
  "secondary_elements": "none",
  "setting": {
    "location": "studio",
    "background": "soft grey seamless backdrop",
    "depth_layers": "subject in front, even soft backdrop behind",
    "set_design": "none, clean seamless"
  },
  "composition": {
    "shot_type": "medium close-up",
    "framing": "rule of thirds, vertical",
    "subject_placement": "slightly left of center on the left thirds line",
    "negative_space": "clean open space to the right",
    "symmetry_balance": "asymmetrical, balanced by negative space",
    "leading_lines": "none"
  },
  "camera": {
    "angle": "eye-level",
    "height": "at subject eye line",
    "distance": "medium",
    "focal_length_equiv": "85mm portrait compression look",
    "perspective": "flattened, flattering"
  },
  "lens_optics": {
    "depth_of_field": "shallow",
    "focus_point": "the eyes",
    "bokeh": "smooth and even, no busy highlights",
    "distortion": "none",
    "flare_aberration": "none",
    "motion_blur": "none, fully frozen"
  },
  "lighting": {
    "setup": "single soft key plus subtle hair rim",
    "key": "octabox at 45 degrees camera-left, slightly above eye line, soft loop pattern",
    "fill": "minimal, shadow side falls off gently",
    "rim_back": "faint rim from behind camera-right separating hair from backdrop",
    "direction": "three-quarter from the left",
    "quality": "soft, large source",
    "contrast_ratio": "moderate, around 3:1",
    "color_temperature": "cool overall, skin held just warm",
    "source_time_of_day": "studio strobe",
    "shadows": "soft-edged, open",
    "highlights": "rolled off, not clipped",
    "catchlight": "single soft square octabox catchlight, upper left of each iris"
  },
  "color": {
    "palette_hex": ["#2E2E30", "#B98A6E", "#C9C5BE", "#15140F"],
    "dominant": "charcoal and warm taupe",
    "accent": "soft grey backdrop",
    "saturation": "muted, desaturated",
    "grade": "desaturated editorial, slightly lifted matte blacks",
    "white_balance": "cool with natural warm skin",
    "tonal_range_contrast": "moderate, soft contrast",
    "intent": "premium restraint, color stays out of the way of form"
  },
  "texture_material": "dewy real skin with visible pores, light retouching, matte blazer fabric with faint weave",
  "post_processing": {
    "grain_noise": "very fine grain",
    "film_emulation": "subtle Portra-like warmth in skin",
    "retouching_level": "light, natural",
    "vignette_halation_bloom": "none",
    "sharpening_clarity": "natural, not over-sharpened",
    "deliberate_artifacts": "none"
  },
  "typography_text": {
    "present": "no",
    "content": "",
    "font_style": "",
    "placement": "",
    "treatment": ""
  },
  "mood_emotion": "premium, composed, quietly confident",
  "references_era": "contemporary magazine fashion editorial",
  "technical_quality": "high resolution, clean professional capture",
  "negative_prompt": "no harsh on-camera flash, no oversaturation, no busy background, no heavy airbrushing, no wide-angle distortion"
}
```
