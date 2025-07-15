#!/bin/bash

# Скрипт для сборки OpenVPN Android приложения в Docker контейнере

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} OpenVPN Android - Docker сборка${NC}"
echo -e "${GREEN}========================================${NC}"

# Проверка переменных окружения
echo -e "${YELLOW}Проверка окружения...${NC}"
echo -e "${GREEN}✓ ANDROID_HOME: $ANDROID_HOME${NC}"
echo -e "${GREEN}✓ JAVA_HOME: $JAVA_HOME${NC}"

# Проверка инструментов
echo -e "${YELLOW}Проверка инструментов...${NC}"

# Java
JAVA_VERSION=$(java -version 2>&1 | head -n 1)
echo -e "${GREEN}✓ Java: $JAVA_VERSION${NC}"

# SWIG
SWIG_VERSION=$(swig -version 2>&1 | head -n 1)
echo -e "${GREEN}✓ SWIG: $SWIG_VERSION${NC}"

# CMake
CMAKE_VERSION=$(cmake --version 2>&1 | head -n 1)
echo -e "${GREEN}✓ CMake: $CMAKE_VERSION${NC}"

# Gradle
echo -e "${YELLOW}Инициализация Gradle...${NC}"
./gradlew --version | head -n 5

# Определение типа сборки
BUILD_TYPE=${1:-debug}

echo -e "${YELLOW}Тип сборки: $BUILD_TYPE${NC}"

case $BUILD_TYPE in
    "debug")
        echo -e "${YELLOW}Сборка Debug версии...${NC}"
        ./gradlew assembleDebug --stacktrace
        ;;
    "release")
        echo -e "${YELLOW}Сборка Release версии...${NC}"
        ./gradlew assembleRelease --stacktrace
        ;;
    "clean")
        echo -e "${YELLOW}Очистка проекта...${NC}"
        ./gradlew clean --stacktrace
        exit 0
        ;;
    "test")
        echo -e "${YELLOW}Запуск тестов...${NC}"
        ./gradlew test --stacktrace
        exit 0
        ;;
    "lint")
        echo -e "${YELLOW}Запуск линтинга...${NC}"
        ./gradlew lintDebug --stacktrace
        echo -e "${GREEN}Результаты линтинга: main/build/reports/lint-results-debug.html${NC}"
        exit 0
        ;;
    "all")
        echo -e "${YELLOW}Полная сборка (debug + release)...${NC}"
        ./gradlew assembleDebug assembleRelease --stacktrace
        ;;
    *)
        echo -e "${RED}Неизвестный тип сборки: $BUILD_TYPE${NC}"
        echo -e "${YELLOW}Доступные варианты: debug, release, clean, test, lint, all${NC}"
        exit 1
        ;;
esac

# Поиск и отображение результатов
echo -e "${YELLOW}Поиск собранных APK...${NC}"
APK_COUNT=0
find main/build/outputs/apk -name "*.apk" -type f | while read apk; do
    SIZE=$(du -h "$apk" | cut -f1)
    echo -e "${GREEN}✓ $apk (${SIZE})${NC}"
    APK_COUNT=$((APK_COUNT + 1))
done

# Генерация отчета
echo -e "${YELLOW}Генерация отчета...${NC}"
{
    echo "# OpenVPN Android Build Report"
    echo "**Время сборки:** $(date)"
    echo "**Тип сборки:** $BUILD_TYPE"
    echo "**Окружение:** Docker"
    echo ""
    echo "## Найденные APK файлы:"
    find main/build/outputs/apk -name "*.apk" -type f | while read apk; do
        SIZE=$(du -h "$apk" | cut -f1)
        echo "- $apk (${SIZE})"
    done
    echo ""
    echo "## Версии инструментов:"
    echo "- Java: $(java -version 2>&1 | head -n 1)"
    echo "- SWIG: $(swig -version 2>&1 | head -n 1)"
    echo "- CMake: $(cmake --version 2>&1 | head -n 1)"
} > build-report.md

echo -e "${GREEN}Отчет о сборке сохранен в: build-report.md${NC}"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Сборка завершена успешно!${NC}"
echo -e "${GREEN}========================================${NC}" 