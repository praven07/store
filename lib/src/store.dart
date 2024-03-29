import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:store/src/exceptions.dart';

abstract class Store<A, S> {
  late BehaviorSubject<S> _state$;

  S get initialState;

  Store() {
    _state$ = BehaviorSubject.seeded(initialState);
  }

  /// Maps Type to functions.
  Map<Type, Function> get actionHandlers;

  /// Dispatch an action.
  FutureOr<void> dispatch(A action) async {
    Type actionType = action.runtimeType;

    if (!actionHandlers.containsKey(actionType)) {
      throw ActionNotAvailableException(
        "The dispatched action $actionType does not have a corresponding method available.",
      );
    }

    return actionHandlers[actionType]!(action);
  }

  ValueStream<S> get state => _state$.stream;

  /// change the state of the store.
  void setState(S state) {
    this._state$.add(state);
  }

  void dispose() {
    this._state$.close();
  }
}
