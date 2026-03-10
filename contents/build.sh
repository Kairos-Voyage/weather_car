#!/bin/bash

# 车机天气应用 - 快速配置和编译脚本

echo "🌤️  车机天气应用配置工具"
echo "========================"
echo ""

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ 未找到 Flutter，请先安装 Flutter"
    exit 1
fi

echo "✅ Flutter 版本：$(flutter --version | head -1)"
echo ""

# 进入项目目录
cd "$(dirname "$0")"

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

echo ""
echo "🔑 配置天气 API"
echo "---------------"
echo "请选择天气数据源:"
echo "1. 和风天气 (推荐 - 国内更准确)"
echo "2. OpenWeatherMap (国际)"
echo "3. 跳过配置 (使用模拟数据)"
echo ""
read -p "请选择 [1-3]: " api_choice

case $api_choice in
    1)
        read -p "请输入和风天气 API Key: " qweather_key
        sed -i "s/YOUR_QWEATHER_KEY/$qweather_key/g" lib/services/weather_service.dart
        echo "✅ 和风天气 API 已配置"
        ;;
    2)
        read -p "请输入 OpenWeatherMap API Key: " openweather_key
        sed -i "s/YOUR_OPENWEATHER_KEY/$openweather_key/g" lib/services/weather_service.dart
        echo "✅ OpenWeatherMap API 已配置"
        ;;
    3)
        echo "⚠️  将使用模拟数据（仅用于测试）"
        ;;
esac

echo ""
echo "📱 选择编译模式"
echo "---------------"
echo "1. Debug 版本 (测试用，体积小)"
echo "2. Release 版本 (发布用，优化好)"
echo "3. Release + 分 ABI (最小体积)"
echo ""
read -p "请选择 [1-3]: " build_choice

echo ""
echo "🔨 开始编译..."
echo ""

case $build_choice in
    1)
        flutter build apk --debug
        APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    2)
        flutter build apk --release
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
        ;;
    3)
        flutter build apk --release --split-per-abi
        APK_PATH="build/app/outputs/flutter-apk/"
        echo ""
        echo "📦 分 ABI 编译完成，APK 文件:"
        ls -lh build/app/outputs/flutter-apk/*.apk
        ;;
esac

echo ""
if [ -f "$APK_PATH" ] || [ -d "$APK_PATH" ]; then
    echo "✅ 编译成功!"
    echo ""
    echo "📍 APK 位置：$APK_PATH"
    echo ""
    echo "📲 安装到车机:"
    echo "   方法 1: 复制 APK 到 U 盘，插入车机安装"
    echo "   方法 2: adb install -r $APK_PATH"
else
    echo "❌ 编译失败，请检查错误信息"
    exit 1
fi

echo ""
echo "========================"
echo "完成!"
