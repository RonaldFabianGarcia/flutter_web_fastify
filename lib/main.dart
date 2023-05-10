import 'dart:convert';
import 'dart:io';

import 'package:flutter_web_fastify/resources.resource_importer.dart'
    as resources;
import 'package:process_run/process_run.dart';
import 'package:random_string/random_string.dart';
import 'package:string_splitter/string_splitter.dart';

Future<void> initFastify(List<String> arguments) async {
  verifyIsWebProject();

  await buildFlutterWeb();

  await buildChunks();

  await insertChunkCalled();
}

void verifyIsWebProject() {
  final rootPath = Directory.current.path;

  final checkWebProjectExist = Directory('$rootPath/web').existsSync();

  if (!checkWebProjectExist) {
    throw UnimplementedError('The project does not contain the web folder');
  }
}

Future<void> buildFlutterWeb() async {
  final shell = Shell();

  await shell.run('''
  flutter build web --release --web-renderer html
  ''');

  print('create flutter web build');
}

Future<void> buildChunks() async {
  final rootPath = Directory.current.path;

  final mainJsFile = File('$rootPath/build/web/main.dart.js');
  final mainJsFileStr = await mainJsFile.readAsString();

  final chunks = StringSplitter.chunk(mainJsFileStr, 97000);

  final folderName = '${DateTime.now().millisecondsSinceEpoch}';
  final versionFolder = Directory('$rootPath/build/web/$folderName');
  await versionFolder.create(recursive: true);

  final newResources = <String>[];

  var k = 0;

  final chunkId = randomAlpha(5);

  for (final part in chunks) {
    final newPart = '$k-$chunkId.html';
    newResources.add('$folderName/$newPart');
    await File('$rootPath/build/web/$folderName/$newPart').writeAsString(part);

    k++;
  }

  await File('$rootPath/build/web/resources.json').writeAsString(
    json.encode({
      'parts': newResources,
      'dateTime': DateTime.now().millisecondsSinceEpoch,
    }),
  );

  print('chunks generated successfully [${chunks.length}]');
}

Future<void> insertChunkCalled() async {
  final rootPath = Directory.current.path;

  final indexPath = '$rootPath/build/web/index.html';
  final indexFile = File(indexPath);
  var indexFileStr = await indexFile.readAsString();

  print(indexFileStr);

  indexFileStr = indexFileStr.replaceFirst('</body>', '''

  <script>
${resources.get_chunks}
  </script>
</body>
''');

  await File(indexPath).writeAsString(indexFileStr);

  print('chunks methods added in index.html');
}
