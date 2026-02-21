import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/ai_tool.dart';

final aiToolsProvider = StateNotifierProvider<AIToolsNotifier, List<AITool>>((ref) {
  return AIToolsNotifier();
});

final selectedToolProvider = StateProvider<AITool?>((ref) => null);

class AIToolsNotifier extends StateNotifier<List<AITool>> {
  final Box _toolsBox = Hive.box('ai_tools');
  
  AIToolsNotifier() : super([]) {
    _loadTools();
  }
  
  void _loadTools() {
    final tools = _toolsBox.get('tools');
    if (tools == null || (tools as List).isEmpty) {
      state = List.from(presetTools);
      _saveTools();
    } else {
      state = (tools as List).map((t) => t as AITool).toList();
    }
  }
  
  void _saveTools() {
    _toolsBox.put('tools', state);
  }
  
  void addTool(AITool tool) {
    if (!state.any((t) => t.url == tool.url)) {
      state = [...state, tool];
      _saveTools();
    }
  }
  
  void removeTool(String id) {
    state = state.where((t) => t.id != id).toList();
    _saveTools();
  }
  
  void reorderTools(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final tools = List<AITool>.from(state);
    final item = tools.removeAt(oldIndex);
    tools.insert(newIndex, item);
    state = tools;
    _saveTools();
  }
  
  void resetToDefault() {
    state = List.from(presetTools);
    _saveTools();
  }
  
  AITool? getToolById(String id) {
    try {
      return state.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
