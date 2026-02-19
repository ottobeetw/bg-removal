FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
COPY dist/ /usr/share/nginx/html/dist/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
