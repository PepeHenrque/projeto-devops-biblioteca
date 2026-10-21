# Estágio 1: Instalação de dependências de produção
FROM node:22-alpine AS dependencies
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# Estágio 2: Imagem final de execução (leve e segura)
FROM node:22-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Usar usuário não-root (node) fornecido pela imagem oficial
USER node

# Copiar dependências de produção do estágio anterior
COPY --chown=node:node --from=dependencies /app/node_modules ./node_modules
COPY --chown=node:node package*.json ./
COPY --chown=node:node src/ ./src/
COPY --chown=node:node public/ ./public/

EXPOSE 3000

# Inicialização da aplicação
CMD ["node", "src/server.js"]

