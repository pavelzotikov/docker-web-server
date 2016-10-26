### Описание
Ubuntu + PHP-5.6 + Apache2 + + MySQL + PhpMyAdmin + Nginx + Memcached + MongoDB + Redis

### Компиляция
```
docker build -t web-server -f Dockerfile .
```

### Запуск
```
docker run -v ~/<working directory>/:/var/www -p 80:80 -t web-server
```

### Просмотр запущенных сервисов
```
docker ps
```

### Убиваем процесс
```
docker kill <ProcessID>
```

### Консолька сервера
```
docker exec -i -t <ProcessID> /bin/bash
```
