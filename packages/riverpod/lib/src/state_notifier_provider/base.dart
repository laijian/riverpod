part of '../state_notifier_provider.dart';

/// {@macro riverpod.statenotifierprovider}
class StateNotifierProvider<T extends StateNotifier<Object>>
    extends Provider<T> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    Create<T, ProviderReference> create, {
    String name,
  }) : super((ref) {
          final controller = create(ref);
          ref.onDispose(controller.dispose);
          return controller;
        }, name: name);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  StateNotifierStateProvider<Object> _state;
}

extension StateNotifierStateProviderX<Value>
    on StateNotifierProvider<StateNotifier<Value>> {
  StateNotifierStateProvider<Value> get state {
    _state ??= StateNotifierStateProvider<Value>._(this);
    return _state as StateNotifierStateProvider<Value>;
  }
}

class StateNotifierStateProvider<T>
    extends AlwaysAliveProviderBase<StateNotifier<T>, T> {
  StateNotifierStateProvider._(this._provider)
      : super(
          (ref) => ref.watch(_provider),
          _provider.name != null ? '${_provider.name}.state' : null,
        );

  final StateNotifierProvider<StateNotifier<T>> _provider;

  @override
  _StateNotifierStateProviderState<T> createState() {
    return _StateNotifierStateProviderState<T>();
  }

  @override
  Override overrideAsValue(T value) {
    return ProviderOverride(
      ValueProvider<StateNotifier<T>, T>((ref) {
        return ref.watch(_provider);
      }, value),
      this,
    );
  }
}

class _StateNotifierStateProviderState<T> = ProviderStateBase<StateNotifier<T>,
    T> with _StateNotifierStateProviderStateMixin<T>;

class StateNotifierProviderFamily<T extends StateNotifier<Object>, A>
    extends Family<T, T, A, ProviderReference, StateNotifierProvider<T>> {
  StateNotifierProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  StateNotifierProvider<T> create(
    A value,
    T Function(ProviderReference ref, A param) builder,
  ) {
    return StateNotifierProvider((ref) => builder(ref, value), name: name);
  }
}
