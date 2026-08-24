---
name: remotion-motion
description: Generate programmatic motion design videos for social media (Instagram Reels, TikTok, YouTube Shorts) using Claude Code + Remotion. Brand-parameterized: pass any brand config (colors, fonts, name) and get a ready-to-render 9:16 Remotion project. Trigger on "crée une vidéo motion", "fais un reel animé", "motion design pour [brand]", "video remotion [brand]", or when building social media video content programmatically.
---

# Remotion Motion Design Skill

Génère un projet Remotion complet, brand-paramétré, prêt à rendre en MP4 pour les réseaux sociaux (9:16, 30fps).

## Brands pré-configurées

Si le user mentionne une brand connue, charge directement sa config. Sinon, demande les 5 paramètres (voir Phase 0).

### Bakchich
```typescript
const BRAND = {
  name: 'Bakchich',
  colors: {
    primary: '#F5A623',       // orange brand
    secondary: '#E8453C',     // rouge accent
    background: '#0D0B08',    // dark chaud
    text: '#FFFFFF',
    muted: 'rgba(255,255,255,0.72)',
    pill: 'rgba(245,166,35,0.18)',
  },
  fonts: {
    heading: 'Syne',          // bold, impactful
    body: 'Inter',
  },
  handle: '@ba9chich.app',
  logo: 'public/images/bakchich-logo.svg',
};
```

### Melekbuilds / Clip2Earn
```typescript
const BRAND = {
  name: 'Clip2Earn',
  colors: {
    primary: '#00C8FF',       // cyan brand
    secondary: '#7DE8FF',
    background: '#0D0B12',
    text: '#FFFFFF',
    muted: 'rgba(255,255,255,0.75)',
    pill: 'rgba(0,200,255,0.15)',
  },
  fonts: {
    heading: 'Space Grotesk',
    body: 'Inter',
  },
  handle: '@clip2earn',
  logo: 'public/images/clip2earn-logo.svg',
};
```

---

## Phase 0 — Brand Discovery (skip si brand connue)

Si la brand n'est pas pré-configurée, demander en UNE seule question :

```
Pour créer ta vidéo motion, donne-moi :
1. Nom de la brand + handle social
2. Couleur principale (hex) + couleur de fond (hex)
3. Police souhaitée (ou "Inter" par défaut)
4. Logo disponible ? (oui/non + chemin si oui)
5. Ton : [Energique / Premium / Friendly / Edgy / Minimaliste]
```

Ne pas continuer sans au minimum : nom, couleur principale, fond.

---

## Phase 1 — Setup Projet

### 1a. Bootstrap Remotion
```bash
npx create-video@latest
# Répondre : TypeScript=yes, Tailwind=yes, template=blank
cd [project-name]
npx skills add remotion-dev/skills
# Sélectionner : Claude Code → Project → Symlink
npm install @remotion/google-fonts
```

### 1b. Structure de fichiers à créer
```
src/
  tokens.ts          ← brand config centralisée
  Root.tsx           ← enregistrement compositions
  MainSequence.tsx   ← composition principale
  components/
    HookCard.tsx     ← scène d'accroche (0-3s)
    ContentScene.tsx ← contenu principal (3-8s)
    OutroCard.tsx    ← CTA + handle (8-10s)
    Logo.tsx         ← logo brand réutilisable
public/
  images/            ← logo SVG brand
  audio/             ← musique de fond optionnelle
```

---

## Phase 2 — Générer les fichiers

### `src/tokens.ts` (adapter avec la brand passée en paramètre)
```typescript
import { loadFont as loadHeading } from '@remotion/google-fonts/[HeadingFont]';
import { loadFont as loadBody } from '@remotion/google-fonts/Inter';

const { fontFamily: headingFont } = loadHeading();
const { fontFamily: bodyFont } = loadBody();

export const BRAND = {
  name: '[BrandName]',
  handle: '[handle]',
  colors: {
    primary: '[primaryHex]',
    secondary: '[secondaryHex]',
    background: '[backgroundHex]',
    text: '#FFFFFF',
    muted: 'rgba(255,255,255,0.72)',
    pill: '[primary with 0.18 opacity rgba]',
  },
  fonts: {
    heading: headingFont,
    body: bodyFont,
  },
  logo: '[logo path or null]',
};

export const THEME = {
  fps: 30,
  width: 1080,
  height: 1920,
  safeZone: 64,   // obligatoire : masqué par UI TikTok/Reels
  gap: 24,
  radius: 20,
  // Timing presets
  t: {
    hookIn: [0, 20],       // spring entrée hook
    hookHold: [20, 80],    // hold
    hookOut: [80, 90],     // slide out
    contentIn: [90, 110],  // contenu entre
    ctaIn: [240, 260],     // CTA apparaît
  },
};
```

### `src/Root.tsx`
```typescript
import { Composition } from 'remotion';
import { MainSequence } from './MainSequence';
import { THEME } from './tokens';

export const RemotionRoot = () => (
  <>
    <Composition
      id="SocialReel"
      component={MainSequence}
      durationInFrames={300}  // 10s
      fps={THEME.fps}
      width={THEME.width}
      height={THEME.height}
    />
  </>
);
```

### `src/MainSequence.tsx`
```typescript
import { AbsoluteFill, Sequence, Audio, staticFile } from 'remotion';
import { BRAND, THEME } from './tokens';
import { HookCard } from './components/HookCard';
import { ContentScene } from './components/ContentScene';
import { OutroCard } from './components/OutroCard';

export const MainSequence: React.FC<{ title: string; subtitle: string; cta: string }> = ({
  title,
  subtitle,
  cta,
}) => (
  <AbsoluteFill style={{ backgroundColor: BRAND.colors.background }}>
    {/* Musique optionnelle */}
    {/* <Audio src={staticFile('audio/bg.mp3')} volume={0.12} /> */}

    {/* SCÈNE 1 : Hook 0-3s */}
    <Sequence from={0} durationInFrames={90}>
      <HookCard title={title} />
    </Sequence>

    {/* SCÈNE 2 : Contenu 3-8s */}
    <Sequence from={90} durationInFrames={150}>
      <ContentScene subtitle={subtitle} />
    </Sequence>

    {/* SCÈNE 3 : Outro/CTA 8-10s */}
    <Sequence from={240} durationInFrames={60}>
      <OutroCard cta={cta} />
    </Sequence>
  </AbsoluteFill>
);
```

### `src/components/HookCard.tsx` (pattern spring engagement)
```typescript
import { AbsoluteFill, spring, interpolate, useCurrentFrame, useVideoConfig } from 'remotion';
import { BRAND, THEME } from '../tokens';

export const HookCard: React.FC<{ title: string }> = ({ title }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Spring entrée = rebond physique → perception "vivante"
  const scale = spring({ frame, fps, config: { damping: 12, stiffness: 180, mass: 0.5 } });

  // Fade + slide-in texte décalé de 8 frames
  const textY = interpolate(frame, [8, 25], [40, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: (t) => t * (2 - t),
  });
  const textOpacity = interpolate(frame, [8, 22], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <AbsoluteFill style={{
      justifyContent: 'center',
      alignItems: 'center',
      padding: THEME.safeZone,
    }}>
      {/* Pill accentuée */}
      <div style={{
        transform: `scale(${scale})`,
        backgroundColor: BRAND.colors.pill,
        border: `1px solid ${BRAND.colors.primary}`,
        borderRadius: 100,
        padding: '8px 20px',
        marginBottom: 24,
      }}>
        <span style={{ color: BRAND.colors.primary, fontFamily: BRAND.fonts.body, fontSize: 14, fontWeight: 600 }}>
          {BRAND.name.toUpperCase()}
        </span>
      </div>

      {/* Titre principal */}
      <div style={{
        transform: `translateY(${textY}px)`,
        opacity: textOpacity,
        textAlign: 'center',
      }}>
        <h1 style={{
          fontFamily: BRAND.fonts.heading,
          fontSize: 72,
          fontWeight: 800,
          color: BRAND.colors.text,
          lineHeight: 1.1,
          margin: 0,
        }}>
          {title}
        </h1>
      </div>
    </AbsoluteFill>
  );
};
```

### `src/components/OutroCard.tsx`
```typescript
import { AbsoluteFill, interpolate, useCurrentFrame } from 'remotion';
import { BRAND, THEME } from '../tokens';
import { Logo } from './Logo';

export const OutroCard: React.FC<{ cta: string }> = ({ cta }) => {
  const frame = useCurrentFrame();

  const opacity = interpolate(frame, [0, 15], [0, 1], {
    extrapolateLeft: 'clamp', extrapolateRight: 'clamp',
  });

  return (
    <AbsoluteFill style={{
      justifyContent: 'flex-end',
      alignItems: 'center',
      padding: THEME.safeZone,
      paddingBottom: THEME.safeZone + 40,
      opacity,
    }}>
      <p style={{
        fontFamily: BRAND.fonts.heading,
        fontSize: 40,
        fontWeight: 700,
        color: BRAND.colors.primary,
        textAlign: 'center',
        marginBottom: 16,
      }}>{cta}</p>
      <p style={{
        fontFamily: BRAND.fonts.body,
        fontSize: 28,
        color: BRAND.colors.muted,
      }}>{BRAND.handle}</p>
    </AbsoluteFill>
  );
};
```

---

## Phase 3 — Contenu (à passer en paramètre)

Demander au user (ou à l'agent appelant) :

```
Pour générer la vidéo, donne-moi :
1. TITRE (hook) — max 6 mots, phrase choc
2. SOUS-TITRE (contenu) — 1-2 phrases
3. CTA (outro) — ex: "Télécharge l'app", "Link en bio"
4. Durée souhaitée : [10s / 15s / 30s]
5. Musique : [oui/non]
```

---

## Phase 4 — Render

```bash
# Preview
npm start

# Render MP4 social (qualité optimale)
npx remotion render src/index.ts SocialReel out/[brand]-reel.mp4 --crf=18

# Haute qualité (fichier plus lourd)
npx remotion render src/index.ts SocialReel out/[brand]-reel-hq.mp4 --crf=15
```

---

## Beat Sync — Musique réactive

### Formule BPM → frames
```typescript
const BPM = 120;  // adapter à ta track
const FPS = 30;
const FRAMES_PER_BEAT = (FPS * 60) / BPM; // 15 frames à 120 BPM

// Array de markers de beats sur toute la durée
const BEAT_MARKERS = Array.from(
  { length: Math.floor(300 / FRAMES_PER_BEAT) },
  (_, i) => Math.round(i * FRAMES_PER_BEAT)
);
```

### Composant beat-reactive
```typescript
const lastBeatFrame = BEAT_MARKERS.filter(b => b <= frame).at(-1) ?? 0;
const framesSinceBeat = frame - lastBeatFrame;

// Pulse qui rebondit sur chaque beat
const beatScale = spring({
  frame: framesSinceBeat,
  fps,
  config: { damping: 12, stiffness: 180, mass: 0.5 },
  from: 1.15,
  to: 1,
});
```

### Volume dynamique (fade-in/out sans éditeur audio)
```typescript
<Audio
  src={staticFile('audio/track.mp3')}
  volume={(f) =>
    interpolate(f,
      [0, 15, 275, 300],      // frames
      [0, 0.12, 0.12, 0],     // volumes (fade in 0.5s, hold, fade out 0.5s)
      { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
    )
  }
/>
```

### SFX sur transitions
```typescript
{/* Whoosh sur chaque changement de scène */}
<Sequence from={90} durationInFrames={5}>
  <Audio src={staticFile('audio/whoosh.mp3')} volume={0.6} />
</Sequence>

{/* Impact hit sur le beat d'intro */}
<Sequence from={0} durationInFrames={10}>
  <Audio src={staticFile('audio/impact-hit.mp3')} volume={0.8} />
</Sequence>
```

---

## Sources musicales royalty-free 2026

| Source | Spécialité | Prix |
|--------|-----------|------|
| **Artlist** | Bibliothèque premium, industry standard | ~$200/an |
| **Epidemic Sound** | Énorme catalogue, parfait Reels/TikTok | ~$15/mois |
| **Happy Editing** | Packs SFX transition (whoosh, riser, glitch) | À l'unité |
| **Pixabay Music** | Royalty-free gratuit | Gratuit |
| **YouTube Audio Library** | Safe pour YouTube | Gratuit |
| **Suno / Udio (AI)** | Génère tracks custom au BPM exact demandé | Freemium |

**BPM recommandés par brand :**
- Bakchich (énergie, orange) : 120-140 BPM — phonk, trap instrumental, boom bap
- Clip2Earn (tech, cyan) : 100-120 BPM — lo-fi electronic, synth pop
- Brand premium/minimaliste : 80-100 BPM — cinematic, ambient

---

## Techniques de cut qui génèrent de l'engagement

| Technique | Usage | Timing |
|-----------|-------|--------|
| **Smash Cut** | Coupe brutale + musique qui s'arrête simultanément | Reset attention toutes les 20-40s |
| **Jump Cut sur beat** | Saute dans le temps, aligné exactement sur le beat | ±1 frame du BEAT_MARKER |
| **Flow Cut** | Transition dans le sens du mouvement du sujet | 8-12 frames |
| **Match Cut** | Aligne formes similaires entre 2 scènes | 0.3-0.5s max |
| **Stagger texte** | Éléments décalés de 8-10 frames entre eux | Hold min 60 frames (2s) par item |

**Rehook obligatoire** : nouveau twist ou changement de pattern visuel toutes les 20-40s sinon le viewer part.

---

## Timing par plateforme

| Plateforme | Durée optimale | Esthétique | Safe zone |
|------------|---------------|------------|-----------|
| **Instagram Reels** | 12-20s | Design policé, transitions considérées | Centre 80%, rogné 4:5 sur feed |
| **YouTube Shorts** | 8-15s | Vitesse extrême, aucun lag | Éviter bord droit + tiers bas |
| **TikTok** | 12-20s | Raw, natif, captions kinétiques | Boutons UI masquent les bords |

**Timings critiques :**
- **0-3s** : Hook full-screen, 5-8 mots max → +50% rétention à 3s
- **Transitions** : 0.3-0.5s max — plus lent = amateurisme
- **Hold minimum** : 60 frames (2s) par item de liste
- **Loop de fin** : dernier frame = premier frame → double le watch time (auto-replay comptabilisé)
- **85% des vues sont sans son** → le rythme visuel doit fonctionner muet

---

## Règles visuelles (depuis `.claude/rules/content-design.md`)

- **SafeZone 64px obligatoire** sur tous les côtés — les UI TikTok/Reels masquent les bords
- **Texte sur fond dark** : minimum `rgba(255,255,255,0.72)` pour les éléments secondaires
- **Jamais de hex sombre (`< #888`) sur fond dark** — utiliser rgba blanc
- **Vérifier le contraste** de tous les éléments avant validation (voir content-design.md pour les 6 règles)
- **OLED mobile** : fond `#0D0B08` ou `#0D0B12` → meilleur rendu sur TikTok/Instagram

## Patterns engagement (source: NotebookLM e5e653b3)

| Pattern | Usage | Config recommandée |
|---------|-------|-------------------|
| `spring()` entrée | logos, cartes, badges | damping 12, stiffness 180, mass 0.5 |
| `interpolate` slide | textes, sous-titres | quad-out `(t) => t*(2-t)`, clamp |
| Stagger | listes, stats | décaler chaque item de 8-10 frames |
| Hold → exit | transitions de scènes | 60 frames hold avant slide-out |
| Pill animée | branding, labels | scale spring + border couleur primary |

## Passation à un autre agent

Pour déléguer ce skill à un agent, passer en contexte :

```
Utilise le skill /remotion-motion.
Brand : [bakchich | clip2earn | custom]
Si custom, fournir : { name, primary, secondary, background, handle, logo }
Contenu : { title, subtitle, cta, duration }
Output attendu : projet Remotion dans ./remotion-[brand]/ + render MP4
```

L'agent peut ensuite `npx remotion render` et uploader le MP4 directement.
