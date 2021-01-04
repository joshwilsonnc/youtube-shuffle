FROM node:latest AS build

WORKDIR /usr/src/youtube-shuffler/

# Setup npm project
COPY package*.json ./
RUN npm ci --only=production

# Bundle app source
COPY . .
RUN npm run build

FROM python:3
WORKDIR /root/

COPY --from=build /usr/src/youtube-shuffler/dist ./dist/

RUN mkdir .config

COPY requirements.txt api.py ./
COPY config ./config/

RUN ls

RUN pip install --no-cache -r requirements.txt

EXPOSE 8080

CMD ["python", "./api.py"]