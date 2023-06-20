import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';

class ObjectBox {
   /// The Store of this app.
  late final Store store;
  
  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }
}