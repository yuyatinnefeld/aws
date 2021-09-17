# AWS RDS

## Setup

### Create a db instance
- Standard Create
- DB Type: MySQL
- Instance (Database): database-1
- Templates: Dev/Test
- Admin: admin
- Password: xxxx
- Instance class: memory optimized
- Public access: yes
- Additional configuration 
    - database name: demodb

### Use SQLTools of VS code and connect
- Connection Name: database-1
- Connect using: Server & Port
- Server Address (Endpoint): database-1.cjqrcfb7wdjn.eu-central-1.rds.amazonaws.com
- Port: 3306
- Database: demodb
- Admin: admin
- Password: xxxx

