# 使用包含 Flutter 和 Android SDK 的镜像
FROM cirrusci/flutter:3.16.0

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 获取依赖
RUN flutter pub get

# 构建 Release APK
RUN flutter build apk --release

# 输出目录
VOLUME ["/app/build/app/outputs/flutter-apk"]

CMD ["cp", "build/app/outputs/flutter-apk/app-release.apk", "/output/AI_Hub.apk"]
