import 'package:redux/redux.dart';
import '../actions/actions.dart';
import '../models/models.dart';

final dropboxStateReducer = combineReducers<DropboxState>([
  TypedReducer<DropboxState, SetDropboxAccessTokenAction>(_setDropboxAccessToken),
]);

DropboxState _setDropboxAccessToken(DropboxState state, SetDropboxAccessTokenAction action) =>
  state.copyWith(
    accessToken: action.accessToken
  );