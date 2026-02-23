FROM python:3.11-slim

# Diretório da aplicação
WORKDIR /app

# Copia arquivos
COPY requirements.txt .

# Instala dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copia restante do projeto
COPY . .

# Porta do Flask
EXPOSE 8000

# Rodar Flask
CMD ["python", "app.py"]