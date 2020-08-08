import 'package:aqueduct/managed_auth.dart';
import 'package:dart_notes_backend/dart_notes_backend.dart';

import 'note.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

@Table(name: "users")
class _User extends ResourceOwnerTableDefinition {
  ManagedSet<Note> notes;

  // This class inherits the following from ManagedAuthenticatable:
  // @managedPrimaryKey
  // int id;
  // @ManagedColumnAttributes(unique: true, indexed: true)
  // String username;
  // @ManagedColumnAttributes(omitByDefault: true)
  // String hashedPassword;
  // @ManagedColumnAttributes(omitByDefault: true)
  // String salt;
  // ManagedSet<ManagedToken> tokens;
}
