# Use a imagem oficial do Python como base
FROM python:3.9-slim

# Defina o diretório de trabalho
WORKDIR /app

# Copie o arquivo requirements.txt para o diretório de trabalho
COPY requirements.txt .

# Instale as dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copie o código da aplicação para o diretório de trabalho
COPY app.py .

# Expose a porta que a aplicação irá usar
EXPOSE 5555

# Defina o comando para executar a aplicação
CMD ["python", "app.py"]
