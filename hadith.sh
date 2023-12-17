#!/bin/bash

DATA=$(curl "https://random-hadith-generator.vercel.app/bukhari/");
echo $DATA | jq -r '.data.hadith_english'

