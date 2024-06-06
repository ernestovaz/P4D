#!/bin/bash 

 
 echo "Start Host Container h1" 
 docker run -itd --name h1 --network="none" --privileged -v shared:/codes --workdir /codes dnredson/net
 alias h1="docker exec -it h1 /bin/bash" 
 
 
 echo "Start Switch Container sw1" 
 docker run -itd --name sw1 --network="none" --privileged -v shared:/codes  --workdir /codes dnredson/p4d
 alias sw1="docker exec -it sw1 /bin/bash" 
 alias logsw1="docker exec -it sw1 cat /tmp/switch.log" 
sw1() { 
docker exec -it sw1 /bin/bash 
} 
export -f sw1
logsw1() { 
docker exec -it sw1 cat /tmp/switch.log 
} 
export -f logsw1
 
 echo "Start Host Container h2" 
 docker run -itd --name h2 --network="none" --privileged -v shared:/codes --workdir /codes dnredson/net
 alias h2="docker exec -it h2 /bin/bash" 
 
 
 echo "Capturando o PID de cada container para adicionar ao namespace"
 PIDh1=$(docker inspect -f '{{.State.Pid}}' h1) 
PIDh2=$(docker inspect -f '{{.State.Pid}}' h2) 
PIDh1=$(docker inspect -f '{{.State.Pid}}' h1) 
PIDh2=$(docker inspect -f '{{.State.Pid}}' h2) 
PIDsw1=$(docker inspect -f '{{.State.Pid}}' sw1) 
PIDsw1=$(docker inspect -f '{{.State.Pid}}' sw1) 

 
 echo "Crianco VETH Peers"
 sudo ip link add h1-p1-sw1-p1 type veth peer name sw1-p1-h1-p1 
sudo ip link add sw1-p2-h2-p1 type veth peer name h2-p1-sw1-p2 

 
 echo "Configurando os Namespaces" 
 sudo ip link set h1-p1-sw1-p1 netns $PIDh1 
sudo ip link set sw1-p1-h1-p1 netns $PIDsw1 
sudo ip link set sw1-p2-h2-p1 netns $PIDsw1 
sudo ip link set h2-p1-sw1-p2 netns $PIDh2 

 
 echo "Configurando interfaces de rede" 
 sudo nsenter -t $PIDh1 -n ip addr add 10.0.1.2/32 dev h1-p1-sw1-p1 
sudo nsenter -t $PIDh1 -n ip link set dev h1-p1-sw1-p1 address 00:00:00:00:01:02 
sudo nsenter -t $PIDh1 -n ip link set h1-p1-sw1-p1 up 
sudo nsenter -t $PIDsw1 -n ip addr add 10.0.2.2/32 dev sw1-p1-h1-p1 
sudo nsenter -t $PIDsw1 -n ip link set dev sw1-p1-h1-p1 address 00:00:00:00:02:02 
sudo nsenter -t $PIDsw1 -n ip link set sw1-p1-h1-p1 up 
sudo nsenter -t $PIDh1 -n ip addr add 10.0.1.2/32 dev h1-p1-sw1-p1 
sudo nsenter -t $PIDh1 -n ip link set dev h1-p1-sw1-p1 address 00:00:00:00:01:02 
sudo nsenter -t $PIDh1 -n ip link set h1-p1-sw1-p1 up 
sudo nsenter -t $PIDsw1 -n ip addr add 10.0.2.2/32 dev sw1-p1-h1-p1 
sudo nsenter -t $PIDsw1 -n ip link set dev sw1-p1-h1-p1 address 00:00:00:00:02:02 
sudo nsenter -t $PIDsw1 -n ip link set sw1-p1-h1-p1 up 
sudo nsenter -t $PIDsw1 -n ip addr add 10.0.1.2/32 dev sw1-p2-h2-p1 
sudo nsenter -t $PIDsw1 -n ip link set dev sw1-p2-h2-p1 address 00:00:00:00:01:02 
sudo nsenter -t $PIDsw1 -n ip link set sw1-p2-h2-p1 up 
sudo nsenter -t $PIDh2 -n ip addr add 10.0.2.2/32 dev h2-p1-sw1-p2 
sudo nsenter -t $PIDh2 -n ip link set dev h2-p1-sw1-p2 address 00:00:00:00:02:02 
sudo nsenter -t $PIDh2 -n ip link set h2-p1-sw1-p2 up 
sudo nsenter -t $PIDsw1 -n ip addr add 10.0.1.2/32 dev sw1-p2-h2-p1 
sudo nsenter -t $PIDsw1 -n ip link set dev sw1-p2-h2-p1 address 00:00:00:00:01:02 
sudo nsenter -t $PIDsw1 -n ip link set sw1-p2-h2-p1 up 
sudo nsenter -t $PIDh2 -n ip addr add 10.0.2.2/32 dev h2-p1-sw1-p2 
sudo nsenter -t $PIDh2 -n ip link set dev h2-p1-sw1-p2 address 00:00:00:00:02:02 
sudo nsenter -t $PIDh2 -n ip link set h2-p1-sw1-p2 up 
docker exec h1 ip link set h1-p1-sw1-p1 promisc on 
docker exec sw1 ip link set sw1-p1-h1-p1 promisc on 
docker exec sw1 ip link set sw1-p2-h2-p1 promisc on 
docker exec h2 ip link set h2-p1-sw1-p2 promisc on 

 
 echo "Configurando Rota Padrão nos hosts (Valide no código suas rotas desejadas) " 
 
 
 echo "Por padrão, o código irá configurar o gateway de um host como a porta do switch ao qual está conectado" 
 # Por padrão, o código irá configurar o gateway de um host como a porta do switch ao qual está conectado 
# Altere estas linhas pare definir suas rotas da maneira que desejar 
docker exec h1 route add default gw 10.0.2.2 
docker exec h1 route add default gw 10.0.2.2 
docker exec h1 route add default gw 10.0.2.2 
docker exec h1 route add default gw 10.0.2.2 
docker exec h1 route add default gw 10.0.2.2 
docker exec h1 route add default gw 10.0.2.2 
docker exec h1 route add default gw 10.0.2.2 
docker exec h1 route add default gw 10.0.2.2 
docker exec sw1 sh -c 'echo 0 >> /proc/sys/net/ipv4/ip_forward' 
docker exec sw1 sh -c 'nohup simple_switch  --thrift-port 50001  -i 1@sw1-p1-h1-p1 -i 2@sw1-p2-h2-p1 code.json --log-console >> /tmp/switch.log &' 
docker exec sw1 sh -c 'echo "table_add MyIngress.ipv4_lpm ipv4_forward 10.0.1.2/32  => 00:00:00:00:01:02 1" | simple_switch_CLI --thrift-port 50001'  
docker exec sw1 sh -c 'echo "
table_add MyIngress.ipv4_lpm ipv4_forward 10.0.2.2/32 =>  00:00:00:00:02:02 2" | simple_switch_CLI --thrift-port 50001'  
docker exec sw1 sh -c 'echo 0 >> /proc/sys/net/ipv4/ip_forward' 
docker exec sw1 sh -c 'nohup simple_switch  --thrift-port 50001  -i 1@sw1-p1-h1-p1 -i 2@sw1-p2-h2-p1 code.json --log-console >> /tmp/switch.log &' 
docker exec sw1 sh -c 'echo "table_add MyIngress.ipv4_lpm ipv4_forward 10.0.1.2/32  => 00:00:00:00:01:02 1" | simple_switch_CLI --thrift-port 50001'  
docker exec sw1 sh -c 'echo "
table_add MyIngress.ipv4_lpm ipv4_forward 10.0.2.2/32 =>  00:00:00:00:02:02 2" | simple_switch_CLI --thrift-port 50001'  

