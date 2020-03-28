# My Elm Playground

TODO: Where to put index.html, assets and compiled files.

## Optimization

Uglifjs without pipe:
```
Success!

    Main ───> resources/public/elm.js

Compiled size:  144506 bytes  (resources/public/elm.js)
Minified size:   38126 bytes  (resources/public/elm.min.js)
Gzipped size:    13453 bytes
```

Uglifjs with pipe:
```
Success!

    Main ───> resources/public/elm.js

Compiled size:  144506 bytes  (resources/public/elm.js)
Minified size:   38311 bytes  (resources/public/elm.min.js)
Gzipped size:    13386 bytes
```
Terser without pipe:
```
Success!

    Main ───> resources/public/elm.js

Compiled size:  144506 bytes  (resources/public/elm.js)
Minified size:   29752 bytes  (resources/public/elm.min.js)
Gzipped size:    10905 bytes
```
Terser with pipe:
```
Success!

    Main ───> resources/public/elm.js

Compiled size:  144506 bytes  (resources/public/elm.js)
Minified size:   29752 bytes  (resources/public/elm.min.js)
Gzipped size:    10905 bytes
```