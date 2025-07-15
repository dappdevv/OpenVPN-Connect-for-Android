===================
OpenVPN for Android
===================
[![Build Status](https://travis-ci.org/schwabe/ics-openvpn.svg?branch=master)](https://travis-ci.org/schwabe/ics-openvpn)
[![GitHub Actions](https://github.com/dappdevv/OpenVPN-Connect-for-Android/workflows/Build%20Android%20App/badge.svg)](https://github.com/dappdevv/OpenVPN-Connect-for-Android/actions)

## Автоматическая сборка с GitHub Actions

Проект настроен для автоматической сборки с помощью GitHub Actions. Доступны три workflow:

- **Build Android App** - Автоматическая сборка при каждом push
- **Release Build** - Сборка подписанных APK для релизов
- **Code Quality** - Проверка качества кода и линтинг

📋 [Подробная инструкция по настройке](.github/GITHUB_ACTIONS_SETUP.md)  
🔐 [Быстрая настройка секретов для подписи APK](QUICK_SETUP_SECRETS.md)  
📖 [Полное руководство по keystore и секретам](KEYSTORE_SETUP_GUIDE.md)  
✅ [Обновление версий GitHub Actions](ACTIONS_VERSIONS_UPDATE.md)

### Локальная сборка

Для локальной сборки используйте подготовленный скрипт:

```bash
# Debug сборка
./scripts/local-build.sh debug

# Release сборка
./scripts/local-build.sh release

# Очистка проекта
./scripts/local-build.sh clean

# Запуск тестов
./scripts/local-build.sh test

# Линтинг кода
./scripts/local-build.sh lint
```

**Требования:**

- JDK 8
- Android SDK (установите `ANDROID_HOME`)
- SWIG 3.0+
- CMake
- Git (для субмодулей)

### Сборка в Docker

Для сборки без установки зависимостей используйте Docker:

```bash
# Сборка Docker образа
docker build -t openvpn-android .

# Debug сборка
docker run --rm -v $(pwd):/workspace openvpn-android debug

# Release сборка
docker run --rm -v $(pwd):/workspace openvpn-android release

# Или используйте docker-compose
docker-compose up
```

## Description

With the new VPNService of Android API level 14+ (Ice Cream Sandwich) it is possible to create a VPN service that does not need root access. This project is a port of OpenVPN.

<a href="https://f-droid.org/repository/browse/?fdid=de.blinkt.openvpn" target="_blank">
<img src="https://f-droid.org/badge/get-it-on.png" alt="Get it on F-Droid" height="80"/></a>
<a href="https://play.google.com/store/apps/details?id=de.blinkt.openvpn" target="_blank">
<img src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png" alt="Get it on Google Play" height="80"/></a>

## Developing

If you want to develop on ics-openvpn please read the [doc/README.txt](https://github.com/schwabe/ics-openvpn/blob/master/doc/README.txt) _before_ opening issues or emailing me.

Also please note that before contributing to the project that I would like to retain my ability to relicense the project for different third parties and therefore probably need a contributer's agreement from any contributing party. To get started, [sign the Contributor License Agreement](https://www.clahub.com/agreements/schwabe/ics-openvpn).

## You can help

Even if you are no programmer you can help by translating the OpenVPN client into your native language. [Crowdin provides a free service for non commercial open source projects](http://crowdin.net/project/ics-openvpn/invite) (Fixing/completing existing translations is very welcome as well)

## FAQ

You can find the FAQ here (same as in app): http://ics-openvpn.blinkt.de/FAQ.html

## Note to administrators

You make your life and that of your users easier if you embed the certificates into the .ovpn file. You or the users can mail the .ovpn as a attachment to the phone and directly import and use it. Also downloading and importing the file works. The MIME Type should be application/x-openvpn-profile.

Inline files are supported since OpenVPN 2.1rc1 and documented in the [OpenVPN 2.3 man page](https://community.openvpn.net/openvpn/wiki/Openvpn23ManPage) (under INLINE FILE SUPPORT)

(Using inline certifaces can also make your life on non-Android platforms easier since you only have one file.)

For example `ca mycafile.pem` becomes

```
  <ca>
  -----BEGIN CERTIFICATE-----
  MIIHPTCCBSWgAwIBAgIBADANBgkqhkiG9w0BAQQFADB5MRAwDgYDVQQKEwdSb290
  [...]
  -----END CERTIFICATE-----
  </ca>
```

## Footnotes

Please note that OpenVPN used by this project is under GPLv2.

If you cannot or do not want to use the Play Store you can [download the apk files directly](http://plai.de/android/).

If you want to donate you can donate to [arne-paypal@rfc2549.org via paypal](https://www.paypal.com/cgi-bin/webscr?hosted_button_id=R2M6ZP9AF25LS&cmd=_s-xclick), or alternatively if you believe in fancy Internet money you can use Bitcoin: 1EVWVqpVQFhoFE6gKaqSkfvSNdmLAjcQ9z

The old official or main repository was a Mercurial (hg) repository at http://code.google.com/p/ics-openvpn/source/

The new Git repository is now at GitHub under https://github.com/schwabe/ics-openvpn

Please read the doc/README before asking questions or starting development.
