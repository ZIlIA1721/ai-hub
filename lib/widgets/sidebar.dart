import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_tool.dart';
import '../providers/ai_tools_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import 'glass_container.dart';
import 'add_tool_dialog.dart';

class Sidebar extends ConsumerWidget {
  final AITool? selectedTool;
  final Function(AITool) onToolSelected;

  const Sidebar({
    super.key,
    this.selectedTool,
    required this.onToolSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tools = ref.watch(aiToolsProvider);
    final isDarkMode = ref.watch(themeProvider);

    return GlassSidebar(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildAddButton(context, ref),
          const SizedBox(height: 16),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 8),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: tools.length,
              onReorder: (oldIndex, newIndex) {
                ref.read(aiToolsProvider.notifier).reorderTools(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final tool = tools[index];
                final isSelected = selectedTool?.id == tool.id;
                return _buildToolItem(
                  context, 
                  tool, 
                  isSelected, 
                  ref,
                  key: ValueKey(tool.id),
                );
              },
            ),
          ),
          _buildThemeToggle(context, ref, isDarkMode),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showAddToolDialog(context, ref),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark 
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          color: isDark ? Colors.white70 : Colors.black54,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildToolItem(
    BuildContext context, 
    AITool tool, 
    bool isSelected, 
    WidgetRef ref, {
    required Key key,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final toolColor = AppColors.getToolColor(tool.color);

    return ReorderableDragStartListener(
      index: ref.read(aiToolsProvider).indexOf(tool),
      child: GestureDetector(
        onTap: () => onToolSelected(tool),
        onLongPress: () => _showToolOptions(context, tool, ref),
        child: Container(
          key: key,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected 
                  ? toolColor.withOpacity(isDark ? 0.3 : 0.2)
                  : isDark 
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? toolColor.withOpacity(0.8)
                    : isDark 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: toolColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ] : null,
            ),
            child: Center(
              child: _buildToolIcon(tool, isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolIcon(AITool tool, bool isDark) {
    if (tool.iconUrl != null) {
      return Image.network(
        tool.iconUrl!,
        width: 32,
        height: 32,
        errorBuilder: (_, __, ___) => _buildDefaultIcon(tool, isDark),
      );
    }
    return _buildDefaultIcon(tool, isDark);
  }

  Widget _buildDefaultIcon(AITool tool, bool isDark) {
    final color = AppColors.getToolColor(tool.color);
    final firstLetter = tool.name.isNotEmpty ? tool.name[0].toUpperCase() : '?';

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref, bool isDarkMode) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: isDark ? Colors.white70 : Colors.black54,
          size: 24,
        ),
      ),
    );
  }

  void _showAddToolDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddToolDialog(),
    );
  }

  void _showToolOptions(BuildContext context, AITool tool, WidgetRef ref) {
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
                leading: Icon(Icons.delete, color: Colors.red[400]),
                title: Text(
                  '删除 ${tool.name}',
                  style: TextStyle(color: Colors.red[400]),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(aiToolsProvider.notifier).removeTool(tool.id);
                  if (selectedTool?.id == tool.id) {
                    final tools = ref.read(aiToolsProvider);
                    if (tools.isNotEmpty) {
                      onToolSelected(tools.first);
                    }
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
