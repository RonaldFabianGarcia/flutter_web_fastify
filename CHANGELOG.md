
## 0.0.2

* Added support for passing custom arguments to `flutter build web` in `flutter_web_fastify`.
* Users can now specify additional build parameters dynamically.
    * **Examples:** 
        * flutter pub run flutter_web_fastify **--wasm**
        * flutter pub run flutter_web_fastify **--web-renderer html**
* **Removed deprecated `--web-renderer=html`** from the default build command, following Flutter's deprecation notice ([Flutter Docs](https://docs.flutter.dev/to/web-html-renderer-deprecation)).

## 0.0.1

* Initial release of `flutter_web_fastify`.
