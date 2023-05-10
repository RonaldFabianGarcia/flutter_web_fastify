import 'package:flutter_web_fastify/main.dart' as flutter_web_fastify;
import 'package:flutter_web_fastify/src/version.dart';

void main(List<String> arguments) {
  print('''
  ════════════════════════════════════════════
     FLUTTER WEB FASTIFY (v$packageVersion)                               
  ════════════════════════════════════════════
  ''');

  flutter_web_fastify.initFastify(arguments);
}
