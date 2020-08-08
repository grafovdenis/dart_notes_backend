import 'package:dart_notes_backend/dart_notes_backend.dart';
import 'package:dart_notes_backend/model/user.dart';

class UserController extends ResourceController {
  UserController({this.context});
  final ManagedContext context;

  @Operation.get()
  Future<Response> createUser() async {
    final query = Query<User>(context);

    return Response.ok(await query.fetch());
  }
}
