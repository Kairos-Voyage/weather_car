# 🚀 车机天气应用 - 快速编译指南

## ⚠️ 当前环境问题

当前机器网络受限，无法下载 Android Gradle 插件。需要在其他有完整网络的机器上编译。

---

## ✅ 方案 A：在有网络的机器上编译（推荐）

### 1. 克隆项目

```bash
git clone https://github.com/Kairos-Voyage/weather_car.git
cd weather_car
```

### 2. 确认配置

API Key 已配置在代码中：
- 和风天气 API Key: `2c48a88fa8e1467ea10f98d7c6bbb223`
- 凭据 ID: `CBGXFG6MTW`

### 3. 编译

```bash
# 获取依赖
flutter pub get

# 编译 Release 版本
flutter build apk --release

# 或编译 Debug 版本
flutter build apk --debug
```

### 4. APK 位置

```
build/app/outputs/flutter-apk/app-release.apk    # 发布版 (约 40-50MB)
build/app/outputs/flutter-apk/app-debug.apk      # 调试版 (约 60-70MB)
```

### 5. 安装到车机

**方法 1：U 盘**
- 复制 APK 到 U 盘
- 插入车机 USB
- 使用车机文件管理器安装

**方法 2：ADB**
```bash
adb connect 192.168.1.xxx  # 车机 IP
adb install -r app-release.apk
```

---

## 🌐 方案 B：Flutter Web 版本（无需编译）

如果无法编译 APK，可以使用 Web 版本在车机浏览器中运行。

### 构建 Web 版本

```bash
flutter create . --platforms web  # 添加 Web 支持
flutter build web --release
```

### 部署

将 `build/web/` 目录部署到：
- 本地 Web 服务器
- GitHub Pages
- Vercel/Netlify

### 车机使用

在车机浏览器中打开 URL 即可。

---

## 📋 系统要求

### 编译环境

| 软件 | 版本 | 说明 |
|------|------|------|
| Flutter | 3.x | https://flutter.dev |
| Java | 11+ | OpenJDK |
| Android SDK | API 23+ | Android Studio 内置 |
| Gradle | 7.x+ | 自动下载 |

### 车机要求

| 项目 | 要求 |
|------|------|
| 系统 | Android 6.0+ |
| 架构 | ARM (armeabi-v7a / arm64-v8a) |
| 屏幕 | 横屏 (应用强制横屏) |
| 网络 | WiFi/热点 (获取天气数据) |

---

## 🔧 常见问题

### 1. Gradle 下载失败

**解决：** 使用国内镜像

编辑 `android/build.gradle.kts`:
```kotlin
repositories {
    maven { url = uri("https://maven.aliyun.com/repository/google") }
    maven { url = uri("https://maven.aliyun.com/repository/public") }
    maven { url = uri("https://mirrors.cloud.tencent.com/nexus/repository/maven-public/") }
}
```

### 2. SDK 未找到

**解决：** 配置 Android SDK 路径

```bash
flutter config --android-sdk /path/to/Android/Sdk
```

或在 `android/local.properties` 中添加：
```properties
sdk.dir=/path/to/Android/Sdk
```

### 3. 签名错误

**解决：** 使用 Debug 签名

Debug 版本使用默认签名，可以直接安装测试。

Release 版本需要配置签名：
```kotlin
android {
    buildTypes {
        release {
            signingConfig signingConfigs.debug  // 临时使用 debug 签名
        }
    }
}
```

---

## 📞 需要帮助？

如果编译遇到问题，请提供：
1. 错误日志
2. Flutter 版本 (`flutter --version`)
3. 操作系统

---

**项目地址：** https://github.com/Kairos-Voyage/weather_car  
**开发时间：** 2026-03-10  
**API 提供商：** 和风天气 (qweather.com)
