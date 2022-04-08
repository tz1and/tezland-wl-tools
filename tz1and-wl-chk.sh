#set -e

batchNum=$1
addrList="tz1and-"$batchNum".txt"

filename="tzid-report-"$batchNum".txt"
i=0


# print field headings
echo ""\"Type\" "\"Address\" "\"Alias\" "\"Revealed\" "\"Balance\" "\"Counter\" "\"NumContracts\" "\"ActiveTokensCount\" "\"TokenBalancesCount\" "\"TokenTransfersCount\" "\"NumTransactions\" "\"NumReveals\" "\"FirstActivity\" "\"firstActivityTime\" "\"LastActivity\" "\"lastActivityTime\"" >$filename


while IFS= read -r line
do


echo "processing account: "$line
inputfile="tz1and-acl-addr-"$line".json"

curl -Ss https://api.tzkt.io/v1/accounts/$line > $inputfile

### pause 5 seconds between curl so not overloading api
sleep 5



# use arg with tonumber as argjson didn't work - may need later version. this should work for earlier & later versions. could pipe through |xarg -n 4 instead of paste but this removes quote delimeters so harder to distinguish title and subtitle fields


	loop=$(cat $inputfile | jq '.type, .address, .alias, .revealed, .balance, .counter, .numContracts, .activeTokensCount, .tokenBalancesCount, .tokenTransfersCount, .numTransactions, .numReveals, .firstActivity, .firstActivityTime, .lastActivity, .lastActivityTime')
	echo $loop > tmpfile-tz1and-acl.txt
#	cat tmpfile-tz1and-acl.txt
        paste -s -d ',' tmpfile-tz1and-acl.txt >> $filename



done < "$addrList"

cat $filename
