import 'package:dart_notes_backend/dart_notes_backend.dart';
import 'package:dart_notes_backend/model/note.dart';
import 'package:dart_notes_backend/model/user.dart';

class NoteController extends ResourceController {
  NoteController({this.authServer, this.context});

  final AuthServer authServer;
  final ManagedContext context;

  @Operation.get()
  Future<Response> getNotes() async {
    final query = Query<Note>(context)
      ..where((n) => n.owner).identifiedBy(request.authorization.ownerID);

    return Response.ok(await query.fetch());
  }

  @Operation.post()
  Future<Response> createNote(@Bind.body() Note note) async {
    note.owner = User()..id = request.authorization.ownerID;
    return Response.ok(await Query.insertObject(context, note));
  }

  @Operation.put("id")
  Future<Response> updateNote(
      @Bind.path("id") int id, @Bind.body() Note note) async {
    final requestUserId = request.authorization.ownerID;
    final query = Query<Note>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestUserId)
      ..values = note;
    final result = await query.updateOne();
    if (result == null) {
      return Response.notFound();
    } else {
      return Response.ok(result);
    }
  }

  @Operation.delete("id")
  Future<Response> deleteNote(@Bind.path("id") int id) async {
    final requestUserId = request.authorization.ownerID;
    final query = Query<Note>(context)
      ..where((n) => n.id).equalTo(id)
      ..where((n) => n.owner).identifiedBy(requestUserId);

    final result = await query.delete();
    if (result <= 0) {
      return Response.notFound();
    } else {
      return Response.ok(null);
    }
  }
}
