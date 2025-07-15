# ✅ Исправление ошибки сборки GitHub Actions

## 🚨 Проблема

Получена ошибка:

- `Warning: Unexpected input(s) 'api-level', 'build-tools', 'ndk-version'`
- `Error: This tool requires JDK 17 or later. Your version was detected as 1.8.0_452.`

## 🔧 Решение

Проблема была вызвана обновлением action `android-actions/setup-android@v3`, который изменил API и стал требовать JDK 17+ для работы `sdkmanager`. При этом сборка проекта по-прежнему требует JDK 8.

Я внес следующие изменения во все три workflow файла (`build.yml`, `release.yml`, `code-quality.yml`):

1. **Двойная настройка JDK:**

   - **JDK 17** устанавливается перед шагом "Setup Android SDK" для корректной работы `sdkmanager`.
   - **JDK 8** устанавливается сразу после "Setup Android SDK", чтобы последующие шаги сборки Gradle использовали правильную версию Java.

2. **Обновлен синтаксис `setup-android`:**

   - Вместо устаревших параметров `api-level`, `build-tools`, `ndk-version` используется единый параметр `packages`.
   - Это обеспечивает установку всех необходимых компонентов: платформ, build-tools, NDK и CMake.

3. **Оптимизация установки CMake:**
   - Убрана ручная установка CMake через `apt-get`, так как теперь он устанавливается вместе с Android SDK, что обеспечивает правильную версию и интеграцию.

## 📁 Обновленные файлы

- `.github/workflows/build.yml`
- `.github/workflows/release.yml`
- `.github/workflows/code-quality.yml`

## 🧪 Тестирование

После этих изменений сборка должна пройти успешно.

1. **Закоммитьте изменения:**

   ```bash
   git add .
   git commit -m "Fix GitHub Actions build failure"
   git push
   ```

2. **Проверьте результат:**
   - Перейдите в раздел "Actions" вашего репозитория.
   - Убедитесь, что новый запуск workflow завершился успешно (зеленая галочка ✅).

## 🎯 Результат

Система сборки теперь корректно обрабатывает требования к разным версиям JDK и использует актуальный синтаксис GitHub Actions, что делает ее более надежной и соответствующей современным стандартам.
