#!/bin/bash

directory="$HOME/Downloads/daidalos-tmp"
hostname="hostname -f"
logz="${directory}/$(date +%Y_%m_%d)_daidalos_$(hostname)_$USER.log"
diskspace=$(df -g "$HOME" | awk 'NR==2{print $4}')

# Write ever stdout into file. -a = Append

exec &> >(tee -a "${logz}")

# Check for Directory. If its missing create directory.
# -d = check for directory

if [ -d ${directory} ]; then
	echo "[~] Directory already exists"
else
	echo "[+] Creating $HOME/Downloads/daidalos-tmp"
	mkdir ${directory}
fi

# Check for free diskspace before Downloading file.
# -gt greater than

if [ ${diskspace} -gt 10 ]; then
	echo "[+] Enough space on Filesystem"
else
	echo "[~] Not Enough space on Filesystem. Please have at least 10Gb"
	exit
fi

# Check if the File is already downloaded.
# -f = check for file in specific directory.

if [ -f "$directory/pgdump.ef24.sql" ]; then
	 echo "[~] Database exists, skip Downloading" 
else
	echo "[~] Starting Download at $(date +%H:%M:%S)"
	scp daidalos@zant:esther/*.sql $directory/pgdump.ef24.sql
	echo "[+] Download finished at $(date +%H:%M:%S)" 
fi

# Check for psql role 'ef24'. If it does not exist, create it.
# psql -t = Turn off printing of column names and result row count footers
# psql -A = no-allign mode
# psql -c = command. Uses the command in psql.

if psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='ef24'" | grep -q 1; then	
	echo "[~] User ef24 already exists" 
else
	echo "[+] Creating user ef24"
	createuser ef24
fi

# CHeck for psql role 'ef24_ro'. If it does not exists, create it.

if psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='ef24_ro'" | grep -q 1; then
	echo "[~] User ef24_ro already exists"
else
	echo "[+] Creating user ef24_ro"
	creteuser ef24_ro
fi

# Check for database 'ef24'. If it exists drop it.
# psql -l = list databases
# psql -q = quiet
# psql -t = Turn off printing of column names and result row count footers.
# grep -q = quiet.
# grep -w = only show words.

if psql -lqt | cut -d \| -f 1 |grep -qw "ef24"; then
	echo "[~] Dropping Database ef24"
	dropdb ef24
else
	echo "[-] No Database to drop"
fi

# Check for free diskspace before restoring the database.

if [ ${diskspace} -gt 35 ]; then
	echo "[+] Enough space for restore"
else
	echo "[-] Not enough space for restore. Have at least 35Gb and start again."
	exit
fi

# Restore Database with user ef24.
# See database check.

if psql -lqt | cut -d \| -f 1 |grep -qw "ef24"; then
	echo "[+] Restoring Database"
	pg_restore --dbname=ef24 ${directory}/pgdump.ef24.sql
else
	echo "[-] Restoring Database with owner ef24"
	createdb ef24 --owner=ef24
	pg_restore --dbname=ef24 ${directory}/pgdump.ef24.sql
fi

# Alter search_path

echo "[+] setting search_path"
psql postgres -tAc "ALTER ROLE ef24 SET search_path TO dbo"

# Anonymize user
echo "[+] getting anonymize script from zant"
scp daidalos@zant:/home/daidalos/bin/scripts/anonymize_db.sh ${directory}
sleep 10
echo "[+] Starting to anonymize Database ef24 at $(date +%Y_%m_%d_+%H_%M_%S)"
/bin/bash ${directory}/anonymize_db.sh
echo "[+] Finished anonymize Database ef24 at $(date +%Y_%m_%d_+%H_%M_%S)"


# Push logfiles to remote server and clean up.

echo "[~] Pushing logfile to zant and removing it from local machine at $(date +%H:%M:%S)"
scp ${logz} daidalos@zant:/home/daidalos/log/
sleep 20
rm -rf ${directory} 
