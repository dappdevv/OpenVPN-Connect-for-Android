# ⚡ Быстрая настройка секретов для GitHub Actions

## 🎯 Цель

Настроить 4 секрета для подписи Android APK в GitHub Actions:

- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEYSTORE_ALIAS`
- `KEYSTORE_ALIAS_PASSWORD`

## 🚀 Быстрые шаги

### 1. Создание keystore (1 минута)

```bash
./scripts/create-keystore.sh
```

### 2. Генерация секретов (30 секунд)

```bash
./scripts/generate-secrets.sh
```

### 3. Добавление в GitHub (2 минуты)

1. Откройте: https://github.com/dappdevv/OpenVPN-Connect-for-Android/settings/secrets/actions
2. Нажмите "New repository secret"
3. Добавьте 4 секрета из файла `github-secrets.txt`

### 4. Очистка (10 секунд)

```bash
rm -f keystore_*.txt github-secrets.txt *.jks
```

## 📋 Примеры секретов

После выполнения шагов 1-2 вы получите:

```
KEYSTORE_BASE64: MIIK3gIBAzCCCogGCSqGSIb3DQEHAaCCCnk...
KEYSTORE_PASSWORD: android
KEYSTORE_ALIAS: openvpn-key
KEYSTORE_ALIAS_PASSWORD: android
```

## 🧪 Тестирование

Создайте тестовый релиз:

```bash
git tag v1.0.0-test
git push origin v1.0.0-test
```

Затем создайте Release в GitHub интерфейсе.

## 🔐 Важно!

- ✅ Скрипты создают тестовый keystore с паролем "android"
- ⚠️ Для production используйте сложные пароли
- 🗑️ Удаляйте временные файлы после настройки
- 📁 Keystore файлы не попадают в Git (есть в .gitignore)

## 📞 Помощь

Если что-то не работает:

1. Проверьте установку JDK: `which keytool`
2. Посмотрите полное руководство: `KEYSTORE_SETUP_GUIDE.md`
3. Проверьте логи GitHub Actions в разделе Actions
