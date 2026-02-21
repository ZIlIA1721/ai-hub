# AI Hub

一个集成了多个 AI 工具的 Flutter 应用，支持通过 WebView 访问各大 AI 平台的网页版。

## 功能特点

- 集成多个 AI 工具：DeepSeek、Kimi、通义千问、ChatGPT、Claude、Gemini、豆包、文心一言等
- 支持自定义添加 AI 工具
- 支持深色/浅色模式切换
- 磨砂玻璃效果 UI 设计
- 多 WebView 实例管理，切换不掉线
- 模拟桌面端 User-Agent，获得完整功能体验

## 技术栈

- Flutter 3.x
- Riverpod 状态管理
- Hive 本地存储
- flutter_inappwebview

## 构建说明

### 环境要求

- Flutter SDK >= 3.0.0
- Android SDK >= 21
- JDK 17

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
flutter run
```

### 构建 APK

```bash
flutter build apk --release
```

### 构建 App Bundle

```bash
flutter build appbundle --release
```

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── app.dart               # 应用配置
├── models/
│   └── ai_tool.dart       # AI 工具数据模型
├── providers/
│   ├── ai_tools_provider.dart   # AI 工具状态管理
│   ├── theme_provider.dart      # 主题状态管理
│   └── webview_provider.dart    # WebView 状态管理
├── screens/
│   └── home_screen.dart   # 主屏幕
├── widgets/
│   ├── sidebar.dart       # 侧边栏组件
│   ├── ai_webview.dart    # WebView 组件
│   ├── add_tool_dialog.dart     # 添加工具对话框
│   └── glass_container.dart     # 磨砂玻璃容器
├── services/
│   └── storage_service.dart     # 存储服务
└── utils/
    └── constants.dart     # 常量定义
```

## 许可证

MIT License
