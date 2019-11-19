#!/usr/bin/env bash

# Exit on any errors
set -e

find $CI_PROJECT_DIR/source/ -type f -name '*.list' -exec bash -c "sort -i -u \
	-f '{}' -o '{}' " \;

# Combine domain and wildcard domains for external usages

cd $CI_PROJECT_DIR/

find $CI_PROJECT_DIR/source/ -type f -name 'combined.txt' -delete

for d in `find source/ -mindepth 1 -maxdepth 1 -type d`
do
    cat ${d[@]}/*.list > ${d[@]}/combined.txt
done

# Import latest working example of safesearch from safesearc.mypdns.cloud
dig axfr @axfr.ipv4.mypdns.cloud -p 5353 safesearch.mypdns.cloud | grep -vE '^($|;)' > safesearch/safesearch.mypdns.cloud.rpz


exit ${?}
