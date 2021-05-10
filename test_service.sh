#!/bin/bash
curl localhost:5000/post -d "{\"input_text\": \"I am a happy person\"}" -H 'Content-Type: application/json' \r\n
curl localhost:5000/post -d "{\"input_text\": \"It was so sad\"}" -H 'Content-Type: application/json'