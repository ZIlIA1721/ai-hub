import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'ai_tool.g.dart';

@HiveType(typeId: 0)
class AITool {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String url;
  
  @HiveField(3)
  final String? iconUrl;
  
  @HiveField(4)
  final String? color;
  
  @HiveField(5)
  final bool isPreset;
  
  @HiveField(6)
  final DateTime createdAt;

  AITool({
    String? id,
    required this.name,
    required this.url,
    this.iconUrl,
    this.color,
    this.isPreset = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  AITool copyWith({
    String? name,
    String? url,
    String? iconUrl,
    String? color,
    bool? isPreset,
  }) {
    return AITool(
      id: id,
      name: name ?? this.name,
      url: url ?? this.url,
      iconUrl: iconUrl ?? this.iconUrl,
      color: color ?? this.color,
      isPreset: isPreset ?? this.isPreset,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AITool && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

final List<AITool> presetTools = [
  AITool(
    id: 'deepseek',
    name: 'DeepSeek',
    url: 'https://chat.deepseek.com/',
    color: '#4D6BFA',
    isPreset: true,
  ),
  AITool(
    id: 'kimi',
    name: 'Kimi',
    url: 'https://kimi.moonshot.cn/',
    color: '#00B96B',
    isPreset: true,
  ),
  AITool(
    id: 'qwen',
    name: '通义千问',
    url: 'https://tongyi.aliyun.com/qianwen/',
    color: '#615CED',
    isPreset: true,
  ),
  AITool(
    id: 'chatgpt',
    name: 'ChatGPT',
    url: 'https://chat.openai.com/',
    color: '#10A37F',
    isPreset: true,
  ),
  AITool(
    id: 'claude',
    name: 'Claude',
    url: 'https://claude.ai/',
    color: '#CC785C',
    isPreset: true,
  ),
  AITool(
    id: 'gemini',
    name: 'Gemini',
    url: 'https://gemini.google.com/',
    color: '#4285F4',
    isPreset: true,
  ),
  AITool(
    id: 'doubao',
    name: '豆包',
    url: 'https://www.doubao.com/',
    color: '#FF6B6B',
    isPreset: true,
  ),
  AITool(
    id: 'yiyan',
    name: '文心一言',
    url: 'https://yiyan.baidu.com/',
    color: '#2932E1',
    isPreset: true,
  ),
];
