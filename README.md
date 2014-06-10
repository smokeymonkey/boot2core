boot2core
===============
AWS上にCoreOS on EC2を立ち上げるためのスクリプト。  

使い方
===============
(0)$ git clone https://github.com/smokeymonkey/boot2core.git  
(1)https://discovery.etcd.io/newにアクセスしてTOKENを取得する。  
(2)$ cp cloud-config.yml.dist cloud-config.yml  
(3)$ vi cloud-config.yml  
(4)$ ruby ./boot2core.rb  

License
===============
This software is released under the MIT License, see LICENSE.txt.
