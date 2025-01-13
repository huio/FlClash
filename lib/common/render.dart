import 'package:fl_clash/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class Render {
  static Render? _instance;
  bool _isPaused = false;
  final _dispatcher = SchedulerBinding.instance.platformDispatcher;
  FrameCallback? _beginFrame;
  VoidCallback? _drawFrame;

  Render._internal();

  factory Render() {
    _instance ??= Render._internal();
    return _instance!;
  }

  active() {
    resume();
    pause();
  }

  pause() {
    debouncer.call(
      "render_pause",
      _pause,
      duration: Duration(seconds: 5),
    );
  }

  resume() {
    debouncer.cancel("render_pause");
    _resume();
  }

  void _pause() {
    if (_isPaused) return;
    _isPaused = true;
    _beginFrame = _dispatcher.onBeginFrame;
    _drawFrame = _dispatcher.onDrawFrame;
    _dispatcher.onBeginFrame = null;
    _dispatcher.onDrawFrame = null;
    debugPrint("[App] pause");
  }

  void _resume() {
    if (!_isPaused) return;
    _isPaused = false;
    _dispatcher.onBeginFrame = _beginFrame;
    _dispatcher.onDrawFrame = _drawFrame;
    debugPrint("[App] resume");
  }
}

final render = system.isDesktop ? Render() : null;
