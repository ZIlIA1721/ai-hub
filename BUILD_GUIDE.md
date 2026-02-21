# AI Hub - 构建指南

## 环境准备

### 1. 安装 Flutter SDK

```bash
# 下载 Flutter SDK (https://docs.flutter.dev/get-started/install)
# 解压到合适的位置，例如 C:\flutter

# 添加环境变量
setx PATH "%PATH%;C:\flutter\bin"

# 验证安装
flutter doctor
```

### 2. 安装 Android Studio

- 下载并安装 Android Studio
- 安装 Android SDK (API 21-34)
- 配置 Android 模拟器或连接真机

### 3. 配置环境变量

```bash
# 设置 JAVA_HOME (JDK 17)
setx JAVA_HOME "C:\Program Files\Java\jdk-17"

# 设置 ANDROID_HOME
setx ANDROID_HOME "C:\Users\YourName\AppData\Local\Android\Sdk"
```

## 项目设置

### 1. 进入项目目录

```bash
cd ai_hub_app
```

### 2. 创建 local.properties 文件

在 `android/local.properties` 文件中添加：

```properties
flutter.sdk=C:\\flutter
flutter.versionName=1.0.0
flutter.versionCode=1
flutter.buildMode=release
```

### 3. 安装依赖

```bash
flutter pub get
```

## 构建 APK

### 调试版本

```bash
flutter build apk --debug
```

### 发布版本

```bash
flutter build apk --release
```

构建完成后，APK 文件位于：
```
build\app\outputs\flutter-apk\app-release.apk
```

## 构建 App Bundle (用于 Google Play)

```bash
flutter build appbundle --release
```

输出位置：
```
build\app\outputs\bundle\release\app-release.aab
```

## 安装到设备

### 通过 USB 安装

```bash
flutter install
```

### 手动安装 APK

```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

## 常见问题

### 1. Gradle 同步失败

```bash
# 清理并重新构建
flutter clean
flutter pub get
cd android
.\gradlew clean
.\gradlew build
cd ..
flutter build apk
```

### 2. 签名问题

如需发布到应用商店，需要配置签名：

1. 创建密钥库：
```bash
keytool -genkey -v -keystore ai-hub-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ai-hub
```

2. 在 `android/app/build.gradle` 中添加签名配置：
```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias 'ai-hub'
            keyPassword 'your-password'
            storeFile file('ai-hub-key.jks')
            storePassword 'your-password'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            ...
        }
    }
}
```

### 3. WebView 权限问题

确保 AndroidManifest.xml 中已添加所有必要的权限。

## 运行应用

### 在模拟器上运行

```bash
flutter run
```

### 在真机上运行

1. 开启手机的开发者模式和 USB 调试
2. 连接手机到电脑
3. 运行：
```bash
flutter run
```

## 项目结构说明

```
ai_hub_app/
├── android/              # Android 原生代码
├── ios/                  # iOS 原生代码
├── lib/                  # Dart 代码
│   ├── main.dart         # 应用入口
│   ├── app.dart          # 应用配置
│   ├── models/           # 数据模型
│   ├── providers/        # 状态管理
│   ├── screens/          # 页面
│   ├── widgets/          # 组件
│   ├── services/         # 服务
│   └── utils/            # 工具类
├── test/                 # 测试代码
├── pubspec.yaml          # 依赖配置
└── README.md             # 项目说明
```

## 功能说明

1. **侧边栏导航**：左侧显示所有添加的 AI 工具，点击切换
2. **添加工具**：点击 + 按钮添加新的 AI 工具
3. **删除工具**：长按工具图标可删除
4. **主题切换**：点击底部月亮/太阳图标切换深色/浅色模式
5. **多实例保持**：切换 AI 工具时，之前的页面保持运行状态

## 预设 AI 工具

- DeepSeek (https://chat.deepseek.com/)
- Kimi (https://kimi.moonshot.cn/)
- 通义千问 (https://tongyi.aliyun.com/qianwen/)
- ChatGPT (https://chat.openai.com/)
- Claude (https://claude.ai/)
- Gemini (https://gemini.google.com/)
- 豆包 (https://www.doubao.com/)
- 文心一言 (https://yiyan.baidu.com/)

## 技术特点

1. **桌面端 UA**：模拟桌面浏览器，获得完整功能
2. **磨砂玻璃效果**：使用 BackdropFilter 实现
3. **圆角设计**：大量 16-24px 圆角
4. **状态保持**：IndexedStack 保持多个 WebView 实例
5. **本地存储**：使用 Hive 存储用户配置
