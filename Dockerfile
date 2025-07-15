FROM openjdk:8-jdk

# Метаданные
LABEL maintainer="Android Developer"
LABEL description="OpenVPN Android Build Environment"

# Установка переменных окружения
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    git \
    build-essential \
    cmake \
    swig \
    python3 \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Установка Android SDK
RUN mkdir -p $ANDROID_HOME && \
    cd $ANDROID_HOME && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip && \
    unzip -q commandlinetools-linux-6858069_latest.zip && \
    mkdir -p cmdline-tools/latest && \
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true && \
    rm commandlinetools-linux-6858069_latest.zip

# Принятие лицензий и установка Android компонентов
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses && \
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
        "platform-tools" \
        "platforms;android-27" \
        "build-tools;27.0.3" \
        "ndk;21.4.7075529" \
        "cmake;3.10.2.4988404"

# Создание рабочей директории
WORKDIR /workspace

# Копирование файлов проекта
COPY . .

# Права на gradlew
RUN chmod +x gradlew

# Инициализация Git субмодулей
RUN git config --global --add safe.directory /workspace && \
    git submodule update --init --recursive

# Скрипт сборки
COPY scripts/docker-build.sh /usr/local/bin/docker-build.sh
RUN chmod +x /usr/local/bin/docker-build.sh

# Точка входа
ENTRYPOINT ["/usr/local/bin/docker-build.sh"]
CMD ["debug"] 