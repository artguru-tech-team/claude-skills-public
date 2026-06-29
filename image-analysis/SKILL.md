---
name: image-analysis
description: Deep, exhaustive analysis of any image or set of images, covering every reproducible attribute, from medium and composition to subject and styling, color and grade, lighting, camera and lens, texture, post-processing, mood, and typography. The goal is replication-grade depth, thorough enough to regenerate the image from the breakdown alone, even when regenerating is not the immediate goal. Produces a readable breakdown plus two prompts, a generic natural-language one and a granular field-by-field JSON prompt tuned for Nano Banana and GPT image models. Use whenever the user shares an image and asks to analyze, break down, study, decode, reverse-engineer, or understand it, asks how to recreate or replicate it, asks to make similar images, or asks to keep an image's look while changing one element like color tone, subject, or setting. Also use for multiple images or carousels, where it adds a shared-style summary. Trigger even when the user does not say analyze but clearly wants a reference image decoded.
---

# Image Analysis

## What this skill is for

The user is an AI image and video creator. When they share an image, they want it taken apart completely, not summarized. The driving question behind every analysis is:

> "If I had to regenerate this exact image from scratch, what would I need to specify?"

Analyzing to that standard is the job even when replication is not the stated goal. Most follow-up requests will be variations: "make similar," or "keep everything the same but change the color tone," or "same lighting and framing but a different subject." That only works if the first analysis was granular enough that any single attribute can be swapped while everything else stays fixed. So: over-analyze on purpose. Depth here is a feature, not verbosity.

## Mindset before writing anything

Look at the image properly first. Do not pattern-match from a glance. Move your attention through it in passes:

- The subject: face, gaze, expression, pose, hands, wardrobe, hair, skin.
- The edges and corners: what is cropped, what is in negative space.
- The light: where it comes from, how hard or soft, where the shadows fall, the color of the light.
- The darks and the brights: are blacks crushed or lifted, are highlights blown or rolled off.
- The surfaces: skin texture, fabric weave, material finish, grain.
- The overall finish: is this a photograph, a render, a collage, a paper-cut, a stop-motion frame, an illustration.

For every observation, also reason about the *why* and the *technique*. "Muted colors" is not an analysis. "Desaturated editorial grade with lifted blacks and a cool white balance, which reads as premium and restrained" is, because that is the thing you would actually reproduce.

If the user refers to an image but none is actually attached, ask them to share it rather than guessing.

## Workflow

1. Confirm what is in front of you (one image or several).
2. Work through the full checklist below for each image. Consult `references/analysis-dimensions.md` when you need precise vocabulary for lighting patterns, color grades, lens character, mediums, or film stocks. Using the right term matters because it is what makes the prompt reproducible.
3. Produce the output in the exact structure described under "Output format."
4. For multiple images, analyze each one fully, then add a shared-style summary.
5. Stop and let the user direct the next step (replicate, make similar, change one attribute, etc.). When they do, reuse the JSON as the base and change only the fields they name.

## The analysis checklist

Cover all of these for each image. If something genuinely does not apply, say so briefly rather than skipping silently.

- **Medium and genre**: photograph, 3D render, illustration, paper-cut, stop-motion, mixed media, etc., and the genre within that (high-fashion editorial, documentary portrait, product, beauty, lifestyle, conceptual).
- **Format**: aspect ratio and orientation.
- **Subject(s)**: who or what, and if there are several, each one separately. For each: appearance, skin tone (call it out explicitly, generators drift on this), expression, gaze, pose and body language, wardrobe, hair and makeup, distinguishing details. When there are several, also note how they relate and are arranged.
- **Secondary elements**: props and supporting objects.
- **Setting**: location, background, set design, depth layers (foreground, midground, background).
- **Composition**: shot type, framing, subject placement, negative space, symmetry and balance, leading lines.
- **Camera**: angle, height, distance, focal-length character, perspective.
- **Lens and optics**: depth of field, focus point, bokeh, distortion, flare or aberration, motion blur if anything is moving.
- **Lighting**: full setup (key, fill, rim or back), direction, hard or soft quality, contrast ratio, color temperature, source and time of day, how shadows and highlights behave, and the catchlight shape in the eyes when a subject is present.
- **Color**: palette with hex values, dominant and accent colors, saturation level, the grade, white balance, tonal range and contrast, and the intent behind the choices.
- **Texture and material**: skin texture, fabric, surface finishes, tactility.
- **Post-processing**: grain or noise, film emulation, retouching level, vignette or halation or bloom, sharpening, deliberate artifacts.
- **Typography and text**: present or not, content, font style, placement, treatment. (Important for carousels.)
- **Mood and emotion**: the feeling it communicates.
- **References and era**: art movement, decade, or brand vibe it evokes.
- **Technical quality**: resolution feel and rendering fidelity.

## Output format

Use this exact structure. Keep the prose clean and editorial. Do not use em dashes anywhere in the output; use periods or line breaks instead.

```
## [Short title describing the image]

### Breakdown
A walk through the checklist, grouped under clear subheadings (Medium and genre, Composition, Subject and styling, Color and grade, Lighting, Camera and lens, Texture, Post-processing, Typography, Mood). Every element carries its why or technique, not just a label.

### Generic prompt
One paragraph of natural language that captures the full image and could be pasted into any generator. Fully self-contained: it names the subject, setting, lighting, camera, color, and finish in plain words, with no reference to "the image above" or "as described."

### JSON prompt
The structured, field-by-field prompt (schema below) as valid JSON.
```

### The JSON prompt

This is the centerpiece. It must be valid JSON (no comments, no trailing commas) and every field filled with specific, concrete values rather than vague ones. Granularity is the point: each field is independently editable, so a later "change only the color tone" request means rewriting one block and leaving the rest untouched.

Always keep it self-contained. Never write "same as previous" or reference an earlier prompt, because each generation has zero memory of any other. Every JSON prompt must stand fully on its own.

The `style_signature` field is a single compact line summarizing the overall look (for example "moody desaturated editorial, single hard key, 85mm compression, lifted matte blacks"). It exists so the user can lift just that line and reuse it as a style anchor on other prompts when they want a similar feel without carrying the whole object.

Use this schema:

```json
{
  "medium": "",
  "genre_style": "",
  "aspect_ratio": "",
  "style_signature": "",
  "subjects": [
    {
      "main": "",
      "appearance": "",
      "skin_tone": "",
      "expression_gaze": "",
      "pose_body_language": "",
      "wardrobe": "",
      "hair_makeup": "",
      "notable_details": ""
    }
  ],
  "subject_interaction": "",
  "secondary_elements": "",
  "setting": {
    "location": "",
    "background": "",
    "depth_layers": "",
    "set_design": ""
  },
  "composition": {
    "shot_type": "",
    "framing": "",
    "subject_placement": "",
    "negative_space": "",
    "symmetry_balance": "",
    "leading_lines": ""
  },
  "camera": {
    "angle": "",
    "height": "",
    "distance": "",
    "focal_length_equiv": "",
    "perspective": ""
  },
  "lens_optics": {
    "depth_of_field": "",
    "focus_point": "",
    "bokeh": "",
    "distortion": "",
    "flare_aberration": "",
    "motion_blur": ""
  },
  "lighting": {
    "setup": "",
    "key": "",
    "fill": "",
    "rim_back": "",
    "direction": "",
    "quality": "",
    "contrast_ratio": "",
    "color_temperature": "",
    "source_time_of_day": "",
    "shadows": "",
    "highlights": "",
    "catchlight": ""
  },
  "color": {
    "palette_hex": [],
    "dominant": "",
    "accent": "",
    "saturation": "",
    "grade": "",
    "white_balance": "",
    "tonal_range_contrast": "",
    "intent": ""
  },
  "texture_material": "",
  "post_processing": {
    "grain_noise": "",
    "film_emulation": "",
    "retouching_level": "",
    "vignette_halation_bloom": "",
    "sharpening_clarity": "",
    "deliberate_artifacts": ""
  },
  "typography_text": {
    "present": "",
    "content": "",
    "font_style": "",
    "placement": "",
    "treatment": ""
  },
  "mood_emotion": "",
  "references_era": "",
  "technical_quality": "",
  "negative_prompt": ""
}
```

A field guide and a fully worked example live in `references/json-schema.md`. Read it the first time you produce a JSON prompt so the level of specificity is calibrated correctly.

## Multiple images

Analyze each image fully and separately, in its own block with its own breakdown and prompts. Then add one final section:

```
## Shared style summary
```

This captures the visual system the set has in common: the palette and grade, the lighting logic, the framing and crop conventions, the typographic treatment, the post-processing fingerprint, and the overall mood. The purpose is to let the user generate new images that sit naturally inside the same set or carousel. Be specific enough that the summary itself could seed a fresh on-brand image.

## Handling follow-up requests

After the analysis, the user will usually want to act on it. Common patterns:

- **"Replicate it" or "recreate this"**: deliver the JSON prompt as is, ready to paste.
- **"Make similar"**: keep the structural fields (medium, lighting, camera, grade, composition) and vary the surface ones (subject, wardrobe, props, setting) so the new image shares the look without being a copy.
- **"Keep everything, change only X"**: rewrite only the field or block for X. Re-emit the entire JSON so it stays self-contained, with every other value identical to before.

In all cases the emitted prompt must remain complete and standalone. Do not hand back a fragment or a diff.

## Reference files

- `references/analysis-dimensions.md`: precise vocabulary and taxonomies for each dimension (lighting patterns, color grades, lens character, mediums, film stocks, composition principles). Consult it to keep terminology accurate and reproducible.
- `references/json-schema.md`: a field-by-field guide to the JSON schema plus one fully worked example showing a breakdown, a generic prompt, and a filled JSON prompt together.
