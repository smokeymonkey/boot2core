boot2core
===============
AWS上にCoreOS on EC2を立ち上げるためのスクリプト。  
[http://dev.classmethod.jp/cloud/aws/boot2core/](http://dev.classmethod.jp/cloud/aws/boot2core/)

使い方
===============
(0)ローカル環境にコピーする。

    $ git clone https://github.com/smokeymonkey/boot2core.git  
    
(1)[https://discovery.etcd.io/new](https://discovery.etcd.io/new)にアクセスしてTOKENを取得する。  

(2)cloud-config.yml.distをコピーする。
    
    $ cp cloud-config.yml.dist cloud-config.yml  
    
(3)cloud-config.ymlを編集する。

    $ vi cloud-config.yml  
    
(4)実行する。
    
    $ ruby ./boot2core.rb  

License
===============
This software is released under the MIT License, see LICENSE.txt.
