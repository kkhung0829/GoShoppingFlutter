import 'package:reselect/reselect.dart';
import '../models/models.dart';

final shoppingStateSelector = (AppState state) => state.shoppingState;

final shoppingItemsSelector = createSelector1(
  shoppingStateSelector,
  (shoppingState) => shoppingState.shoppingItems,
);