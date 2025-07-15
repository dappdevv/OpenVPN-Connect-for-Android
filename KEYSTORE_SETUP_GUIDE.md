# 🔐 Пошаговое руководство: Настройка секретов для подписи APK

## 📋 Обзор

Для релизной сборки подписанных APK в GitHub Actions необходимы 4 секрета:

- `KEYSTORE_BASE64` - Base64 закодированный keystore файл
- `KEYSTORE_PASSWORD` - Пароль от keystore файла
- `KEYSTORE_ALIAS` - Алиас ключа в keystore
- `KEYSTORE_ALIAS_PASSWORD` - Пароль от алиаса ключа

## 🎯 Вариант 1: Быстрая настройка (автоматические скрипты)

### Шаг 1: Создание keystore файла

```bash
# Создать новый keystore файл
./scripts/create-keystore.sh
```

### Шаг 2: Генерация секретов

```bash
# Создать все необходимые секреты
./scripts/generate-secrets.sh
```

### Шаг 3: Добавление в GitHub

1. Откройте файл `github-secrets.txt`
2. Скопируйте значения для каждого секрета
3. Добавьте в GitHub: Settings → Secrets and variables → Actions

---

## 🔧 Вариант 2: Ручная настройка

### Шаг 1: Создание keystore файла (если нет)

```bash
# Создать keystore файл
keytool -genkey -v \
    -keystore openvpn-android.jks \
    -alias openvpn-key \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass YOUR_KEYSTORE_PASSWORD \
    -keypass YOUR_KEY_PASSWORD
```

**Параметры:**

- `openvpn-android.jks` - имя keystore файла
- `openvpn-key` - алиас ключа
- `YOUR_KEYSTORE_PASSWORD` - пароль keystore
- `YOUR_KEY_PASSWORD` - пароль ключа

### Шаг 2: Создание base64 версии

```bash
# Создать base64 версию keystore
cat openvpn-android.jks | base64 -w 0 > keystore_base64.txt
```

### Шаг 3: Подготовка значений секретов

```bash
# 1. KEYSTORE_BASE64
cat keystore_base64.txt

# 2. KEYSTORE_PASSWORD
echo "YOUR_KEYSTORE_PASSWORD"

# 3. KEYSTORE_ALIAS
echo "openvpn-key"

# 4. KEYSTORE_ALIAS_PASSWORD
echo "YOUR_KEY_PASSWORD"
```

---

## 🌐 Добавление секретов в GitHub

### Пошаговая инструкция:

1. **Откройте репозиторий** на GitHub:

   ```
   https://github.com/dappdevv/OpenVPN-Connect-for-Android
   ```

2. **Перейдите в Settings** репозитория

   - Нажмите на вкладку "Settings"
   - В левом меню выберите "Secrets and variables"
   - Нажмите "Actions"

3. **Добавьте каждый секрет**:

   **a) KEYSTORE_BASE64**

   - Нажмите "New repository secret"
   - Name: `KEYSTORE_BASE64`
   - Value: содержимое файла `keystore_base64.txt`
   - Нажмите "Add secret"

   **b) KEYSTORE_PASSWORD**

   - Name: `KEYSTORE_PASSWORD`
   - Value: пароль от keystore файла
   - Нажмите "Add secret"

   **c) KEYSTORE_ALIAS**

   - Name: `KEYSTORE_ALIAS`
   - Value: `openvpn-key` (или ваш алиас)
   - Нажмите "Add secret"

   **d) KEYSTORE_ALIAS_PASSWORD**

   - Name: `KEYSTORE_ALIAS_PASSWORD`
   - Value: пароль от алиаса ключа
   - Нажмите "Add secret"

4. **Проверьте секреты**:
   - У вас должно быть 4 секрета
   - Имена должны совпадать точно
   - Значения должны быть без лишних пробелов

---

## 🧪 Тестирование

### Создание тестового релиза:

1. **Создайте tag**:

   ```bash
   git tag v1.0.0-test
   git push origin v1.0.0-test
   ```

2. **Создайте Release**:

   - Перейдите в GitHub → Releases
   - Нажмите "Create a new release"
   - Выберите tag `v1.0.0-test`
   - Нажмите "Publish release"

3. **Проверьте Actions**:

   - Перейдите в Actions
   - Найдите workflow "Release Build"
   - Проверьте логи сборки

4. **Скачайте APK**:
   - В завершенном Action найдите артефакты
   - Скачайте `release-apk`
   - Проверьте, что APK подписан

### Проверка подписи APK:

```bash
# Проверить подпись APK
jarsigner -verify -verbose -certs your-app.apk

# Альтернативно с Android SDK
apksigner verify --verbose your-app.apk
```

---

## 🚨 Важные моменты безопасности

### ❌ НЕ ДЕЛАЙТЕ:

- Не добавляйте keystore файлы в Git
- Не используйте простые пароли для production
- Не делитесь keystore файлами
- Не коммитьте временные файлы с секретами

### ✅ ДЕЛАЙТЕ:

- Сохраните keystore файл в безопасном месте
- Используйте сложные пароли для production
- Регулярно делайте backup keystore файла
- Удаляйте временные файлы после настройки

### Очистка временных файлов:

```bash
# Удалить все временные файлы
rm -f keystore_*.txt github-secrets.txt *.jks *.keystore
```

---

## 🔍 Решение проблем

### Проблема: "Keystore file not found"

```bash
# Проверьте путь к keystore файлу
ls -la *.jks *.keystore

# Создайте новый keystore
./scripts/create-keystore.sh
```

### Проблема: "Invalid keystore format"

```bash
# Проверьте формат keystore
keytool -list -v -keystore openvpn-android.jks

# Пересоздайте base64 версию
cat openvpn-android.jks | base64 -w 0 > keystore_base64.txt
```

### Проблема: "Signing failed"

- Проверьте правильность всех 4 секретов
- Убедитесь, что пароли совпадают
- Проверьте алиас ключа

### Проблема: "Secret not found"

- Убедитесь, что имена секретов точно совпадают
- Проверьте, что секреты добавлены в правильный репозиторий
- Проверьте права доступа к репозиторию

---

## 📞 Поддержка

При возникновении проблем:

1. Проверьте логи GitHub Actions
2. Убедитесь в правильности всех секретов
3. Протестируйте локально с теми же параметрами
4. Проверьте документацию Android по подписи APK

**Полезные ссылки:**

- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Java Keytool](https://docs.oracle.com/en/java/javase/11/tools/keytool.html)
