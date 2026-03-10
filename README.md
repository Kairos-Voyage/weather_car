# 🌤️ 车机天气应用

专为 2023 款斯巴鲁森林人车机设计的天气应用

## 📱 应用特点

- **横屏设计** - 适配车机横向显示
- **简洁界面** - 左侧当前天气，右侧 3-5 天预报
- **美观 UI** - 参考 OPPO/vivo/华为天气风格
- **动态背景** - 根据天气类型自动切换背景色
- **低版本兼容** - 支持 Android 6.0+ (API 23)

## 🖼️ 界面预览

```
┌─────────────────────────────────────────────────────────────────┐
│  📍 北京                              最后更新：14:30  🔄       │
├──────────────────────────────┬──────────────────────────────────┤
│                              │  📅 天气预报                     │
│  📍 北京市                    │                                  │
│                              │  今天    ☀️    晴朗    ↑25° ↓18° │
│       ☀️                     │  ─────────────────────────────   │
│                              │  周三    ⛅    多云    ↑23° ↓17° │
│      22°C                    │  ─────────────────────────────   │
│                              │  周四    ⛅    晴间多云 ↑21° ↓16°│
│     晴朗                     │  ─────────────────────────────   │
│                              │  周五    🌧️    小雨    ↑19° ↓15°│
│  💧 65%  💨 3.2km/h  🌫️ 优   │  ─────────────────────────────   │
│                              │  周六    ☀️    晴朗    ↑24° ↓17° │
└──────────────────────────────┴──────────────────────────────────┘
```

## 🔧 配置天气 API

### 方案一：和风天气（推荐 - 国内更准确）

1. 注册账号：https://dev.qweather.com/
2. 创建项目获取 API Key
3. 修改 `lib/services/weather_service.dart`:

```dart
static const String _qweatherKey = 'YOUR_QWEATHER_KEY'; // 替换为你的 Key
```

### 方案二：OpenWeatherMap

1. 注册账号：https://openweathermap.org/api
2. 获取 API Key
3. 修改 `lib/services/weather_service.dart`:

```dart
static const String _openWeatherKey = 'YOUR_OPENWEATHER_KEY';
```

## 📦 编译 APK

### 环境要求

- Flutter 3.x
- Android SDK (API 23+)
- Java 11+

### 编译命令

```bash
# 进入项目目录
cd weather_car

# 获取依赖
flutter pub get

# 编译 Debug 版本（测试用）
flutter build apk --debug

# 编译 Release 版本（发布用）
flutter build apk --release

# 编译指定 ABI（减小 APK 体积）
flutter build apk --release --split-per-abi
```

编译后的 APK 位置：
```
build/app/outputs/flutter-apk/app-release.apk
```

## 📲 安装到车机

### 方法一：U 盘安装

1. 将 APK 复制到 U 盘
2. 插入车机 USB 接口
3. 使用车机文件管理器找到 APK
4. 点击安装（需允许"未知来源"）

### 方法二：ADB 安装

```bash
adb connect <车机 IP 地址>
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

## ⚙️ 车机配置

### 屏幕方向

应用已配置为**强制横屏**，如需修改：

编辑 `android/app/src/main/AndroidManifest.xml`:

```xml
android:screenOrientation="landscape"  <!-- 横屏 -->
android:screenOrientation="portrait"   <!-- 竖屏 -->
android:screenOrientation="unspecified" <!-- 自动 -->
```

### 默认城市

修改 `lib/screens/weather_home.dart`:

```dart
String _city = '北京'; // 改为你所在城市
```

## 🛠️ 自定义

### 修改主题色

编辑 `lib/screens/weather_home.dart` 中的 `_getBackgroundColors()` 方法:

```dart
case 'sunny':
  return [Colors.orange.shade300, Colors.orange.shade600]; // 晴天渐变
```

### 添加更多天气信息

编辑 `lib/widgets/current_weather_card.dart` 中的 `_buildInfoRow()` 方法。

## 📄 项目结构

```
weather_car/
├── lib/
│   ├── main.dart                      # 应用入口
│   ├── screens/
│   │   └── weather_home.dart          # 主界面
│   ├── models/
│   │   └── weather_model.dart         # 数据模型
│   ├── services/
│   │   └── weather_service.dart       # 天气 API 服务
│   └── widgets/
│       ├── current_weather_card.dart  # 当前天气卡片
│       ├── forecast_card.dart         # 天气预报卡片
│       └── loading_weather.dart       # 加载动画
├── android/                           # Android 平台配置
└── pubspec.yaml                       # 项目配置
```

## 🐛 常见问题

### 1. 无法获取天气数据

- 检查网络连接
- 确认 API Key 配置正确
- 查看控制台错误日志

### 2. 安装失败

- 车机需开启"未知来源应用"
- 确认 APK 架构匹配 (armeabi-v7a / arm64-v8a)
- 尝试编译通用版本：`flutter build apk --release`

### 3. 界面显示异常

- 清除应用数据后重试
- 确认车机分辨率兼容性
- 检查 Flutter 引擎版本

## 📝 更新日志

### v1.0.0 (2026-03-10)
- ✅ 初始版本发布
- ✅ 横屏界面设计
- ✅ 当前天气显示
- ✅ 3-5 天天气预报
- ✅ 动态背景主题
- ✅ 城市切换功能
- ✅ Android 6.0+ 兼容

## 📄 许可证

MIT License

---

**开发：** Kairos G  
**适用设备：** 2023 款斯巴鲁森林人车机  
**系统要求：** Android 6.0+ (API 23)
