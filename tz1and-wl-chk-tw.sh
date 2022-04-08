#set -e

batchNum=$1
addrList="tz1and-tw-addr-"$batchNum".txt"

filenameTwAccount="tzid-report-tw-account-"$batchNum".txt"
filenameTweets="tzid-report-tweets-"$batchNum".txt"
filename="tzid-report-tw-"$batchNum".txt"

### twitter api  bearer key
bearer="AAAAAAAAAAAAAAAAAAAAAJAIbQEAAAAATxZD3oCRjb2Za32mHA76XhCtA%2BY%3DSVCxC66uWvZsdYHMOvu3DY3DPGM8oe3jbFh5Dsida120rwQYPF"
i=0

### see https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference/get-users-by-username-username#Optional
apiAccountUrl="https://api.twitter.com/2/users/by/username/"
apiAccountQuery="?user.fields=created_at,description,public_metrics"

### see https://developer.twitter.com/en/docs/twitter-api/users/lookup/api-reference/get-users
apiTweetUrl="https://api.twitter.com/2/users/"
apiTweetQuery="/tweets?exclude=replies,retweets&expansions=author_id"


# print field headings
echo ""\"id\" "\"username\" "\"name\" "\"created_at\" "\"followersCount\" "\"followingCount\" "\"tweetCount\" "\"listedCount\"" >$filename


rm $filenameTwAccount
rm $filenameTweets
rm $filename

echo "-------------------------------------------------------------------------"

while IFS= read -r line
do


echo "processing account: "$line
inputfile="tz1and-tw-addr-"$line".json"
inputfileTweets="tz1and-tweets-"$twId".json"


### get twitter account details
curl -Ss "$apiAccountUrl$line$apiAccountQuery" -H "Authorization: Bearer AAAAAAAAAAAAAAAAAAAAAJAIbQEAAAAATxZD3oCRjb2Za32mHA76XhCtA%2BY%3DSVCxC66uWvZsdYHMOvu3DY3DPGM8oe3jbFh5Dsida120rwQYPF" > $inputfile


### pause 5 seconds between curl so not overloading api
sleep 5



# use arg with tonumber as argjson didn't work - may need later version. this should work for earlier & later versions. could pipe through |xarg -n 4 instead of paste but this removes quote delimeters so harder to distinguish title and subtitle fields


	loopAccount=$(cat $inputfile | jq '.data.id, .data.username, .data.name,.data.created_at, .data.public_metrics.followers_count, .data.public_metrics.following_count, .data.public_metrics.tweet_count, .data.public_metrics.listed_count, .data.description')
	echo $loopAccount > tmpfile-tz1and-twAccount.txt
	cat tmpfile-tz1and-twAccount.txt
        paste -s -d ',' tmpfile-tz1and-twAccount.txt >> $filenameTwAccount


echo 	""
###echo "-------------------------------------------------------------------------"
	twIdString=$(cat $inputfile | jq '.data.id')
	twId=$(sed -e 's/^"//' -e 's/"$//' <<<$twIdString)
	echo "twitter id = "$twId


### get tweets
### curl "https://api.twitter.com/2/users/3033391/tweets?exclude=replies,retweets&expansions=author_id" -H "Authorization: Bearer AAAAAAAAAAAAAAAAAAAAAJAIbQEAAAAATxZD3oCRjb2Za32mHA76XhCtA%2BY%3DSVCxC66uWvZsdYHMOvu3DY3DPGM8oe3jbFh5Dsida120rwQYPF"

	curl -Ss "$apiTweetUrl$twId$apiTweetQuery" -H "Authorization: Bearer AAAAAAAAAAAAAAAAAAAAAJAIbQEAAAAATxZD3oCRjb2Za32mHA76XhCtA%2BY%3DSVCxC66uWvZsdYHMOvu3DY3DPGM8oe3jbFh5Dsida120rwQYPF" > $inputfileTweets

### pause 5 seconds between curl so not overloading api
sleep 5

        loopTweets=$(cat $inputfileTweets | jq '.data[0].author_id, .data[0].text, .data[1].text, .data[2].text')
        echo $loopTweets > tmpfile-tz1and-tweets.txt
	cat tmpfile-tz1and-tweets.txt

	paste -s -d ',' tmpfile-tz1and-tweets.txt >> $filenameTweets

echo "-------------------------------------------------------------------------"

### join account & tweets together
###	paste -s -d ',' $filenameTweets >> $filenameTwAccount

done < "$addrList"

echo "---------------------finished processing accounts------------------------"
cat $filenameTwAccount
cat $filenameTweets

echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "Use these files for validation report spreadsheet: "
echo "Twitter Accounts:	$filenameTwAccount"
echo "Tweets: 		$filenameTweets"

echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"



