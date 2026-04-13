import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global app state — tracks whether the first meal has been logged.
/// Wrap your MaterialApp (or at least MainDashboardScreen) with AppStateProvider.
class AppStateProvider extends StatefulWidget {
  final Widget child;
  const AppStateProvider({super.key, required this.child});

  @override
  State<AppStateProvider> createState() => _AppStateProviderState();

  /// Access state from anywhere in the tree:
  ///   AppStateProvider.of(context).hasMealBeenLogged
  ///   AppStateProvider.of(context).setMealLogged()
  static _AppStateProviderState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AppStateInherited>()!
        .state;
  }
}

class _AppStateProviderState extends State<AppStateProvider> {
  bool _hasMealBeenLogged = false;

  bool get hasMealBeenLogged => _hasMealBeenLogged;

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('has_meal_been_logged') ?? false;
    if (mounted) setState(() => _hasMealBeenLogged = value);
  }

  /// Call this from FoodConsumedScreen's Continue button.
  Future<void> setMealLogged() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_meal_been_logged', true);
    if (mounted) setState(() => _hasMealBeenLogged = true);
  }

  @override
  Widget build(BuildContext context) {
    return _AppStateInherited(
      state: this,
      child: widget.child,
    );
  }
}

class _AppStateInherited extends InheritedWidget {
  final _AppStateProviderState state;

  const _AppStateInherited({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_AppStateInherited old) =>
      state.hasMealBeenLogged != old.state.hasMealBeenLogged;
}
