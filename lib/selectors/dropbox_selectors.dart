import 'package:reselect/reselect.dart';
import '../models/models.dart';

final dropboxStateSelector = (AppState state) => state.dropboxState;

final dropboxAccessTokenSelector = createSelector1(
  dropboxStateSelector,
  (dropboxState) => dropboxState.accessToken,
);