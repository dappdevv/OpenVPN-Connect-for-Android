#!/bin/bash

# Скрипт для локальной сборки OpenVPN Android приложения
# Автор: GitHub Actions Setup Helper

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} OpenVPN Android - Локальная сборка${NC}"
echo -e "${GREEN}========================================${NC}"

# Проверка зависимостей
echo -e "${YELLOW}Проверяем зависимости...${NC}"

# Проверка Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo -e "${GREEN}✓ Java найден: ${JAVA_VERSION}${NC}"
else
    echo -e "${RED}✗ Java не найден. Установите JDK 8${NC}"
    exit 1
fi

# Проверка SWIG
if command -v swig &> /dev/null; then
    SWIG_VERSION=$(swig -version | head -n 1)
    echo -e "${GREEN}✓ SWIG найден: ${SWIG_VERSION}${NC}"
else
    echo -e "${RED}✗ SWIG не найден. Установите SWIG 3.0+${NC}"
    echo -e "${YELLOW}Ubuntu/Debian: sudo apt-get install swig${NC}"
    echo -e "${YELLOW}macOS: brew install swig${NC}"
    exit 1
fi

# Проверка CMake
if command -v cmake &> /dev/null; then
    CMAKE_VERSION=$(cmake --version | head -n 1)
    echo -e "${GREEN}✓ CMake найден: ${CMAKE_VERSION}${NC}"
else
    echo -e "${RED}✗ CMake не найден. Установите CMake${NC}"
    echo -e "${YELLOW}Ubuntu/Debian: sudo apt-get install cmake${NC}"
    echo -e "${YELLOW}macOS: brew install cmake${NC}"
    exit 1
fi

# Проверка Android SDK
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo -e "${RED}✗ Android SDK не найден. Установите переменную ANDROID_HOME или ANDROID_SDK_ROOT${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Android SDK найден${NC}"
fi

# Переход в корень проекта
cd "$(dirname "$0")/.."

# Инициализация субмодулей
echo -e "${YELLOW}Инициализация Git субмодулей...${NC}"
git submodule update --init --recursive

# Права на gradlew
echo -e "${YELLOW}Настройка прав на gradlew...${NC}"
chmod +x gradlew

# Определение типа сборки
BUILD_TYPE=${1:-debug}

case $BUILD_TYPE in
    "debug")
        echo -e "${YELLOW}Сборка Debug версии...${NC}"
        ./gradlew assembleDebug
        ;;
    "release")
        echo -e "${YELLOW}Сборка Release версии...${NC}"
        ./gradlew assembleRelease
        ;;
    "clean")
        echo -e "${YELLOW}Очистка проекта...${NC}"
        ./gradlew clean
        exit 0
        ;;
    "test")
        echo -e "${YELLOW}Запуск тестов...${NC}"
        ./gradlew test
        exit 0
        ;;
    "lint")
        echo -e "${YELLOW}Запуск линтинга...${NC}"
        ./gradlew lintDebug
        echo -e "${GREEN}Результаты линтинга: main/build/reports/lint-results-debug.html${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Неизвестный тип сборки: $BUILD_TYPE${NC}"
        echo -e "${YELLOW}Доступные варианты: debug, release, clean, test, lint${NC}"
        exit 1
        ;;
esac

# Поиск собранных APK
echo -e "${YELLOW}Поиск собранных APK...${NC}"
find main/build/outputs/apk -name "*.apk" -type f | while read apk; do
    SIZE=$(du -h "$apk" | cut -f1)
    echo -e "${GREEN}✓ Найден APK: $apk (${SIZE})${NC}"
done

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Сборка завершена успешно!${NC}"
echo -e "${GREEN}========================================${NC}" 