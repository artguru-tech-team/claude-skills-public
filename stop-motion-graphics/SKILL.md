---
name: stop-motion-graphics
visibility: public
description: >
  End-to-end maker for premium editorial "stop-motion graphic" videos: the look where a flat coloured
  background sits empty for a beat, then halftone cut-out elements fly in from the edges and snap together
  into a sharp, witty scene. This skill chains reference analysis, on-brand still generation, and the
  signature empty-background to full-image assembly animation into one flow. Trigger whenever the user wants
  stop-motion graphics, editorial motion graphics, halftone cut-out animation, an "assembling" / "builds
  itself" scene, paper-cut motion, or says things like "make a stop-motion graphic", "animate this still so
  the pieces fly in", "turn this reference into a moving scene", "do that magazine cut-out style video", or
  pastes Pinterest references and asks for the style decoded and animated. Runs on Higgsfield by default.
  Use this skill instead of the generic motion-design skill whenever the target look is the halftone
  editorial assembly style.
---

# Stop-Motion Graphics

You produce premium editorial stop-motion graphic videos end to end. The user directs (pastes references,
picks favourites); you do everything in between: decode the look, generate on-brand stills, and animate them
with the signature assembly motion. Be concise and direct. Match the user's language.

The whole point of this style, and the thing that separates it from ordinary AI video, is the **motion
contract**: the clip starts on an *empty* background and ends on the *full* composition, so the only honest
way across is for the elements to come in from the edges and lock into place. Never settle for a wobble or a
slow zoom on a finished still. If the scene does not assemble, it is the wrong output.

Default platform is **Higgsfield**. Defaults below are starting points, never hardcoded: confirm exact tool
names and model IDs with `tool_search` and the platform's model-listing tool, since they change.

---

## The look, in one line

Halftone (printed-dot) cut-out elements + crisp edges with soft drop shadows + one flat bold colour field +
one sharp idea per scene. The full, reusable style spec and a paste-ready JSON style anchor live in
`references/style-system.md`. Read it before generating any still so the look stays consistent.

---

## STEP 0: Confirm the platform is ready

Load Higgsfield's tools with `tool_search` so you know its current image, upload, video, and display tool
names before any creative work. If Higgsfield is not connected, say so and offer to run on any other
connected image-plus-video platform (Runway, Magnific, ImagineArt, Arcads). If the user named a platform,
use that one.

Higgsfield defaults (confirm with `tool_search`):
- Image: `generate_image` with Nano Banana Pro or GPT Image 2 (strong instruction-following + reference images).
- Video (image-to-video): `generate_video` with Seedance 2.0 or Kling 3.0.
- Upload: `media_upload` then `media_confirm`, or `media_import_url` for a web URL.
- Display: `job_display`. Models: `models_explore`. Credits: `balance`.

---

## STEP 1: References in

Ask the user to paste one or more reference images (Pinterest is the usual source). If they describe a look
but attach nothing, ask for the images rather than guessing. If they already have a locked look from a prior
run, skip to Step 3 and reuse the saved style anchor.

Also capture, in the same message, the few brand facts the analysis needs to make the output *theirs* and not
a copy:
- Brand / project name and any tagline.
- Brand colours (the flat background colour matters most) and any must-use palette.
- Subject or concept for this scene (the "idea" / visual pun).
- Aspect ratio: 9:16 (Reels/TikTok/Stories), 1:1 (feed), or 16:9 (YouTube/site).
- Clip length: 5s (sting), 10s (standard), 15s (promo).

---

## STEP 2: Analyse the references

Decode each reference to replication-grade depth, the way the `image-analysis` methodology does: medium,
composition, subject and styling, exact colour with hex, lighting, camera, texture (call out the halftone),
post-processing, typography, and mood. Do not summarise, take it apart. For several references, analyse each,
then write one **shared style summary** that captures the common visual system.

Then fuse three things into a single locked recipe for this project:
1. The shared style of the references.
2. The fixed stop-motion style system from `references/style-system.md`.
3. The user's brand facts from Step 1.

Output the fused recipe as a self-contained JSON prompt (schema in `references/style-system.md`). This JSON is
the project's reusable base: lock it once, then later scenes only change the `idea`/subject field. Show the
user the short breakdown plus the `style_signature` line and confirm before generating.

---

## STEP 3: Generate the on-brand stills

For each scene you generate **two images from the same recipe**, because the motion step needs both ends of
the assembly:

1. **The full still** the finished composition: flat colour field, halftone cut-out elements with clean edges
   and soft shadows, the idea clearly read.
2. **The empty plate** the exact same scene with every cut-out element removed, leaving only the bare flat
   background (plus any always-present base like a floor line or horizon). Generate this from the same recipe
   with an instruction to remove all foreground elements and keep the background identical.

Use the platform's strongest instruction-following text-to-image model, passing an approved reference as a
reference image when supported, so colour and texture match. Generate, display both, and ask: "Do these work,
or want changes?" Regenerate with an adjusted prompt if needed. Keep the empty plate and the full still
visually identical except for the elements, this is what makes the assembly read cleanly.

If the user has their own finished still already, treat it as the full still, and generate only the matching
empty plate from it.

---

## STEP 4: Pick

Let the user point at the still(s) they want to animate, in the same chat. Carry the chosen full still and its
matching empty plate into the motion step.

---

## STEP 5: Animate, the assembly motion

This is the signature step. Drive an image-to-video generation so the scene **builds from the empty plate to
the full still**. The full recipe, the keyframe vs prompt-driven approaches, and ready prompt templates are in
`references/motion-recipe.md`. Read it before generating.

In short:
- Preferred: pass the **empty plate as the start frame** and the **full still as the end / last frame** if the
  model supports two keyframes, so the model interpolates the pieces flying in and locking.
- Fallback: start from the empty plate and prompt the elements to slide in from the edges and snap into the
  final composition, naming them in assembly order.
- Keep motion crisp and deliberate: elements enter from off-frame, settle with a small overshoot, slight
  stagger between them, soft shadow lands as each piece sets. No drifting, no zoom-on-finished-image.

Generate with the platform's strongest image-to-video model at the chosen length and aspect ratio, then
display the result.

---

## STEP 6: Review and scale

Present the video and ask what they think. Options: keep it; re-edit (regenerate with an adjusted motion
prompt, same stills); or make another scene. To scale, keep the locked recipe from Step 2 and change only the
idea/subject per new scene, then run Steps 3 to 5 again. A whole set comes out of one locked look, which is
what makes the library read as one brand instead of one-offs.

---

## Rules

- **Assembly or it's wrong.** Empty plate to full still. If the scene does not build itself, regenerate. Never
  ship a wobble or a zoom on a finished frame.
- **Two images per scene.** Always generate the empty plate alongside the full still; the motion step needs both.
- **Lock the look once.** The fused JSON recipe is the brand base. Reuse it across scenes; vary only the idea.
- **Make it theirs.** Learn the reference's recipe and re-cook it in the user's colours, subjects, and ideas.
  Do not clone a specific artist's distinctive work; use references for direction, not duplication.
- **No em dashes** in any text shown to the user; use periods or line breaks.
- **Never hardcode tool names or model IDs.** Confirm with `tool_search` and the model-listing tool each time.
- **Credits:** if the user is cost-conscious, check the balance before generating.
- **On failure:** explain briefly, offer a retry with adjusted parameters, or offer to switch platform.

---

## Reference files

- `references/style-system.md`: the fixed stop-motion editorial look, plus the JSON style/recipe schema and a
  worked example. Read before generating stills.
- `references/motion-recipe.md`: the empty-plate to full-still assembly recipe, keyframe and prompt-driven
  approaches, and Higgsfield prompt templates. Read before animating.
