#!/bin/bash

# Скрипт для создания keystore файла для подписи Android APK

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Создание Android Keystore${NC}"
echo -e "${GREEN}========================================${NC}"

# Параметры по умолчанию
KEYSTORE_NAME="openvpn-android.jks"
ALIAS_NAME="openvpn-key"
KEY_SIZE=2048
VALIDITY=10000

echo -e "${YELLOW}Создание keystore файла: $KEYSTORE_NAME${NC}"
echo -e "${YELLOW}Алиас ключа: $ALIAS_NAME${NC}"
echo -e "${YELLOW}Размер ключа: $KEY_SIZE бит${NC}"
echo -e "${YELLOW}Срок действия: $VALIDITY дней${NC}"
echo ""

# Проверка наличия Java
if ! command -v keytool &> /dev/null; then
    echo -e "${RED}✗ keytool не найден. Убедитесь, что JDK установлен${NC}"
    exit 1
fi

# Создание keystore
echo -e "${YELLOW}Создание keystore...${NC}"
keytool -genkey -v \
    -keystore $KEYSTORE_NAME \
    -alias $ALIAS_NAME \
    -keyalg RSA \
    -keysize $KEY_SIZE \
    -validity $VALIDITY \
    -storepass android \
    -keypass android \
    -dname "CN=OpenVPN Android Developer, OU=Development, O=OpenVPN, L=City, ST=State, C=US"

echo ""
echo -e "${GREEN}✓ Keystore создан: $KEYSTORE_NAME${NC}"
echo -e "${GREEN}✓ Алиас: $ALIAS_NAME${NC}"
echo -e "${GREEN}✓ Пароль keystore: android${NC}"
echo -e "${GREEN}✓ Пароль ключа: android${NC}"

echo ""
echo -e "${YELLOW}Информация о keystore:${NC}"
keytool -list -v -keystore $KEYSTORE_NAME -storepass android

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Следующие шаги:${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${YELLOW}1. Создайте base64 версию:${NC}"
echo -e "   cat $KEYSTORE_NAME | base64 > keystore_base64.txt"
echo ""
echo -e "${YELLOW}2. Добавьте secrets в GitHub:${NC}"
echo -e "   KEYSTORE_BASE64: содержимое keystore_base64.txt"
echo -e "   KEYSTORE_PASSWORD: android"
echo -e "   KEYSTORE_ALIAS: $ALIAS_NAME"
echo -e "   KEYSTORE_ALIAS_PASSWORD: android"
echo ""
echo -e "${YELLOW}3. Запустите скрипт генерации secrets:${NC}"
echo -e "   ./scripts/generate-secrets.sh"
echo ""
echo -e "${RED}⚠️  ВНИМАНИЕ: Сохраните keystore файл в безопасном месте!${NC}"
echo -e "${RED}⚠️  Для production использования смените пароли!${NC}" 