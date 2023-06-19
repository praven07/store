import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/src/exceptions.dart';

abstract class Store<A, S> {
  late BehaviorSubject<S> _state$;

  late S _initialState;

  Store(S initialState) {
    _initialState = initialState;
    _state$ = BehaviorSubject.seeded(_initialState);
  }

  /// Maps Type to functions.
  @protected
  Map<Type, Function> get actionHandlers;

  /// Dispatch an action.
  FutureOr<void> dispatch(A action) async {
    Type actionType = action.runtimeType;

    if (!actionHandlers.containsKey(actionType)) {
      throw ActionNotAvailableException(
        "The dispatched action $actionType does not have a corresponding method available.",
      );
    }

    return actionHandlers[actionType]?.call();
  }

  ValueStream<S> get state => _state$.stream;

  /// change the state of the store.
  @protected
  void setState(S state) {
    this._state$.add(state);
  }

  void dispose() {
    this._state$.close();
  }
}
