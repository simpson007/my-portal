# Repository Guidelines

This repo is a Vite + Vue 3 + TypeScript single-page site with heavy UI/visual work (Three.js, GSAP, Tailwind). Use the notes below to keep changes consistent and easy to review.

## Project Structure & Module Organization
- `src/` holds app code; entry is `src/main.ts` and the root layout is `src/App.vue`.
- `src/components/` is split by domain; UI blocks live in `src/components/core/` and visual effects in `src/components/visual/`.
- `src/composables/` contains reusable Composition API helpers (naming pattern: `useX.ts`).
- `src/config/` stores content/config (example: `src/config/portals.ts`).
- `src/assets/` includes static assets and shaders (example: `src/assets/shaders/flowField.glsl`).
- `public/` is for static files copied as-is; `index.html` is the Vite entry template.

## Build, Test, and Development Commands
- `npm install`: install dependencies.
- `npm run dev`: start the Vite dev server with HMR.
- `npm run build`: run `vue-tsc` type checks, then build for production.
- `npm run preview`: serve the production build locally.

## Coding Style & Naming Conventions
- Indentation: 2 spaces; follow existing Vue SFC formatting.
- Vue SFCs use `<script setup lang="ts">` and the Composition API.
- Components use PascalCase filenames (e.g., `FloatingCard.vue`); composables use `useX` (e.g., `useI18n.ts`).
- Styling is Tailwind-first; keep utility classes readable and grouped logically.

## Testing Guidelines
- No automated test framework is configured yet.
- For validation, run `npm run build` and do a manual UI pass via `npm run dev`.
- If you add tests, document the runner and add a script in `package.json`.

## Commit & Pull Request Guidelines
- Git history only shows `first commit`, so no established commit convention exists.
- Use short, imperative summaries (e.g., "Add floating card hover states").
- PRs should include a brief summary, a verification note (commands run), and screenshots or short clips for UI changes.

## Configuration Notes
- Build tooling is configured in `vite.config.ts`, `tsconfig*.json`, `tailwind.config.js`, and `postcss.config.js`.
- Keep shader edits in `src/assets/shaders/` and note performance impacts when changing particle counts or effects.
