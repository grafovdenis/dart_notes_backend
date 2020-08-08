import 'package:dart_notes_backend/dart_notes_backend.dart';

Future main() async {
  final app = Application<DartNotesBackendChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.address = InternetAddress.anyIPv4
    ..options.port = 8888;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
