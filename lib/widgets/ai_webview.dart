import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_tool.dart';
import '../providers/webview_provider.dart';
import '../utils/constants.dart';

class AIWebView extends ConsumerStatefulWidget {
  final AITool tool;
  final bool isActive;

  const AIWebView({
    super.key,
    required this.tool,
    required this.isActive,
  });

  @override
  ConsumerState<AIWebView> createState() => _AIWebViewState();
}

class _AIWebViewState extends ConsumerState<AIWebView> 
    with AutomaticKeepAliveClientMixin {
  InAppWebViewController? _controller;
  double _progress = 0;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(widget.tool.url),
          ),
          initialSettings: InAppWebViewSettings(
            userAgent: AppConstants.desktopUserAgent,
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            iframeAllow: "camera; microphone",
            iframeAllowFullscreen: true,
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
            supportZoom: false,
            transparentBackground: true,
          ),
          onWebViewCreated: (controller) {
            _controller = controller;
            ref.read(webViewManagerProvider).registerController(
              widget.tool.id, 
              controller,
            );
          },
          onLoadStart: (controller, url) {
            setState(() {
              _isLoading = true;
              _progress = 0;
            });
          },
          onLoadStop: (controller, url) {
            setState(() {
              _isLoading = false;
              _progress = 1;
            });
            _injectViewportMeta();
          },
          onProgressChanged: (controller, progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url?.toString() ?? '';
            
            if (url.contains('play.google.com') || 
                url.contains('apps.apple.com') ||
                url.contains('itunes.apple.com')) {
              return NavigationActionPolicy.CANCEL;
            }
            
            return NavigationActionPolicy.ALLOW;
          },
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint('WebView [${widget.tool.name}]: ${consoleMessage.message}');
          },
        ),
        if (_isLoading && _progress < 1)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? const Color(0xFF0A84FF) : const Color(0xFF007AFF),
                ),
              ),
            ),
          ),
        if (_isLoading && _progress == 0)
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark 
                    ? const Color(0xFF2C2C2E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark 
                            ? const Color(0xFF0A84FF) 
                            : const Color(0xFF007AFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '正在加载 ${widget.tool.name}...',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _injectViewportMeta() async {
    if (_controller == null) return;

    const js = '''
      (function() {
        var meta = document.querySelector('meta[name="viewport"]');
        if (!meta) {
          meta = document.createElement('meta');
          meta.name = 'viewport';
          document.head.appendChild(meta);
        }
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        
        document.body.style.overscrollBehavior = 'none';
        document.documentElement.style.overscrollBehavior = 'none';
      })();
    ''';

    await _controller!.evaluateJavascript(source: js);
  }

  @override
  void didUpdateWidget(AIWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller?.resumeTimers();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller?.pauseTimers();
    }
  }

  @override
  void dispose() {
    ref.read(webViewManagerProvider).disposeController(widget.tool.id);
    super.dispose();
  }
}

class WebViewContainer extends ConsumerWidget {
  final List<AITool> tools;
  final AITool? selectedTool;

  const WebViewContainer({
    super.key,
    required this.tools,
    this.selectedTool,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tools.isEmpty) {
      return _buildEmptyState(context);
    }

    return IndexedStack(
      index: selectedTool != null 
          ? tools.indexWhere((t) => t.id == selectedTool!.id)
          : 0,
      children: tools.map((tool) {
        final isActive = selectedTool?.id == tool.id;
        return AIWebView(
          key: ValueKey(tool.id),
          tool: tool,
          isActive: isActive,
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.add_circle_outline,
              size: 48,
              color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.38),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '还没有添加任何 AI 工具',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击左侧 + 按钮添加工具',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}
