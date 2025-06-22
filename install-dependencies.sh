#!/bin/bash

# Script para instalar todas las dependencias necesarias para el pipeline Jenkins
# Incluye build-essential (similar a buildpack-deps), make, Docker y otras herramientas

set -euo pipefail

# Función para verificar si un comando existe
command_exists() {
    command -v "$@" > /dev/null 2>&1
}

# Actualizar lista de paquetes
echo "Actualizando lista de paquetes..."
sudo apt-get update -qq

# Instalar paquetes básicos (similar a buildpack-deps)
echo "Instalando build-essential y dependencias básicas..."
sudo apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    wget \
    gnupg \
    lsb-release

# Instalar Make si no está presente
if ! command_exists make; then
    echo "Instalando make..."
    sudo apt-get install -y make
fi

# Instalar Docker si no está presente
if ! command_exists docker; then
    echo "Instalando Docker..."
    # Agregar clave GPG oficial de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Agregar repositorio estable de Docker
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -qq
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Agregar usuario jenkins al grupo docker
    sudo usermod -aG docker jenkins
    sudo systemctl restart docker
fi

# Instalar dependencias adicionales para pruebas (si son necesarias)
echo "Instalando dependencias adicionales para testing..."
sudo apt-get install -y \
    python3 \
    python3-pip \
    python3-venv