### Описание
Ubuntu + Nginx + Apache2 + PHP-5.6 + MySQL + phpMyAdmin + Memcached + MongoDB + Redis + NodeJS.v7

### Использование
```
docker pull pavelzotikov/local-webserver
```

### Просмотр запущенных процессов
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
