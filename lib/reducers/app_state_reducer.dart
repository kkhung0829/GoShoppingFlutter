import '../models/models.dart';
import 'shopping_state_reducer.dart';
import 'coupon_state_reducer.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    shoppingState: shoppingStateReducer(state.shoppingState, action),
    couponState: couponStateReducer(state.couponState, action),
  );
}