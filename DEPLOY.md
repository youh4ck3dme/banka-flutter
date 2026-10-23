# Deploy na Vercel (Flutter Web)

## Predpoklady
- Flutter SDK nainštalovaný lokálne
- Vercel CLI alebo Vercel Git integrácia

## Build
```bash
flutter build web --release --base-href /
```

Výstup bude v `build/web/`.

## Vercel
`vercel.json` je už pripravený na prebuilt output (`outputDirectory: "build/web"`).

### Možnosti deployu
1. **Git** – pushni repo, v Vercel nastav Build Command na `flutter build web --release` (ak máš Flutter v build image) alebo uploaduj prebuilt.
2. **Prebuilt** – po `flutter build web` uploadni obsah `build/web` alebo použi Vercel CLI s prebuilt.

## Poznámky
- PWA manifest a service worker sú v `web/`
- Brand: žltá #FFD500
- Demo PIN: 1234
