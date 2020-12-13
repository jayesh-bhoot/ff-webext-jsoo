# Build with `ocamlfind + js_of_ocaml`

```
ocamlfind ocamlc -package js_of_ocaml,js_of_ocaml-ppx,promise_jsoo -linkpkg -o bg.byte bg.ml

js_of_ocaml +promise_jsoo/indirect_promise.js bg.byte
```

# Build with dune

```
dune build --profile release bg.bc.js
```
