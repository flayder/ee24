Development in docker
===========================
1. Setup .env file (look on example)
2. Start docker compose 'docker-compose up -d'
3. Upload dev backup db to mysql comtainer 'cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE'.
Where:
CONTAINER - name of mysql container (look on 'docker ps').
DATABASE - db name on container side from .env
