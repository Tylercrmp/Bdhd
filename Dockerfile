# 1. Базовый образ
FROM node:18-alpine AS build

# 2. Рабочая директория
WORKDIR /app

# 3. Копируем package.json
COPY package*.json ./

# 4. Устанавливаем зависимости (без npm ci!)
RUN npm install --production

# 5. Копируем остальные файлы
COPY . .

# 6. Собираем фронтенд (если есть Vite)
RUN npm run build

# 7. Финальный минимальный образ
FROM node:18-alpine
WORKDIR /app

COPY --from=build /app /app

# 8. Открываем порт
EXPOSE 8080

# 9. Запускаем сервер
CMD ["node", "server.cjs"]

