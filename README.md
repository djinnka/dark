# k8s
1. Создать пользователя aws с ID & KEY доступом
2. Установить 
    - awscli
    - terraform
    - kubectl
3. В консоли aws создать ssh ключ (его имя потом прогписать в variables.tf)
4. Файл vars.tf - основные настройки кластера
    - ami
    - k8s_server_desired_capacity
    - k8s_server_min_capacity
    - k8s_server_max_capacity
    - k8s_worker_desired_capacity
    - k8s_worker_min_capacity
    - k8s_worker_max_capacity
5. Файл env/variables.tf - данные для проекта
    - AWS_REGION регион где запускать
    - my_public_ip_cidr IP адрес с которого будет доступ к k8s через LB (можно параметрами деплоймента закрыть public)
    - ssk_key_pair_name имя ключа ssh по которому будет доступ на ресурсы
Все разворачивается скрипт поправил (как по заданию 3 master 3 worker). Конфигурация автоматически сохраняется в SecretManager
(bastion.txt - деплоймент ec2 bastion host )

6. MetalLB - установка из https://artifacthub.io/packages/helm/bitnami/metallb (есть и другие варианты). В env/main.tf добавлено как дополнительный модуль



# Postgresql
Параметры в postgresql-terraform/variables.tf
    - ssh_key имя ключа ssh в aws console
    - workspace имя нового пользователя password парооль (эту переменную переделать через функцию random в terraform)
Не законченно - делал со старой версией postgresql (когда еще использовался файл recovery.conf) для полноценного использования надо закончить согласно  новых документаций
