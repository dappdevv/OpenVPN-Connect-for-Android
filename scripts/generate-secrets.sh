#!/bin/bash

# Скрипт для генерации секретов GitHub Actions из keystore файла

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Генерация GitHub Secrets${NC}"
echo -e "${GREEN}========================================${NC}"

# Параметры по умолчанию
KEYSTORE_FILE="openvpn-android.jks"
ALIAS_NAME="openvpn-key"
KEYSTORE_PASSWORD="android"
ALIAS_PASSWORD="android"

# Проверка аргументов
if [ $# -eq 1 ]; then
    KEYSTORE_FILE=$1
elif [ $# -eq 4 ]; then
    KEYSTORE_FILE=$1
    ALIAS_NAME=$2
    KEYSTORE_PASSWORD=$3
    ALIAS_PASSWORD=$4
fi

echo -e "${YELLOW}Keystore файл: $KEYSTORE_FILE${NC}"
echo -e "${YELLOW}Алиас ключа: $ALIAS_NAME${NC}"
echo ""

# Проверка существования keystore файла
if [ ! -f "$KEYSTORE_FILE" ]; then
    echo -e "${RED}✗ Keystore файл не найден: $KEYSTORE_FILE${NC}"
    echo -e "${YELLOW}Запустите: ./scripts/create-keystore.sh${NC}"
    exit 1
fi

# Создание base64 версии keystore
echo -e "${YELLOW}Создание base64 версии keystore...${NC}"
KEYSTORE_BASE64=$(cat "$KEYSTORE_FILE" | base64 -w 0)

# Создание файла с секретами
SECRETS_FILE="github-secrets.txt"
echo -e "${YELLOW}Создание файла секретов: $SECRETS_FILE${NC}"

cat > "$SECRETS_FILE" << EOF
# GitHub Secrets для подписи Android APK
# Добавьте эти секреты в: Settings → Secrets and variables → Actions

# 1. KEYSTORE_BASE64
# Описание: Base64 закодированный keystore файл
# Значение:
$KEYSTORE_BASE64

# 2. KEYSTORE_PASSWORD
# Описание: Пароль от keystore файла
# Значение:
$KEYSTORE_PASSWORD

# 3. KEYSTORE_ALIAS
# Описание: Алиас ключа в keystore
# Значение:
$ALIAS_NAME

# 4. KEYSTORE_ALIAS_PASSWORD
# Описание: Пароль от алиаса ключа
# Значение:
$ALIAS_PASSWORD

# ========================================
# Инструкции по добавлению в GitHub:
# ========================================
# 1. Перейдите в ваш репозиторий на GitHub
# 2. Settings → Secrets and variables → Actions
# 3. Нажмите "New repository secret"
# 4. Добавьте каждый secret с соответствующим именем и значением
# 5. Secrets должны быть точно такими: KEYSTORE_BASE64, KEYSTORE_PASSWORD, KEYSTORE_ALIAS, KEYSTORE_ALIAS_PASSWORD
EOF

# Создание отдельных файлов для удобства
echo "$KEYSTORE_BASE64" > keystore_base64.txt
echo "$KEYSTORE_PASSWORD" > keystore_password.txt
echo "$ALIAS_NAME" > keystore_alias.txt
echo "$ALIAS_PASSWORD" > keystore_alias_password.txt

echo ""
echo -e "${GREEN}✓ Секреты созданы успешно!${NC}"
echo ""
echo -e "${BLUE}Файлы:${NC}"
echo -e "  📄 $SECRETS_FILE - Все секреты с инструкциями"
echo -e "  📄 keystore_base64.txt - KEYSTORE_BASE64"
echo -e "  📄 keystore_password.txt - KEYSTORE_PASSWORD"
echo -e "  📄 keystore_alias.txt - KEYSTORE_ALIAS"
echo -e "  📄 keystore_alias_password.txt - KEYSTORE_ALIAS_PASSWORD"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Добавление секретов в GitHub${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}1. Перейдите в ваш репозиторий:${NC}"
echo -e "   https://github.com/dappdevv/OpenVPN-Connect-for-Android"
echo ""
echo -e "${YELLOW}2. Откройте Settings → Secrets and variables → Actions${NC}"
echo ""
echo -e "${YELLOW}3. Нажмите 'New repository secret' и добавьте:${NC}"
echo ""
echo -e "${BLUE}   Name: KEYSTORE_BASE64${NC}"
echo -e "   Value: $(echo $KEYSTORE_BASE64 | cut -c1-50)..."
echo ""
echo -e "${BLUE}   Name: KEYSTORE_PASSWORD${NC}"
echo -e "   Value: $KEYSTORE_PASSWORD"
echo ""
echo -e "${BLUE}   Name: KEYSTORE_ALIAS${NC}"
echo -e "   Value: $ALIAS_NAME"
echo ""
echo -e "${BLUE}   Name: KEYSTORE_ALIAS_PASSWORD${NC}"
echo -e "   Value: $ALIAS_PASSWORD"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Проверка настройки${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}После добавления секретов:${NC}"
echo -e "1. Создайте release в GitHub для тестирования"
echo -e "2. Проверьте логи GitHub Actions"
echo -e "3. Скачайте подписанный APK из артефактов"
echo ""

echo -e "${RED}⚠️  БЕЗОПАСНОСТЬ:${NC}"
echo -e "${RED}   - Удалите временные файлы после настройки${NC}"
echo -e "${RED}   - Не добавляйте keystore файлы в Git${NC}"
echo -e "${RED}   - Для production смените пароли${NC}"
echo ""

echo -e "${YELLOW}Для очистки временных файлов:${NC}"
echo -e "   rm -f keystore_*.txt $SECRETS_FILE" 