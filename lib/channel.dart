import 'package:aqueduct/managed_auth.dart';

import 'controller/note_controller.dart';

import 'controller/register_controller.dart';
import 'controller/user_controller.dart';
import 'dart_notes_backend.dart';
import 'model/user.dart';

class MyConfiguration extends Configuration {
  MyConfiguration(String configPath) : super.fromFile(File(configPath));

  DatabaseConfiguration database;
}

class DartNotesBackendChannel extends ApplicationChannel {
  AuthServer authServer;
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final config = MyConfiguration(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel, psc);

    final delegate = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(delegate);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    // Set up auth token route- this grants and refresh tokens
    router.route("/auth/token").link(() => AuthController(authServer));

    /// Create an account
    router
        .route('/register')
        .link(() => Authorizer.basic(authServer))
        .link(() => RegisterController(context, authServer));

    router
        .route('/notes/[:id]')
        .link(() => Authorizer(authServer))
        .link(() => NoteController(context: context, authServer: authServer));

    router.route('/users').link(() => UserController(context: context));

    return router;
  }
}
