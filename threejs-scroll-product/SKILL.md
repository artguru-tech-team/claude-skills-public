---
name: threejs-scroll-product
description: Build a scroll-driven 3D product landing page using Three.js + GSAP ScrollTrigger. Loads a GLB model, sets up scene/lights/renderer, wires scroll to 3D animation via GSAP ticker, handles mobile fallback and GPU cleanup. Trigger on "fais une page produit 3D", "scroll animation three.js", "build a threejs product page", "3D product storytelling", or /threejs-scroll-product.
user_invocable: true
arguments: product description, GLB path or URL, brand colors, target framework (vanilla/react/nextjs)
---

# Three.js Scroll-Driven Product Page Skill

Génère une page produit avec animation 3D scroll-driven complète : Three.js + GSAP ScrollTrigger + Lenis smooth scroll. Production-ready avec optimisations perf et mobile fallback.

## Architecture (les 4 couches)

```
HTML/DOM sections (scroll container)
  ↓ trigger
GSAP ScrollTrigger (bridge: scroll → 0..1)
  ↓ mapped values
Three.js Scene Graph (Scene → Group → Mesh → Material)
  ↓ rendered by
WebGL Renderer → <canvas alpha:true flottant sur HTML>
```

## Phase 0 — Discovery

Demander en UNE question si pas fourni dans les args :

```
Pour générer ta page produit 3D, j'ai besoin de :
1. Description du produit (ex: "bouteille de parfum", "sneaker")
2. Chemin du modèle GLB (ex: /public/product.glb) — ou "à créer"
3. Couleurs brand : fond (hex) + accent (hex)
4. Framework cible : [vanilla JS / React + Vite / Next.js]
5. Archétype scroll : [Centered Biography / Fly-Through / Spec Breakdown]
```

Ne pas continuer sans au minimum : description produit + framework.

Si pas de GLB disponible : utiliser une primitive Three.js (TorusKnot, Box, Sphere) comme placeholder et indiquer au user comment remplacer.

---

## Phase 1 — Setup Projet

### Vanilla JS (CDN, zéro bundler)

```html
<!-- index.html -->
<script type="importmap">
{
  "imports": {
    "three": "https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.module.js",
    "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.160.0/examples/jsm/",
    "gsap": "https://cdn.jsdelivr.net/npm/gsap@3.12.5/index.js",
    "gsap/ScrollTrigger": "https://cdn.jsdelivr.net/npm/gsap@3.12.5/ScrollTrigger.js",
    "lenis": "https://cdn.jsdelivr.net/npm/lenis@1.1.9/dist/lenis.mjs"
  }
}
</script>
<script type="module" src="main.js"></script>
```

### React + Vite

```bash
npm create vite@latest product-3d -- --template react
cd product-3d
npm install three @react-three/fiber @react-three/drei gsap lenis
```

### Next.js

```bash
npx create-next-app@latest product-3d --ts --tailwind --app
cd product-3d
npm install three @react-three/fiber @react-three/drei gsap lenis
```

Pour Next.js, importer le canvas dynamiquement (éviter SSR) :
```js
const ProductCanvas = dynamic(() => import('@/components/ProductCanvas'), { ssr: false })
```

---

## Phase 2 — Scene Setup

### Vanilla JS (main.js)

```js
import * as THREE from 'three'
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import Lenis from 'lenis'

gsap.registerPlugin(ScrollTrigger)

// ── Renderer ─────────────────────────────────────────────
const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true })
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))  // DPR clamp obligatoire
renderer.setSize(window.innerWidth, window.innerHeight)
renderer.shadowMap.enabled = true
document.body.appendChild(renderer.domElement)

// Canvas flottant sur le HTML
Object.assign(renderer.domElement.style, {
  position: 'fixed', top: 0, left: 0,
  width: '100%', height: '100%',
  pointerEvents: 'none', zIndex: 1
})

// ── Scene + Camera ────────────────────────────────────────
const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera(15, window.innerWidth / window.innerHeight, 0.1, 1000)
camera.position.z = 30  // FOV étroit + Z éloigné = effet cinématique

// ── Lighting rig ──────────────────────────────────────────
scene.add(new THREE.HemisphereLight(0xffffff, 0x444444, 1.5))

const dirLight = new THREE.DirectionalLight(0xffffff, 2)
dirLight.position.set(5, 10, 7.5)
dirLight.castShadow = true
scene.add(dirLight)

const pointLight = new THREE.PointLight(0xffffff, 3)
pointLight.position.set(-5, 5, 5)
scene.add(pointLight)

// ── Load GLB ──────────────────────────────────────────────
const group = new THREE.Group()
scene.add(group)

const loader = new GLTFLoader()
loader.load('/product.glb', (gltf) => {
  const model = gltf.scene
  model.traverse(child => {
    if (child.isMesh) child.castShadow = true
  })
  group.add(model)
  initScrollAnimations(group)  // wirer après chargement
})

// Fallback si pas de GLB
// const geo = new THREE.TorusKnotGeometry(1, 0.3, 128, 32)
// const mat = new THREE.MeshStandardMaterial({ color: 0x00c8ff, metalness: 0.8, roughness: 0.2 })
// group.add(new THREE.Mesh(geo, mat))
```

### React Three Fiber (ProductCanvas.jsx)

```jsx
import { useRef } from 'react'
import { Canvas } from '@react-three/fiber'
import { useGLTF, Environment, Float } from '@react-three/drei'
import { useGSAP } from '@gsap/react'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

function ProductModel({ url }) {
  const { scene } = useGLTF(url)
  const ref = useRef()

  useGSAP(() => {
    gsap.timeline({
      scrollTrigger: {
        trigger: '.hero',
        start: 'top top',
        end: '+=2000',
        scrub: 3,
        pin: true,
      }
    })
    .to(ref.current.rotation, { y: Math.PI * 2 })
    .to(ref.current.position, { y: -0.5, z: -2 }, '<')
  })

  return <primitive ref={ref} object={scene} />
}

export default function ProductCanvas({ glbUrl }) {
  return (
    <Canvas
      style={{ position: 'fixed', inset: 0, pointerEvents: 'none' }}
      camera={{ fov: 15, position: [0, 0, 30] }}
      gl={{ alpha: true, antialias: true }}
      dpr={[1, 2]}  // clamp DPR
    >
      <hemisphereLight intensity={1.5} />
      <directionalLight position={[5, 10, 7.5]} intensity={2} castShadow />
      <pointLight position={[-5, 5, 5]} intensity={3} />
      <ProductModel url={glbUrl} />
      <Environment preset="city" />
    </Canvas>
  )
}
```

---

## Phase 3 — GSAP ScrollTrigger Bridge (le cœur)

### Règle absolue : déléguer le render loop au gsap.ticker

```js
// JAMAIS ça (async, jitter) :
// window.addEventListener('scroll', () => renderer.render(scene, camera))

// TOUJOURS ça :
const lenis = new Lenis()

gsap.ticker.add((time) => {
  lenis.raf(time * 1000)           // smooth scroll frame-by-frame
  renderer.render(scene, camera)   // render WebGL dans le même pass
})
gsap.ticker.lagSmoothing(0)
```

### Archétype 1 — Centered Product Biography (produit au centre, specs autour)

```js
function initScrollAnimations(model) {
  // Phase 1 : Hook — fly-in à l'arrivée
  gsap.from(model.position, { y: -3, duration: 1.2, ease: 'power3.out' })
  gsap.from(model.rotation, { x: 0.5, duration: 1.2, ease: 'power3.out' })

  // Phase 2 : Pinned — rotation + fade HTML copy
  const tl = gsap.timeline({
    scrollTrigger: {
      trigger: '.section-specs',
      start: 'top top',
      end: '+=3000',
      scrub: 3,
      pin: true,
      immediateRender: false,  // évite pre-render inutile
    }
  })

  tl.to('.hero-copy', { autoAlpha: 0, filter: 'blur(40px)', duration: 0.3 })
    .to(model.rotation, { y: Math.PI * 2 }, '<')
    .to(camera.position, { z: 20 }, '<0.5')
    .to('.spec-1', { autoAlpha: 1, x: 0, duration: 0.3 }, 0.3)
    .to('.spec-2', { autoAlpha: 1, x: 0, duration: 0.3 }, 0.5)

  // Phase 3 : CTA — model slide out
  gsap.timeline({
    scrollTrigger: {
      trigger: '.section-cta',
      start: 'top bottom',
      end: 'top top',
      scrub: 2,
    }
  })
  .to(model.position, { y: -5 })
  .to('.cta-button', { autoAlpha: 1, y: 0 }, '<0.5')
}
```

### Archétype 2 — Spec Breakdown (style Apple)

Modèle fixe, contenu défile à gauche, vidéo/texture du modèle change selon la section visible.

```js
const sections = document.querySelectorAll('.spec-section')

sections.forEach((section, i) => {
  ScrollTrigger.create({
    trigger: section,
    start: 'top center',
    end: 'bottom center',
    onEnter: () => swapModelTexture(i),
    onEnterBack: () => swapModelTexture(i - 1),
  })
})

function swapModelTexture(index) {
  const textures = ['/tex-1.jpg', '/tex-2.jpg', '/tex-3.jpg']
  const texture = new THREE.TextureLoader().load(textures[index])
  model.traverse(child => {
    if (child.isMesh) child.material.map = texture
  })
}
```

### Archétype 3 — GLTF Pre-baked Keyframes (animation Blender scrubbing)

```js
const mixer = new THREE.AnimationMixer(model)
const action = mixer.clipAction(gltf.animations[0])
action.play()
action.paused = true  // on contrôle manuellement

ScrollTrigger.create({
  trigger: '.section-anim',
  start: 'top bottom',
  end: 'bottom top',
  scrub: true,
  onUpdate: (self) => {
    action.time = action.getClip().duration * self.progress
    mixer.update(0)
  }
})
```

---

## Phase 4 — HTML Structure

```html
<body>
  <!-- Canvas injecté par Three.js (fixed, pointer-events:none, z-index:1) -->

  <!-- Sections scroll normales (z-index:2 pour être au-dessus du canvas) -->
  <section class="hero section-fullscreen" style="z-index:2">
    <div class="hero-copy">
      <h1>Product Name</h1>
      <p class="subtitle">Tagline qui claque</p>
    </div>
  </section>

  <section class="section-specs section-fullscreen">
    <div class="spec-1" style="opacity:0; transform:translateX(-30px)">Feature 1</div>
    <div class="spec-2" style="opacity:0; transform:translateX(-30px)">Feature 2</div>
  </section>

  <section class="section-cta section-fullscreen">
    <button class="cta-button" style="opacity:0; transform:translateY(20px)">
      Buy Now
    </button>
  </section>
</body>

<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: #0D0B12; color: white; overflow-x: hidden; }
  .section-fullscreen { min-height: 100vh; display: flex; align-items: center; justify-content: center; }
</style>
```

---

## Phase 5 — Optimisations & Cleanup

### Responsive (resize)
```js
window.addEventListener('resize', () => {
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})
```

### Mobile fallback (skip WebGL sous 768px)
```js
if (window.innerWidth < 768) {
  // Montre une image statique du produit
  document.getElementById('product-fallback-img').style.display = 'block'
  // NE PAS initialiser Three.js ni le renderer
} else {
  initThreeJS()
}
```

### Memory leak cleanup (SPA / React unmount)
```js
// Vanilla JS
function destroy() {
  // Kill GSAP
  ScrollTrigger.getAll().forEach(t => t.kill())
  gsap.ticker.remove(tickerCallback)

  // Dispose Three.js assets
  scene.traverse(child => {
    if (child.isMesh) {
      child.geometry.dispose()
      if (Array.isArray(child.material)) child.material.forEach(m => m.dispose())
      else child.material.dispose()
    }
  })

  // Libérer GPU
  const gl = renderer.getContext()
  gl.getExtension('WEBGL_lose_context')?.loseContext()
  renderer.dispose()
  renderer.domElement.remove()
}

// React useEffect
useEffect(() => {
  return () => destroy()
}, [])
```

### GLB optimization checklist (avant d'importer dans Blender)
```
☐ Appliquer tous les modifiers avant export
☐ Activer Draco compression (export GLTF → Compression = Draco)
☐ Downscaler textures : ≤ 1024px pour mobile, ≤ 2048px pour desktop
☐ Supprimer les objets invisibles et les bones inutilisés
☐ Vérifier taille finale : < 3MB idéal, < 10MB max
```

---

## Checklist de livraison

```
☐ Scene setup : Renderer alpha, Camera FOV 15, z=30
☐ Lighting rig : HemisphereLight + DirectionalLight + PointLight
☐ GLB chargé (ou primitive placeholder en attendant)
☐ Lenis + gsap.ticker synchronisés (zéro jitter)
☐ ScrollTrigger wiré avec scrub + pin sur sections clés
☐ HTML sections z-index:2 pour flotter sur le canvas
☐ DPR clampé à Math.min(devicePixelRatio, 2)
☐ Mobile fallback actif sous 768px
☐ Resize handler sur camera.aspect + updateProjectionMatrix
☐ Cleanup destroy() sur unmount/navigation
☐ Page testée en Lighthouse : Performance ≥ 70 desktop
```

---

## Références (sources de ce skill)

- Tutorial de référence produit : [Build 3D Ecommerce — Next.js + GSAP + Three.js](https://www.youtube.com/watch?v=RKQqrNyAC6k)
- Pattern Apple clone : [React 3D — WebGi + GSAP](https://www.youtube.com/watch?v=IyBhFma4H1A)
- Product page scroll alive : [GSAP + Three.js Product Animation](https://www.youtube.com/watch?v=gIPk9j4byQs)
- Architecture technique : [Scroll-Driven Presentation Three.js](https://medium.com/@pablobandinopla/scroll-driven-presentation-in-threejs-with-gsap-a2be523e430a)
- Memory cleanup : [Codrops WebGL + Barba.js cleanup](https://tympanus.net/codrops/2026/02/02/building-a-scroll-revealed-webgl-gallery-with-gsap-three-js-astro-and-barba-js/)
