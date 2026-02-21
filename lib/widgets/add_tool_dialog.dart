import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_tool.dart';
import '../providers/ai_tools_provider.dart';
import '../utils/constants.dart';
import 'glass_container.dart';

class AddToolDialog extends ConsumerStatefulWidget {
  const AddToolDialog({super.key});

  @override
  ConsumerState<AddToolDialog> createState() => _AddToolDialogState();
}

class _AddToolDialogState extends ConsumerState<AddToolDialog> {
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  int _selectedTab = 0;

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          _buildTabs(isDark),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedTab == 0 
                ? _buildQuickAddTab(isDark)
                : _buildCustomToolTab(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? isDark 
                          ? Colors.white.withOpacity(0.15)
                          : Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedTab == 0 ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    '工具市场',
                    style: TextStyle(
                      color: _selectedTab == 0
                          ? isDark ? Colors.white : Colors.black87
                          : isDark ? Colors.white60 : Colors.black54,
                      fontWeight: _selectedTab == 0 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? isDark 
                          ? Colors.white.withOpacity(0.15)
                          : Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedTab == 1 ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    '自定义工具',
                    style: TextStyle(
                      color: _selectedTab == 1
                          ? isDark ? Colors.white : Colors.black87
                          : isDark ? Colors.white60 : Colors.black54,
                      fontWeight: _selectedTab == 1 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppConstants.quickAddTools.length,
      itemBuilder: (context, index) {
        final tool = AppConstants.quickAddTools[index];
        return _buildQuickAddItem(tool, isDark);
      },
    );
  }

  Widget _buildQuickAddItem(Map<String, String> tool, bool isDark) {
    final existingTools = ref.read(aiToolsProvider);
    final isAdded = existingTools.any((t) => t.url == tool['url']);

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                tool['name']![0].toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tool['name']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tool['url']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.45),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: isAdded 
                ? null 
                : () => _addQuickTool(tool),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isAdded 
                    ? Colors.grey.withOpacity(0.3)
                    : const Color(0xFF34C759),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isAdded ? '已添加' : '添加',
                style: TextStyle(
                  color: isAdded 
                      ? isDark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.45)
                      : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomToolTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '输入自定义链接到侧边栏',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _urlController,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: '输入网页链接',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.38),
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.link,
                  color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.38),
                ),
              ),
              keyboardType: TextInputType.url,
            ),
          ),
          const SizedBox(height: 12),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _nameController,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: '输入名称（可选）',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.38),
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.edit,
                  color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.38),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _addCustomTool,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '添加到侧边栏',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addQuickTool(Map<String, String> tool) {
    final newTool = AITool(
      name: tool['name']!,
      url: tool['url']!,
    );
    ref.read(aiToolsProvider.notifier).addTool(newTool);
    Navigator.pop(context);
  }

  void _addCustomTool() {
    final url = _urlController.text.trim();
    final name = _nameController.text.trim();

    if (url.isEmpty) {
      _showError('请输入网页链接');
      return;
    }

    String finalUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      finalUrl = 'https://$url';
    }

    final newTool = AITool(
      name: name.isNotEmpty ? name : '自定义工具',
      url: finalUrl,
    );

    ref.read(aiToolsProvider.notifier).addTool(newTool);
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
