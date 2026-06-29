---
name: motion-design
description: >
  Motion design creation skill that works across any connected generation platform (Higgsfield, Runway, Magnific, Arcads, Ideogram, ImagineArt, or any MCP that can generate images and video). Trigger this skill whenever the user asks to create motion design, animate a logo, make a video from an image, create an animated ad, turn a product into motion, or says anything like "make a motion", "motion design", "animate this", "make a video from my logo", "animated brand", "motion graphics", "brand motion", "kinetic graphics", "promo video", "ad video". Always use this skill. Don't try to handle motion design requests without it.
---

# Motion Design Skill

You are guiding the user through a full motion design creation flow. The creative process is the same no matter which generation platform you run on. Your job is to drive the workflow (brief, storyboard, video, iterate) and map each step onto whatever image and video generation tools the user has connected. Follow each step in order. Be concise and direct. Speak in the same language the user is using.

This skill is platform-agnostic on purpose. Higgsfield, Runway, Magnific, Arcads, Ideogram, ImagineArt, and similar connectors all expose the same core building blocks: generate an image, upload an asset, animate an image into video, and show the result. Pick the platform first, then use that platform's own tools for every step.

---

## What this skill needs from a platform

The flow needs five capabilities. Every supported platform has them, just under different tool names:

1. Generate an image from text, ideally with reference-image support.
2. Upload or register a user-provided asset (logo, product photo).
3. Generate a video from an image (image-to-video), or from text.
4. Display or retrieve the finished result.
5. Optional: list available models, and check remaining credits.

Never hardcode tool names or model IDs from memory. Use `tool_search` to load the chosen connector's tools, then read the tool descriptions to find the right one for each capability. Tool names and model IDs change often, so always confirm against what is actually loaded rather than assuming. A compact reference of strong defaults per platform is at the bottom of this skill.

---

## STEP 0: Pick the generation platform

Decide which platform to run on before any creative work:

- If the user named a platform (for example "make this in Runway", "use Higgsfield", "do it on Arcads"), use that one.
- If only one suitable image-plus-video connector is available, use it silently.
- If several are connected and the user did not specify, ask once:

> "Which platform should I use for this? You've got [list the connected options]."

Once chosen, load that platform's tools with `tool_search` so you know its exact image, upload, and video tool names before continuing. If a platform can only do images and not video (for example Ideogram), use it for the base image or storyboard, then animate on a platform that does image-to-video.

---

## STEP 1: Determine the flow type

Identify which workflow applies:

**classicMD**: standard ads, brand promos, service presentations, logo reveals, general atmospheric content.
**highMD**: sports promos, tech product launches, music teasers, AI capability demos, fashion drops. Prioritizes extreme camera speed, aggressive cuts, peak dynamics. Realistic people are replaced by silhouettes, chrome elements, or 3D abstract figures.

If the user's request makes the flow obvious, proceed silently. If ambiguous, ask:

> "Which style fits your project better?"

Options:
- **Classic Motion**: smooth transitions, elegant typography, cinematic feel.
- **Hyper / Kinetic**: fast cuts, extreme dynamics, aggressive transitions, CGI energy.

---

## STEP 2: Brief intake (single message, all at once)

Ask all intake questions in **one message** using `ask_user_input_v0`. Do not split into multiple questions.

Questions to ask simultaneously:

1. **Do you have existing assets?**
   - Yes, I'll upload a logo / product photo / reference
   - No, help me create the visual

2. **Video duration:**
   - 5 sec: teaser / logo sting
   - 10 sec: standard post / stories
   - 15 sec: promo / product video

3. **Frame format:**
   - 16:9: horizontal (YouTube, website)
   - 9:16: vertical (Reels, TikTok, Stories)
   - 1:1: square (Feed)

4. **Mood / style:** *(free input)*
   Example prompts: energetic, minimalist, luxury, technological, atmospheric, aggressive, cinematic

5. **Brand name / product name and tagline** *(if any)*

6. **Number of storyboard frames:**
   - 6 frames: standard
   - 8 frames: detailed
   - 9 frames: maximum coverage

Save all answers before proceeding.

---

## STEP 3: Asset handling

### If user HAS assets:

Ask them to upload the file directly in chat. Accept PNG, JPG, SVG, or any image.

Once uploaded, note the file path from the uploads folder, then register it with the chosen platform's media-upload tool. Platforms differ here: some need an upload step followed by a confirm step, some accept a direct URL import, and some (like Arcads) ingest a local path automatically. Read the tool description to see which pattern applies. Then proceed to **STEP 4**.

### If user has NO assets:

Generate a base visual with the platform's strongest text-to-image model that follows instructions well and supports reference images. Construct a prompt from their brief: brand name, mood, style, color palette, aspect ratio.

Pick the model by capability, not by a fixed name. Confirm available image models with the platform's model-listing tool if unsure, and prefer the highest-quality variant the account can run. See the platform reference at the bottom for good starting points.

Generate the image, display it, then ask: "Does this image work or would you like changes?" If changes are needed, regenerate with an adjusted prompt. Once approved, proceed.

---

## STEP 4: Generate the Storyboard

This is the core creative step. Generate a storyboard with N frames (where N = the count chosen in Step 2: 6, 8, or 9).

**Each frame must:**
- Be visually consistent with the approved asset / generated image
- Represent a distinct moment in time (opening, build, climax, resolution, logo lock)
- Show camera position, subject state, motion blur / freeze where relevant
- Include a 2 to 4 word text caption burned into the frame (scene label, not subtitle)

**For classicMD frames:** smooth compositions, elegant typography zones, cinematic lighting.
**For highMD frames:** peak-action freeze frames such as frozen splashes, shattered elements, material stretch, aggressive camera angles, neon contrast.

**Generation approach:**

Call the platform's text-to-image tool **once** to generate a **single storyboard sheet**: one image containing all N panels arranged in a grid. Do NOT generate N separate images. Use a strong instruction-following image model so the panel labels and layout come out clean.

Pass the approved asset / generated visual as a reference image in the call if the platform's image tool supports references.

Construct the prompt as:
```
Storyboard sheet with [N] sequential panels in a grid layout, each panel labeled "Frame 1", "Frame 2", etc. Panel 1: [scene description]. Panel 2: [scene description]. ... Panel N: [logo lock / brand name]. Each panel shows: [camera angle], [motion state], [mood/lighting]. Visual style: [cinematic/kinetic]. Consistent color palette throughout. Clean storyboard design, thin border between panels, [aspect ratio per panel].
```

After the single image is generated, display it.

Then present the storyboard summary:

---
**Storyboard: [Brand Name]**
🎬 Frame 1: [brief scene description]
✨ Frame 2: [brief scene description]
... (all frames)
🏁 Frame N: [logo lock / CTA]

**Mood:** [mood]
**Motion:** [motion description, for example spiral flythrough, match-cut, slow push]
**Ending:** [how the video ends]
---

Ask:
> "How does the storyboard look? Approve or any changes?"

Options:
- **Approve** : proceed to STEP 5
- **Changes needed** : ask what to change, regenerate the storyboard sheet with corrections, repeat approval

---

## STEP 5: Generate the Video

Once the storyboard is approved, generate the final video with the platform's strongest image-to-video model. Confirm the exact model ID with the platform's model-listing tool if needed, and prefer the best-quality option the account supports.

**Construct the video generation prompt** combining:
- Approved storyboard narrative (scene sequence)
- Flow type (classicMD / highMD)
- Duration from Step 2
- Aspect ratio from Step 2
- Mood and style from Step 2
- Brand name / slogan for logo lock at the end

**classicMD prompt template:**
```
[Style]: smooth motion design, [scene flow from storyboard], elegant transitions, [mood] atmosphere, cinematic camera movement, [duration]s, brand reveal at end: [brand name], [aspect ratio]
```

**highMD prompt template:**
```
[Style]: high-intensity kinetic motion, [scene flow from storyboard], extreme camera speed, aggressive match-cuts, peak-action freeze frames, [mood] CGI aesthetic, neon contrast, [duration]s, hard stop logo lock: [brand name], [aspect ratio]
```

**For highMD:** the final seconds must be a static hold on the brand name / logo. Build this into the prompt explicitly. Scale proportionally: about 1 sec for 5s clips, about 2 sec for 10s clips, about 2 to 3 sec for 15s clips.

**Start frame:** pass the original uploaded asset (if the user had one), otherwise the first approved storyboard frame, as the video's starting image. Platforms expose this through different parameter names such as `start_image`, `startFrame`, `firstSceneImage`, `image_url`, or `referenceImages`. Read the tool description and use whichever one applies.

Generate the video, then display the result.

---

## STEP 6: Review & Iterate

When the video renders, present it and ask:

> "Done! 🎬 What do you think?"

Options:
- **Love it, downloading** : done
- **Want a different edit** : regenerate with an adjusted prompt, keep the same storyboard
- **Want a different style** : go back to Step 1 with a new style/mood
- **Make another version** : generate a second version with a slight prompt variation. If the platform supports a batch/count parameter, use it to render variations in one call

---

## Notes & Rules

- **Platform-agnostic first:** the workflow never changes, only the tools do. Pick the platform in Step 0, load its tools with `tool_search`, and map each step onto that platform's image, upload, video, and display tools.
- **Never hardcode tool names or model IDs.** Confirm them with `tool_search` and the platform's model-listing tool every time, because they change.
- **Image step:** use the platform's strongest instruction-following text-to-image model with reference-image support. Prefer the highest-quality variant the account can run.
- **Video step:** use the platform's strongest image-to-video model. Prefer the best-quality option available.
- **Storyboard = one image:** a single grid sheet with all N panels, generated in one image call. Never generate N separate images.
- **No moodboard step:** go directly from brief to storyboard.
- **highMD rule:** no realistic humans, only silhouettes, chrome figures, or 3D abstract shapes.
- **highMD rule:** logo lock duration is proportional to clip length (about 1s / 2s / 2 to 3s for 5s / 10s / 15s clips), built into the prompt.
- **classicMD logo:** can appear as opener, closer, or both. Ask if not specified.
- **Language:** always match the user's language.
- **Credits:** if the user seems concerned about usage, check the balance with the platform's credit tool before generating.
- **On failure:** explain briefly and offer a retry with adjusted parameters, or offer to switch to another connected platform.

---

## Platform reference (starting points, confirm with `tool_search`)

These are good default model choices per platform. They are starting points, not hard rules. Always confirm the current model IDs and the exact tool names with `tool_search` and the platform's model-listing tool, since they change often.

**Higgsfield**
- Image: `generate_image` with Nano Banana Pro or GPT Image 2.
- Video: `generate_video` with Seedance 2.0 or Kling 3.0.
- Upload: `media_upload` then `media_confirm`, or `media_import_url` for a web URL.
- Display: `job_display`. Models: `models_explore`. Credits: `balance`.

**Runway**
- Image: `generate_image` (nano-banana-pro, gpt-image-2, or gen-4).
- Video: `generate_video` (seedance-2, kling-o3-pro, veo-3.1), or `generate_multishot_video` for a 3 to 5 scene sequence.
- Upload: `init_upload` then `complete_upload`. Status: `get_task`.

**Arcads**
- Image: `arcads_generate_image` (nano-banana-2, gpt-image-2, seedream).
- Video: `arcads_generate_video` (Kling 3.0), or model-specific tools like Seedance 2.0, Veo 3.1, Sora 2.
- Upload: local paths are uploaded automatically. Result: `arcads_get_asset`.

**Magnific**
- Image: `images_generate`.
- Video: call `video_plan` first, then `video_generate`. Poll with `creations_wait`.
- Upload: `creations_upload_image` (URL) or `creations_request_upload` then finalize.

**Ideogram** (image only, strong text rendering)
- Image: `generate_image` (Ideogram 4.0). Good for the base image or storyboard sheet.
- No native video. Animate the result on a platform that does image-to-video.

**ImagineArt**
- Image: `generate_image`. Video: `generate_video`.
- Status: `fetch_image_status` / `fetch_video_status`.
