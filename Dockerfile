FROM node:20-alpine AS base
RUN corepack enable && corepack prepare yarn@4.3.1

FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock .yarnrc.yml ./ 
RUN yarn --frozen-lockfile 

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/.yarn ./.yarn
COPY . .
RUN yarn build

# 컨테이너의 수신 대기 포트를 3000으로 설정
EXPOSE 3000
ENV PORT 3000

# # # # node로 애플리케이션 실행
CMD HOSTNAME="0.0.0.0" yarn start