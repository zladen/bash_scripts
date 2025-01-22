#!/bin/bash

# Генерация сертификата и ключа
set -euo pipefail

# Параметры
CERT_DIR="/etc/ssl/self_signed_cert"
CERT_NAME="self_signed"
DAYS_VALID=3650
CERT_PATH="$CERT_DIR/$CERT_NAME.crt"
KEY_PATH="$CERT_DIR/$CERT_NAME.key"
SUBJECT="/C=US/ST=State/L=City/O=Organization/OU=Department/CN=example.com"

# Установка OpenSSL
if ! command -v openssl &> /dev/null; then
  echo "OpenSSL не установлен. Устанавливаем..."
  sudo apt update && sudo apt install -y openssl || { echo "Ошибка установки OpenSSL"; exit 1; }
fi

# Создание директории для сертификатов
mkdir -p "$CERT_DIR"

# Генерация сертификата
echo "Генерация сертификата..."
if openssl req -x509 -nodes -days "$DAYS_VALID" -newkey rsa:2048 \
  -keyout "$KEY_PATH" \
  -out "$CERT_PATH" \
  -subj "$SUBJECT"; then
  echo "SSL-сертификат успешно сгенерирован."
  echo "SSL CERTIFICATE PATH: $CERT_PATH"
  echo "SSL KEY PATH: $KEY_PATH"
else
  echo "Ошибка генерации SSL-сертификата."
  exit 1
fi

# Информация для пользователя
echo "============================================================"
echo "Сертификат сгенерирован:"
echo "Сертификат: $CERT_PATH"
echo "Приватный ключ: $KEY_PATH"


