```shell
cd kubernetes-debug
kubectl apply -f pod.yaml
kubectl debug -ti nginx --image=ubuntu --target=nginx 

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

kubectl debug node/cl189o2ou2ffoq6ti51g-ylyw -ti --image=ubuntu
root@cl189o2ou2ffoq6ti51g-ylyw:~# cat /host/var/log/pods/default_nginx_70214269-f513-4ac0-a444-c351292b42e4/nginx/0.log
2025-02-02T20:02:37.040692426Z stdout F 127.0.0.1 - - [03/Feb/2025:04:02:37 +0800] "GET / HTTP/1.1" 200 612 "-" "curl/8.5.0" "-"
2025-02-02T20:44:28.225169242Z stdout F 127.0.0.1 - - [03/Feb/2025:04:44:28 +0800] "GET / HTTP/1.1" 200 612 "-" "curl/8.5.0" "-"

kubectl delete -f pod.yaml

kubectl apply -f pod-ptrace.yaml
kubectl debug nginx -ti --image=ubuntu
```

