#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Need to pass output tag"
  exit 1
fi

concurrencies=(1 2 4 6 8 12 16)

for concurrency in "${concurrencies[@]}"
do
  echo "Running '/' with $concurrency concurrency..."
  ab -n 200000 -l -c $concurrency -e "output/$1-$concurrency.csv" http://localhost:8080/
done

for concurrency in "${concurrencies[@]}"
do
  echo "Running '/user/:id' with $concurrency concurrency..."
  random=$[$RANDOM % 2048 + 1024]
  ab -n 200000 -l -c $concurrency -e "output/$1-$concurrency-user-$random.csv" "http://localhost:8080/user/$random"
done
