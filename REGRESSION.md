# Integrity & Regression Checklist

## Unit tests
```bash
flutter test
```

## Manual regression (po `flutter run -d chrome`)
- [ ] PIN 1234 pri štarte odomkne appku
- [ ] Eye toggle skryje/zobrazí zostatok
- [ ] Po 60 s nečinnosti sa zostatok automaticky skryje
- [ ] Skeleton ~450 ms pri prvom načítaní Prehľadu
- [ ] Karty carousel scrolluje, detail umožňuje blok/limity
- [ ] Call sheet sa otvorí
- [ ] QR generuje a dekóduje 0001* / SPD*
- [ ] Platby + šablóny fungujú
- [ ] Hypotéka kalkulačka počíta
- [ ] Dark mode prepína
- [ ] CSV export toast
- [ ] Bottom nav (Prehľad / Objavujte / Kontakty)

## Vercel deploy (až po green tests)
```bash
flutter build web --release --base-href /
# vercel --prod  alebo Git push
```
