import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import './models/models.dart';
import './reducers/app_state_reducer.dart';
import './presentations/presentations.dart';

// void main() => runApp(MyApp());
void main() async {
  // Create Persistor
  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.serializeFromJson),
  );

  // Load initial state
  final initialState = await persistor.load();

  final store = Store<AppState>(
    appStateReducer,
    initialState: initialState ?? AppState(),
    middleware: [persistor.createMiddleware()],
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Go Shopping',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StoreBuilder<AppState>(
          builder: (BuildContext context, Store<AppState> store) =>
            HomeScreen(),
        ),
      ),
    );
  }
}