import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'AI Hub';
  static const String appVersion = '1.0.0';
  
  static const double sidebarWidth = 80;
  static const double sidebarItemSize = 56;
  static const double borderRadius = 16;
  static const double borderRadiusLarge = 24;
  
  static const desktopUserAgent = 
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  
  static const List<Map<String, String>> quickAddTools = [
    {'name': 'DeepSeek', 'url': 'https://chat.deepseek.com/'},
    {'name': '海螺AI', 'url': 'https://hailuoai.com/'},
    {'name': 'Kimi', 'url': 'https://kimi.moonshot.cn/'},
    {'name': 'ChatGPT', 'url': 'https://chat.openai.com/'},
  ];
}

class AppColors {
  static const Color deepSeek = Color(0xFF4D6BFA);
  static const Color kimi = Color(0xFF00B96B);
  static const Color qwen = Color(0xFF615CED);
  static const Color chatgpt = Color(0xFF10A37F);
  static const Color claude = Color(0xFFCC785C);
  static const Color gemini = Color(0xFF4285F4);
  static const Color doubao = Color(0xFF4D6BFA);
  static const Color yiyan = Color(0xFF2932E1);
  
  static Color getToolColor(String? colorHex) {
    if (colorHex == null) return Colors.grey;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
