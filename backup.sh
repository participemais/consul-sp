set -o errexit
set -o pipefail
pg_dumpall --no-password –U postgres > /home/backups/consul/consul_database_backup_`date+%Y%m%d"_"%H%M%S`.sql
