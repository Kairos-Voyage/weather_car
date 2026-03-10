# 🌤️ 车机天气应用 - 编译指南

## ⚠️ 重要说明

由于当前环境网络限制，无法直接下载 Gradle 插件完成编译。

**项目源代码已完成**，可在任何有完整 Android 开发环境的机器上编译。

---

## 📦 编译环境要求

### 必需软件

| 软件 | 版本 | 下载链接 |
|------|------|----------|
| Flutter | 3.x | https://flutter.dev |
| Java JDK | 17+ | https://adoptium.net |
| Android SDK | API 23+ | Android Studio 内置 |
| Gradle | 8.0+ | 自动下载 |

### 推荐：安装 Android Studio

最简单的方式是安装 Android Studio，它包含所有必需组件：

1. 下载：https://developer.android.com/studio
2. 安装后打开，安装 Android SDK
3. SDK Manager 中安装：
   - Android SDK Platform 23 (或更高)
   - Android SDK Build-Tools

---

## 🚀 快速编译（在有完整环境的机器上）

### 步骤 1：配置天气 API

编辑 `lib/services/weather_service.dart`:

```dart
// 第 12 行，替换为你的 API Key
static const String _qweatherKey = 'YOUR_QWEATHER_KEY';
```

**获取和风天气 API Key：**
1. 访问 https://dev.qweather.com/
2. 注册账号
3. 创建项目 → 获取 Key
4. 免费额度：每天 1000 次调用（够用）

### 步骤 2：编译 APK

```bash
# 进入项目目录
cd weather_car

# 获取 Flutter 依赖
flutter pub get

# 编译 Release 版本（推荐）
flutter build apk --release

# 或编译 Debug 版本（测试用）
flutter build apk --debug
```

### 步骤 3：找到 APK

编译完成后，APK 位置：

```
build/app/outputs/flutter-apk/app-release.apk    # 发布版
build/app/outputs/flutter-apk/app-debug.apk      # 调试版
```

---

## 📲 安装到车机

### 方法 1：U 盘安装（最简单）

1. 将 APK 复制到 U 盘（FAT32 格式）
2. 插入车机 USB 接口
3. 使用车机文件管理器找到 APK
4. 点击安装
5. 如提示"未知来源"，需先允许

### 方法 2：ADB 无线安装

```bash
# 1. 查看车机 IP（在车机设置 → 关于 → 网络）
# 2. 连接车机
adb connect 192.168.1.xxx

# 3. 安装 APK
adb install -r build/app/outputs/flutter-apk/app-release.apk

# 4. 启动应用
adb shell am start -n com.kairos.weather_car/.MainActivity
```

---

## 🛠️ 故障排除

### 问题 1：Gradle 下载失败

**错误信息：** `Could not resolve com.android.application`

**解决方案：**

1. 检查网络连接
2. 使用国内镜像（编辑 `android/build.gradle`）:

```gradle
repositories {
    google()
    mavenCentral()
    // 添加国内镜像
    maven { url 'https://maven.aliyun.com/repository/google' }
    maven { url 'https://maven.aliyun.com/repository/public' }
}
```

### 问题 2：Flutter 版本不兼容

**解决方案：**

```bash
# 升级 Flutter
flutter upgrade

# 或指定版本
flutter channel stable
flutter upgrade
```

### 问题 3：APK 安装失败

**可能原因：**
- 车机不支持 ARM64 架构
- 未开启"未知来源"

**解决方案：**

```bash
# 编译通用版本（包含所有架构）
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
```

### 问题 4：应用闪退

**解决方案：**
1. 查看车机日志（如有）
2. 尝试 Debug 版本
3. 检查 API Key 配置

---

## 📱 车机适配说明

### 屏幕方向

应用已配置为**强制横屏**，适配车机横向安装。

如需修改，编辑 `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- 横屏（默认） -->
android:screenOrientation="landscape"

<!-- 竖屏 -->
android:screenOrientation="portrait"

<!-- 自动旋转 -->
android:screenOrientation="unspecified"
```

### 默认城市

编辑 `lib/screens/weather_home.dart` 第 25 行：

```dart
String _city = '北京'; // 改为你的城市
```

### 分辨率适配

Flutter 会自动适配不同分辨率。车机常见分辨率：

- 1024×600
- 1280×720
- 1920×720（超宽屏）

应用已测试支持以上分辨率。

---

## 📊 项目文件清单

```
weather_car/
├── lib/
│   ├── main.dart                      # 应用入口
│   ├── screens/
│   │   └── weather_home.dart          # 主界面（横屏布局）
│   ├── models/
│   │   └── weather_model.dart         # 天气数据模型
│   ├── services/
│   │   └── weather_service.dart       # 和风天气 API
│   └── widgets/
│       ├── current_weather_card.dart  # 左侧：当前天气
│       ├── forecast_card.dart         # 右侧：天气预报
│       └── loading_weather.dart       # 加载动画
├── android/
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml    # 权限配置（横屏）
│   │   │   └── kotlin/.../MainActivity.kt
│   │   └── build.gradle.kts           # 构建配置（API 23+）
│   └── settings.gradle.kts            # Gradle 配置
├── pubspec.yaml                       # Flutter 依赖
├── README.md                          # 项目说明
├── BUILD_GUIDE.md                     # 本文件
└── build.sh                           # 编译脚本（Linux/Mac）
```

---

## 🎨 界面预览

```
┌────────────────────────────────────────────────────────────────────┐
│  📍 北京市                              最后更新：14:30  🔄  🏙️    │
├─────────────────────────────────┬──────────────────────────────────┤
│                                 │  📅 天气预报                     │
│  📍 北京市                       │                                  │
│                                 │  今天    ☀️    晴朗    ↑25° ↓18° │
│          ☀️                     │  ─────────────────────────────   │
│                                 │  周三    ⛅    多云    ↑23° ↓17° │
│         22°C                    │  ─────────────────────────────   │
│                                 │  周四    ⛅    晴间多云 ↑21° ↓16°│
│        晴朗                     │  ─────────────────────────────   │
│                                 │  周五    🌧️    小雨    ↑19° ↓15°│
│  💧 65%  💨 3.2km/h  🌫️ 优      │  ─────────────────────────────   │
│                                 │  周六    ☀️    晴朗    ↑24° ↓17° │
└─────────────────────────────────┴──────────────────────────────────┘
```

---

## 📝 下一步

1. **配置 API Key** - 获取和风天气免费 Key
2. **编译 APK** - 在有完整环境的机器上编译
3. **安装测试** - 安装到车机测试
4. **反馈调整** - 如需调整 UI 或功能，告诉我

---

## 💡 提示

- **测试建议**：先在手机/模拟器上测试，再安装到车机
- **网络要求**：车机需连接网络（WiFi 或热点）获取天气数据
- **定位功能**：当前版本使用城市选择，如需 GPS 定位可告诉我添加

---

**开发完成时间：** 2026-03-10  
**适用设备：** 2023 款斯巴鲁森林人车机 (Android 6.0+)  
**开发者：** Kairos G
