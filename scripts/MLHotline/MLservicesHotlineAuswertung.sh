#!/usr/bin/env bash
# ML Service Wochenauswertung für Fabi Ticket#2018020510015134
# Totale/Durchschnittliche Gespächszeit und Gesprächsanzahl gesamt.
# Totale/Durchschnittliche Gespächszeit und Gesprächsanzahl pro Mitarbeiter.
# Sowohl inbound als auch outbound.
# 2018-02-07
#set -x

# Mysql Access
mysqlCmd="/usr/bin/mysql -N -uroot -postsee -e"

# Get dates and time
currentDate="$(date +%Y-%m-%d)"
weekBegin="$(date -d "$currentDate" -d "-7 days" "+%Y-%m-%d 00:00:00")"
weekEnd="$(date -d "$currentDate" -d "-1 days" "+%Y-%m-%d 00:00:00")"
secs_per_min=60
secs_per_hour=3600
counterTotalOut=0
totalTimeOut=0
totalAvgTimeOut=0

# SQL queries
totalTimeInQuery="SELECT SUM(TIME_TO_SEC(TIMEDIFF(EndTime, StartTime))) FROM netphone_cdr.IpPbxCDR WHERE OriginationName LIKE 'Ml Services (2072): %' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"
totalAvgTimeInQuery="SELECT AVG(TIME_TO_SEC(TIMEDIFF(EndTime, StartTime))) FROM netphone_cdr.IpPbxCDR WHERE OriginationName LIKE 'Ml Services (2072): %' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"
totalCountInQuery="SELECT count(*) FROM netphone_cdr.IpPbxCDR WHERE OriginationName LIKE 'Ml Services (2072): %' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"

## ARRAYS
# Query Array
declare -A queryArr
queryArr=([totalTimeInQuery]="$totalTimeInQuery" [totalAvgTimeInQuery]="$totalAvgTimeInQuery")

# Mitarbeiter array
declare -A maArr
maArr=([mg]="Martin Gardt" [kd]="Klara Dluga" [ko]="Kristof Ohrt" [kw]="Konstantin Wolkowa" [dm]="Devin Masurat" [ss]="Samantha Schmidt" [lv]="Liza-Marie Viebrock" [xb]="Xaver Berg" [mw]="Milan Wack" [ke]="Kay Eichelbaum" [jw]="Jakub Waszkiewicz" [ac]="Andy Colell" [su]="Simon Untiedt" ["rm"]="René Mumme" [md]="Melanie Dietz" [rg]="Rafael Grzonka" [ah]="Aly Hmayun" [rr]="Remo Reinert" [za]="Zehra Aksu")


## OUTPUT
echo "Subject: ML Services Wochenauswertung von $(date -d "$weekBegin" "+%Y-%m-%d") bis $(date -d "$weekEnd" "+%Y-%m-%d")"
echo ""
echo "ML Services Wochenauswertung"
echo ""

for ma in "${!maArr[@]}"; do
	echo "${maArr[$ma]}"

	# Mitarbeiter queries
	maTimeInQuery="SELECT SUM(TIME_TO_SEC(TIMEDIFF(EndTime, StartTime))) FROM netphone_cdr.IpPbxCDR WHERE DestinationName = '${maArr[$ma]}' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"
	maTimeOutQuery="SELECT SUM(TIME_TO_SEC(TIMEDIFF(EndTime, StartTime))) FROM netphone_cdr.IpPbxCDR WHERE OriginationName = '${maArr[$ma]}' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"
	maAvgTimeInQuery="SELECT AVG(TIME_TO_SEC(TIMEDIFF(EndTime, StartTime))) FROM netphone_cdr.IpPbxCDR WHERE DestinationName = '${maArr[$ma]}' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"
	maAvgTimeOutQuery="SELECT AVG(TIME_TO_SEC(TIMEDIFF(EndTime, StartTime))) FROM netphone_cdr.IpPbxCDR WHERE OriginationName = '${maArr[$ma]}' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"

	# Mitarbeiter Array
	declare -A maQueryArr
	maQueryArr=([maTimeInQuery]="$maTimeInQuery" [maTimeOutQuery]="$maTimeOutQuery" [maAvgTimeInQuery]="$maAvgTimeInQuery" [maAvgTimeOutQuery]="$maAvgTimeOutQuery")

	for maq in "${!maQueryArr[@]}"; do
		maTimeSecs="$($mysqlCmd "${maQueryArr[$maq]}")"

		if [[ $maTimeSecs == NULL ]]; then
			echo "Keine Gespräche gefunden."
		else
			case $maq in
				maTimeInQuery)
					info="Telefonierte Zeit eingehend"
					;;
				maTimeOutQuery)
					info="Telefonierte Zeit ausgehend"
					totalTimeOut="$(echo "$totalTimeOut+$maTimeSecs" | bc)"
					;;
				maAvgTimeInQuery)
					info="Durchschnittliche Gesprächszeit eingehend"
					;;
				maAvgTimeOutQuery)
					info="Durchschnittliche Gesprächszeit ausgehend"
					totalAvgTimeOut="$(echo "$totalAvgTimeOut+$maTimeSecs" | bc)"
					;;
				*)
					echo "Not found"
			esac

			maTimeHours="$(echo "$maTimeSecs/$secs_per_hour" | bc)"
			maTimeMins="$(echo "$maTimeSecs/$secs_per_min" | bc )"
			maTimeMinsLeft="$(echo "$maTimeMins%$secs_per_min" | bc)"
			maTimeSecsLeft="$(echo "$maTimeSecs%$secs_per_min" | bc)"
			maTime="$maTimeHours Stunden, $maTimeMinsLeft Minuten und $maTimeSecsLeft Sekunden"


			echo "$info: $maTime"
		fi
	done

	maCounterInQuery="SELECT count(*) FROM netphone_cdr.IpPbxCDR WHERE DestinationName = '${maArr[$ma]}' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"
	maCounterOutQuery="SELECT count(*) FROM netphone_cdr.IpPbxCDR WHERE OriginationName = '${maArr[$ma]}' AND StartTime >= '$weekBegin' AND EndTime <= '$weekEnd' AND State = 'Connected';"

	maCounterIn="$($mysqlCmd "$maCounterInQuery")"
	echo "Eingehende Telefonate geführt: $maCounterIn"
	maCounterOut="$($mysqlCmd "$maCounterOutQuery")"
	echo "Ausgehende Telefonate geführt: $maCounterOut"
	echo ""

	counterTotalOut="$(echo "$counterTotalOut+$maCounterOut" | bc)"
done

# Print line for better visualisation
echo "-------------------------------------------------------------------------------------"
echo ""

# For loop for Time queries
for i in "${!queryArr[@]}"; do
       timeSecs="$($mysqlCmd "${queryArr[$i]}")"

       case $i in
               totalTimeInQuery)
                       info2="Insgesamt telefonierte Zeit eingehend"
                       ;;
               totalAvgTimeInQuery)
                       info2="Durchschnittlich telefonierte Zeit eingehend"
                       ;;
               *)
                       info2="Not found"
       esac

       timeHours="$(echo "$timeSecs/$secs_per_hour" | bc)"
       timeMins="$(echo "$timeSecs/$secs_per_min" | bc )"
       timeMinsLeft="$(echo "$timeMins%$secs_per_min" | bc)"
       timeSecsLeft="$(echo "$timeSecs%$secs_per_min" | bc)"
       time="$timeHours Stunden, $timeMinsLeft Minuten und $timeSecsLeft Sekunden"

       echo "$info2: $time"
done
echo ""

# Outbound time
timeOutHours="$(echo "$totalTimeOut/$secs_per_hour" | bc)"
timeOutMins="$(echo "$totalTimeOut/$secs_per_min" | bc )"
timeOutMinsLeft="$(echo "$timeOutMins%$secs_per_min" | bc)"
timeOutSecsLeft="$(echo "$totalTimeOut%$secs_per_min" | bc)"
timeOut="$timeOutHours Stunden, $timeOutMinsLeft Minuten und $timeOutSecsLeft Sekunden"
echo "Insgesamt telefonierte Zeit ausgehend: $timeOut"

# Outbound Avg time
totalAvgTimeSecs="$(echo "$totalAvgTimeOut/${#maArr[@]}" | bc)"
timeAvgOutHours="$(echo "$totalAvgTimeSecs/$secs_per_hour" | bc)"
timeAvgOutMins="$(echo "$totalAvgTimeSecs/$secs_per_min" | bc )"
timeAvgOutMinsLeft="$(echo "$timeAvgOutMins%$secs_per_min" | bc)"
timeAvgOutSecsLeft="$(echo "$totalAvgTimeOut%$secs_per_min" | bc)"
timeAvgOut="$timeAvgOutHours Stunden, $timeAvgOutMinsLeft Minuten und $timeAvgOutSecsLeft Sekunden"
echo "Durchschnittliche telefonierte Zeit ausgehend: $timeAvgOut"
echo ""

# Show counters
counterTotalIn="$($mysqlCmd "$totalCountInQuery")"
echo "Insgesamt Telefonate eingehend: $counterTotalIn"
echo "Insgesamt Telefonate ausgehend: $counterTotalOut"
echo ""
