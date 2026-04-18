import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider extends StatefulWidget {
  final Widget child;

  const AppStateProvider({
    super.key,
    required this.child,
  });

  @override
  State<AppStateProvider> createState() => _AppStateProviderState();

  static _AppStateProviderState of(BuildContext context) {
    final inherited =
    context.dependOnInheritedWidgetOfExactType<_AppStateInherited>();

    if (inherited == null) {
      throw FlutterError(
        'AppStateProvider.of(context) called with a context that does not contain AppStateProvider.',
      );
    }

    return inherited.state;
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool('has_meal_been_logged') ?? false;

      if (mounted) {
        setState(() {
          _hasMealBeenLogged = value;
        });
      }
    } catch (e) {
      debugPrint('SharedPreferences load error: $e');
    }
  }

  Future<void> setMealLogged() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_meal_been_logged', true);

      if (mounted) {
        setState(() {
          _hasMealBeenLogged = true;
        });
      }
    } catch (e) {
      debugPrint('SharedPreferences save error: $e');
    }
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
  bool updateShouldNotify(_AppStateInherited oldWidget) {
    return state.hasMealBeenLogged != oldWidget.state.hasMealBeenLogged;
  }
}