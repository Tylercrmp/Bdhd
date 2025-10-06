# 1. Этап сборки фронтенда
FROM node:18-alpine AS build

WORKDIR /app

# Копируем package.json и ставим все зависимости (включая dev)
COPY package*.json ./
RUN npm install

# Копируем остальные файлы и собираем Vite
COPY . .
RUN npm run build

# 2. Финальный минимальный образ
FROM node:18-alpine
WORKDIR /app

# Копируем только нужное из билд-образа
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/server.cjs ./server.cjs

# Устанавливаем только production-зависимости (легкий контейнер)
RUN npm prune --production

EXPOSE 8080

CMD ["node", "server.cjs"]

