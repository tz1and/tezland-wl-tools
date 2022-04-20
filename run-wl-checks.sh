batchNum=$1
tzAddresses="tz1and-"$batchNum".txt"
twIds="tz1and-tw-addr-"$batchNum".txt"

cp accounts-combined.txt accounts-combined-bkp.txt
echo "--------------------------------------------------------------------------------"
echo "create tz1and-"$batchNum".txt file with wallet ids"
echo "create tz1and-tw-addr-"$batchNum".txt with twitter ids with leading @ removed"

echo "press any key to continue"
while [ true ] ; do
  read -t 3 -n 1
    if [ $? = 0 ] ; then
  	break ;
	else
  	echo "press any key to continu"
    fi
done

echo "---------------------- processing data - started -------------------------------"

echo "---------------------- checking for duplicates ---------------------------------"
echo "   known duplicates list - manually resolve if there are any others and restart this process"
echo "   combined list: <count> <duplicate walletId>"
echo  ""
echo "2 tz1PvjrTAMwwKEDshvUC1KWbboZisGpSwbEB"
echo "2 tz1Q3Rs6vdu8rRbR54MjvcdWWuBp2A8Td5Li"
echo "2 tz1QBxzRiadBrJCd5fM1w2R4WVRZoYd3cxrF"
echo "2 tz1QHYQ19QqY7pUUPWZMjBRpy8VmoH3Qq4zK"
echo "2 tz1QsnKcKZAdxRiEB9GrtSiQvFuKSKicWTuv	(orig list)"
echo "2 tz1RGMVNoHvxeYxmghxrKa3DHakE4UJiKyG4"
echo "2 tz1UP4HTubMaPKfGjACDuaxPA5SV69sjdJt8"
echo "2 tz1ajbUoguHiipVftY865tu8r1aRYEVWMKZz"
echo "2 tz1cJzxmHFKdGNYXeCkWyrY2AYnWuajMVNfx"
echo "2 tz1fafAoXcuRGzxTxNyiP5eT3nYEcngyrh9E"
echo "2 tz1iJSdZUBe6Hq9MLmyyvCm8JHYuQ4k6MzY7"
echo "3 tz2A1H2nqwm2ZYzyRsFs1iWPsCjdmWd4Srmz	(orig list)"
echo ""
echo ""

cat "$tzAddresses" >> accounts-combined.txt
sort accounts-combined.txt |uniq -c |grep -v '^ *1 '

echo "press any key to continue"
while [ true ] ; do
  read -t 10 -n 1
    if [ $? = 0 ] ; then
        break ;
        else
        echo "press any key to continu"
    fi
done

echo ""
echo ""

echo "---------------------- checking blockchain accounts  ---------------------------------"
./tz1and-wl-chk.sh $batchNum

echo "---------------------- checking twitter accounts and tweets  -------------------------"
./tz1and-wl-chk-tw.sh $batchNum

mv *.json json/
mv tmpfile-* tmpfiles
mv tz1and-b*.txt batches/
mv tz1and-tw*.txt batches/
mv tzid-report*.txt reports/

echo "---------------------- processing data - completed -------------------------------"
