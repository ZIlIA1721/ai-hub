import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webViewControllersProvider = Provider<Map<String, InAppWebViewController>>((ref) {
  return {};
});

final webViewStackIndexProvider = StateProvider<int>((ref) => 0);

class WebViewManager {
  final Map<String, InAppWebViewController> _controllers = {};
  
  void registerController(String toolId, InAppWebViewController controller) {
    _controllers[toolId] = controller;
  }
  
  InAppWebViewController? getController(String toolId) {
    return _controllers[toolId];
  }
  
  void disposeController(String toolId) {
    _controllers.remove(toolId);
  }
  
  void reloadAll() {
    for (var controller in _controllers.values) {
      controller.reload();
    }
  }
}

final webViewManagerProvider = Provider<WebViewManager>((ref) {
  return WebViewManager();
});
