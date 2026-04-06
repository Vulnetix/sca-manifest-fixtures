FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM golang:1.22-alpine AS api
WORKDIR /api
COPY go.* ./
RUN go mod download
COPY . .
RUN go build -o server .

FROM redis:7.4-alpine AS cache

FROM postgres:16-alpine AS db

FROM nginx:1.27-alpine AS runtime
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=api /api/server /usr/local/bin/server
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
