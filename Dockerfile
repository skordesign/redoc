# Stage 1
FROM node:15.11.0-alpine as react-build
WORKDIR /app
COPY ./app/ .
RUN npm install
RUN npm run-script build

# Stage 2 - the production environment
FROM nginx:alpine
LABEL name "redoc"
LABEL author "volbrene"
LABEL maintainer "skordesign"

ENV URLS="[{url: 'https://api-stg.popeyes.vn/api/v1/product-docs/v1/swagger.json', name: 'Product API v1'}, \
           {url: 'https://api-stg.popeyes.vn/api/v1/basket-docs/v1/swagger.json', name: 'Basket API v1'}, \
           {url: 'https://api-stg.popeyes.vn/api/v1/content-docs/v1/swagger.json', name: 'Content API v1'}, \
           {url: 'https://api-stg.popeyes.vn/api/v1/order-docs/v1/swagger.json', name: 'Order API v1'}, \
           {url: 'https://api-stg.popeyes.vn/api/v1/promotion-docs/v1/swagger.json', name: 'Promotion API v1'}, \
           {url: 'https://api-stg.popeyes.vn/api/v1/identity-docs/v1/swagger.json', name: 'Identity API v1'}, \
           {url: 'https://api-stg.popeyes.vn/api/v1/store-docs/v1/swagger.json', name: 'Store API v1'}, \
           {url: 'https://api-stg.popeyes.vn/api/v1/reward-docs/v1/swagger.json', name: 'Reward API v1'}]"
ENV BASE_NAME="/api/v1/docs"
ENV THEME_COLOR="#32329f"
ENV PAGE_TITLE="Popeyes API Document"

WORKDIR /var/www/html

COPY --from=react-build /app/build /var/www/html
COPY ./docker/run.sh /
COPY ./docker/default.conf /etc/nginx/conf.d

RUN chmod +x /run.sh
RUN chmod +x /etc/nginx/conf.d/default.conf

CMD ["/run.sh"]
