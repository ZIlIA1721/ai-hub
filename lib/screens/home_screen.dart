import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_tool.dart';
import '../providers/ai_tools_provider.dart';
import '../widgets/sidebar.dart';
import '../widgets/ai_webview.dart';
import '../widgets/glass_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  AITool? _selectedTool;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tools = ref.read(aiToolsProvider);
      if (tools.isNotEmpty && _selectedTool == null) {
        setState(() {
          _selectedTool = tools.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tools = ref.watch(aiToolsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF5F5F7),
      body: Row(
        children: [
          Sidebar(
            selectedTool: _selectedTool,
            onToolSelected: (tool) {
              setState(() {
                _selectedTool = tool;
              });
            },
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(24),
              ),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  right: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark 
                      ? const Color(0xFF1C1C1E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    children: [
                      _buildHeader(isDark),
                      Expanded(
                        child: WebViewContainer(
                          tools: tools,
                          selectedTool: _selectedTool,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark 
            ? const Color(0xFF1C1C1E)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark 
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (_selectedTool != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _getToolColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _selectedTool!.name[0].toUpperCase(),
                    style: TextStyle(
                      color: _getToolColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedTool!.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      _selectedTool!.url,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white50 : Colors.black45,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Text(
                  'AI Hub',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
            GestureDetector(
              onTap: () => _showMenu(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.more_vert,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getToolColor() {
    if (_selectedTool?.color == null) return Colors.grey;
    try {
      return Color(int.parse(_selectedTool!.color!.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  void _showMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  Icons.refresh,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                title: Text(
                  '刷新当前页面',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // 刷新当前 WebView
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.restore,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                title: Text(
                  '恢复默认工具',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showResetConfirmDialog(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetConfirmDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '恢复默认工具',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          '这将删除所有自定义添加的工具，恢复为预设工具列表。确定继续吗？',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black45,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(aiToolsProvider.notifier).resetToDefault();
              final tools = ref.read(aiToolsProvider);
              if (tools.isNotEmpty) {
                setState(() {
                  _selectedTool = tools.first;
                });
              }
            },
            child: const Text(
              '确定',
              style: TextStyle(
                color: Color(0xFF007AFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
