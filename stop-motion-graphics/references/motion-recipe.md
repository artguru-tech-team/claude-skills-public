# The Assembly Motion Recipe

The signature motion: the clip opens on the **empty plate** (bare flat background) and ends on the **full
still** (all cut-outs locked in). The elements travel in from the edges and snap into place. This is the whole
trick, and it only works because you start from an empty surface, which gives the model a real job to do
rather than wobbling a finished frame.

## Two ways to drive it

### A. Keyframe (preferred when the model supports first + last frame)

Pass two keyframes so the model interpolates the build:
- **Start frame / first image** = the empty plate.
- **End frame / last frame** = the full still.

On Higgsfield image-to-video (`generate_video`, confirm with `tool_search`), look for a start-image plus
end/last-image pair. Parameter names vary by model and change often (for example `start_image`,
`first_frame`, `end_image`, `last_frame`, `keyframes`); read the loaded tool description and use whichever
applies. Add a short prompt describing the assembly so the in-between is elements flying in, not a crossfade
(see templates below).

### B. Prompt-driven (when only one input image is supported)

Start from the empty plate as the single input image and describe the assembly explicitly in the prompt:
name each element, the edge it enters from, and the order. The full still is your visual target; describe its
final composition as the end state.

Either way, the motion direction is the same; only the wiring differs.

## Motion direction (put this in every prompt)

- Elements enter from off-frame edges, one or a few at a time, with a slight stagger between them.
- Each piece slides or pops in fast, then settles with a small overshoot and snap (paper-cut-out feel).
- The soft drop shadow appears as each piece lands, selling the lift off the background.
- Background stays perfectly still and flat the whole time.
- Text / logo cuts in last as the lock.
- End on the full composition, held steady for the final beat.
- Strictly no slow zoom, no drift, no parallax on a finished image, no camera move on the background.

## Length and pacing

- 5s: 3 to 5 elements, quick assembly, ~1s final hold on the complete scene.
- 10s: fuller build, staggered entrances, ~1.5 to 2s final hold.
- 15s: more elements or a two-beat build (base elements, then the punchline element), ~2 to 3s final hold.

## Higgsfield prompt templates

Fill the brackets from the locked recipe and the scene's element list. Keep it crisp and literal.

**Keyframe approach (start = empty plate, end = full still):**
```
Stop-motion graphic assembly. Start on an empty flat [color_hex] background. Paper cut-out halftone elements
fly in from the edges and snap into place to build the final scene: [element 1] in from [edge], then
[element 2] from [edge], then [element 3] from [edge]; [text] cuts in last. Each piece enters fast, settles
with a small overshoot, soft drop shadow lands as it sets. Background stays flat and still. Crisp editorial
motion-graphics timing, slight stagger between pieces. End holding the complete composition. No zoom, no
drift, no camera move. [duration]s, [aspect_ratio].
```

**Prompt-driven approach (single input = empty plate):**
```
Animate this empty [color_hex] background into a finished stop-motion graphic scene. Halftone paper cut-out
elements assemble from off-frame: [element 1] slides in from [edge] and locks; [element 2] pops in from
[edge]; [element 3] from [edge]; finally [text] cuts in. Fast entrances, small overshoot and snap, soft
shadow on landing. Flat background never moves. Deliberate editorial timing with a slight stagger. Finish on
the full composition and hold. No zoom, no pan, no parallax. [duration]s, [aspect_ratio].
```

## Quality check before delivering

- Does it actually start empty and end full? If it starts already-built, the wiring is wrong, fix the start
  frame.
- Do pieces enter from edges and snap, rather than fade in place? If they crossfade, strengthen the assembly
  language or switch to the keyframe approach.
- Is the background dead still and flat? Any drift or zoom means regenerate.
- Does the final frame match the approved full still? If elements land in the wrong spots, tighten the
  per-element edge/position description.
