#!/bin/bash

type=$(gum choose "remove build-logs" "use existing build-logs")
if [ "$type" == "remove build-logs" ]; then
    rm -r build-logs
    gh run download $(gh run list --limit 1 --json databaseId --jq '.[0].databaseId')
fi

origin_failures=$(grep -L "Failures: 0" default-logs/build/logs/* | xargs -n1 basename | sort)
origin_errors=$(grep -L "Errors: 0" default-logs/build/logs/* | xargs -n1 basename | sort)

failures=$(grep -L "Failures: 0" build-logs/build/logs/* | xargs -n1 basename | sort)
errors=$(grep -L "Errors: 0" build-logs/build/logs/* | xargs -n1 basename | sort)

# Compare original failures to new failures and print new ones
echo "Original Failures:"
echo $origin_failures       
echo "New Failures:"
echo $failures
echo "--------------------------------"
echo "Original Errors:"
echo $origin_errors
echo "New Errors:"
echo $errors
echo "--------------------------------"
echo "Changed Failures:"
comm -3 <(echo "$origin_failures_list") <(echo "$failures_list")
echo "--------------------------------"
echo "Changed Errors:"
comm -3 <(echo "$origin_errors_list") <(echo "$errors_list")
