#!/bin/bash

# =========================
# CONFIGURAÇÕES
# =========================

CONTAINER_NAME="servidor_tags"
IMAGE_NAME="gerador_tags_flask"
IMAGE_TAG="latest"

PORT_HOST=9000
PORT_CONTAINER=9000


echo "=============================="
echo "Deploy Flask - Gerador de Tags"
echo "=============================="

# =========================
# PARAR CONTAINER
# =========================

if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "🛑 Parando container..."
    docker stop $CONTAINER_NAME
fi


# =========================
# REMOVER CONTAINER
# =========================

if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🗑️ Removendo container..."
    docker rm $CONTAINER_NAME
fi


# =========================
# REMOVER IMAGEM
# =========================

if [ "$(docker images -q $IMAGE_NAME:$IMAGE_TAG)" ]; then
    echo "🗑️ Removendo imagem antiga..."
    docker rmi $IMAGE_NAME:$IMAGE_TAG
fi


# =========================
# BUILD
# =========================

echo "🔨 Buildando imagem..."

docker build -t $IMAGE_NAME:$IMAGE_TAG .

if [ $? -ne 0 ]; then
    echo "❌ ERRO NO BUILD"
    exit 1
fi


# =========================
# SUBIR CONTAINER
# =========================

echo "🚀 Subindo container..."

docker run -d \
--restart always \
-p $PORT_HOST:$PORT_CONTAINER \
-v $(pwd):/app \
--log-driver json-file \
--log-opt max-size=10m \
--log-opt max-file=3 \
--name $CONTAINER_NAME \
$IMAGE_NAME:$IMAGE_TAG


echo ""
echo "✅ Deploy concluído!"
echo ""
echo "Acesse:"
echo "http://localhost:$PORT_HOST"
echo ""