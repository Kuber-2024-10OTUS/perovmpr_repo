# Выполнено ДЗ №13 Диагностика и отладка в Kubernetes

- [x] Основное ДЗ
- [x] Задание со *
- [x] Задание со **

## В процессе сделано:
- Научился отлаживать контейнеры и ноды Kubernetes с помощью эфемернух контейнеров и kubectl debug

## Как запустить проект:
- Создать под
```shell
cd kubernetes-debug
kubectl apply -f pod.yaml
``` 
 - Подключиться к поду 
```shell
kubectl debug -ti nginx --image=perovmpr/ubuntu-strace-curl:0.0.2 --target=nginx
```
## Как проверить работоспособность:
- Проверим что доступена файловая система пода 
```shell
kubectl debug -ti nginx --image=perovmpr/ubuntu-strace-curl:0.0.2 --target=nginx 

root@nginx:/# ls -la /proc/1/root/etc/nginx/
total 48
drwxr-xr-x 3 root root 4096 Oct  5  2020 .
drwxr-xr-x 1 root root 4096 Feb  2 19:56 ..
drwxr-xr-x 2 root root 4096 Oct  5  2020 conf.d
-rw-r--r-- 1 root root 1007 Apr 21  2020 fastcgi_params
-rw-r--r-- 1 root root 2837 Apr 21  2020 koi-utf
-rw-r--r-- 1 root root 2223 Apr 21  2020 koi-win
-rw-r--r-- 1 root root 5231 Apr 21  2020 mime.types
lrwxrwxrwx 1 root root   22 Apr 21  2020 modules -> /usr/lib/nginx/modules
-rw-r--r-- 1 root root  643 Apr 21  2020 nginx.conf
-rw-r--r-- 1 root root  636 Apr 21  2020 scgi_params
-rw-r--r-- 1 root root  664 Apr 21  2020 uwsgi_params
-rw-r--r-- 1 root root 3610 Apr 21  2020 win-utf
```
 - Проверим что выполняется `tcpdump`
```shell
# Подключиться к контейнеру отладки и запустить tcpdump -nn -i any -e port 80
kubectl debug -ti nginx --image=perovmpr/ubuntu-strace-curl:0.0.2 --target=nginx 
root@nginx:/# tcpdump -nn -i any -e port 80

# В другом терминале запустить команду curl в новом контейнере отладки  
kubectl debug -ti nginx --image=perovmpr/ubuntu-strace-curl:0.0.2 --target=nginx -- curl 127.0.0.1

# В предыдущем терминале  получим вывод 
root@nginx:/# tcpdump -nn -i any -e port 80
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
20:44:28.224875 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.53906 > 127.0.0.1.80: Flags [S], seq 3095374208, win 65495, options [mss 65495,sackOK,TS val 1903018572 ecr 0,nop,wscale 7], length 0
20:44:28.224884 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.53906: Flags [S.], seq 113824525, ack 3095374209, win 65483, options [mss 65495,sackOK,TS val 1903018572 ecr 1903018572,nop,wscale 7], length 0
20:44:28.224891 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.53906 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 1903018572 ecr 1903018572], length 0
20:44:28.224949 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 144: 127.0.0.1.53906 > 127.0.0.1.80: Flags [P.], seq 1:73, ack 1, win 512, options [nop,nop,TS val 1903018572 ecr 1903018572], length 72: HTTP: GET / HTTP/1.1
20:44:28.224953 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.53906: Flags [.], ack 73, win 512, options [nop,nop,TS val 1903018572 ecr 1903018572], length 0
20:44:28.225041 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 310: 127.0.0.1.80 > 127.0.0.1.53906: Flags [P.], seq 1:239, ack 73, win 512, options [nop,nop,TS val 1903018572 ecr 1903018572], length 238: HTTP: HTTP/1.1 200 OK
20:44:28.225046 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.53906 > 127.0.0.1.80: Flags [.], ack 239, win 511, options [nop,nop,TS val 1903018572 ecr 1903018572], length 0
20:44:28.225064 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 684: 127.0.0.1.80 > 127.0.0.1.53906: Flags [P.], seq 239:851, ack 73, win 512, options [nop,nop,TS val 1903018572 ecr 1903018572], length 612: HTTP
20:44:28.225067 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.53906 > 127.0.0.1.80: Flags [.], ack 851, win 507, options [nop,nop,TS val 1903018572 ecr 1903018572], length 0
20:44:28.225425 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.53906 > 127.0.0.1.80: Flags [F.], seq 73, ack 851, win 512, options [nop,nop,TS val 1903018573 ecr 1903018572], length 0
20:44:28.225451 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.53906: Flags [F.], seq 851, ack 74, win 512, options [nop,nop,TS val 1903018573 ecr 1903018573], length 0
20:44:28.225456 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.53906 > 127.0.0.1.80: Flags [.], ack 852, win 512, options [nop,nop,TS val 1903018573 ecr 1903018573], length 0
```
 - Выполним `strace`
```shell
# Создадим под с привилегиями для взаимодействия с нодой.
kubectl apply -f debug_pod.yaml
# Подключаемся 
k exec debugger-pod -ti -- bash
# Находим pid процесса nginx
ps -ax | grep nginx
  57767 ?        Ss     0:00 nginx: master process nginx -g daemon off;
  57780 ?        S      0:00 nginx: worker process
  59071 pts/2    S+     0:00 grep --color=auto nginx
# Запускаем strace
 strace -p 57780
strace: Process 57780 attached
epoll_wait(8,
# В новом терминале запускаем curl запрос
kubectl debug -ti nginx --image=perovmpr/ubuntu-strace-curl:0.0.2 --target=nginx -- curl 127.0.0.1

# Вывод strace
# strace -p 57780
strace: Process 57780 attached
epoll_wait(8, [{events=EPOLLIN, data={u32=448065552, u64=140106576228368}}], 512, -1) = 1
accept4(6, {sa_family=AF_INET, sin_port=htons(38076), sin_addr=inet_addr("127.0.0.1")}, [112 => 16], SOCK_NONBLOCK) = 3
epoll_ctl(8, EPOLL_CTL_ADD, 3, {events=EPOLLIN|EPOLLRDHUP|EPOLLET, data={u32=448066016, u64=140106576228832}}) = 0
epoll_wait(8, [{events=EPOLLIN, data={u32=448066016, u64=140106576228832}}], 512, 60000) = 1
recvfrom(3, "GET / HTTP/1.1\r\nHost: 127.0.0.1\r"..., 1024, 0, NULL, NULL) = 72
stat("/usr/share/nginx/html/index.html", {st_mode=S_IFREG|0644, st_size=612, ...}) = 0
openat(AT_FDCWD, "/usr/share/nginx/html/index.html", O_RDONLY|O_NONBLOCK) = 11
fstat(11, {st_mode=S_IFREG|0644, st_size=612, ...}) = 0
writev(3, [{iov_base="HTTP/1.1 200 OK\r\nServer: nginx/1"..., iov_len=238}], 1) = 238
sendfile(3, 11, [0] => [612], 612)      = 612
write(5, "127.0.0.1 - - [03/Feb/2025:20:15"..., 89) = 89
close(11)                               = 0
setsockopt(3, SOL_TCP, TCP_NODELAY, [1], 4) = 0
epoll_wait(8, [{events=EPOLLIN|EPOLLRDHUP, data={u32=448066016, u64=140106576228832}}], 512, 65000) = 1
recvfrom(3, "", 1024, 0, NULL, NULL)    = 0
close(3)                                = 0
epoll_wait(8,


```
## PR checklist:
- [x] Выставлен label с темой домашнего задания
