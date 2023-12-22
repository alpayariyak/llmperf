#!/bin/bash

# Output both to files. 1 to benchmark_A4000_7b_1.txt and 2 to benchmark_A4000_7b_2.txt 
echo "TEST benchmarks_out_A4000_7b" | tee -a benchmarks_A4000_7b.txt


# TEST 1
echo "TEST 1" >> benchmarks_out.txt
python -u llmperf.py -f runpod -r 100 -c 50  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=900 --gen-prompt new >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 200 -c 100  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=900 --gen-prompt new >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 400 -c 200  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=900 --gen-prompt new >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 400 -c 200 -b 20 -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=900 --gen-prompt new >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 50 -c 25  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=900 --gen-prompt new >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 15 -c 1  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=900 --gen-prompt new >> benchmarks_out.txt

# TEST 3
echo "TEST 3" >> benchmarks_out.txt
python -u llmperf.py -f runpod -r 300 -c 150  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=150 --min-lines 60 --max-lines 62 --gen-prompt old >> benchmarks_out.txt 
sleep 15
python -u llmperf.py -f runpod -r 200 -c 100  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=150 --min-lines 60 --max-lines 62 --gen-prompt old >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 400 -c 200  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=150 --min-lines 60 --max-lines 62 --gen-prompt old >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 100 -c 50  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=150 --min-lines 60 --max-lines 62 --gen-prompt old >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 15 -c 1  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=150 --min-lines 60 --max-lines 62 --gen-prompt old >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 20 -c 10  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=150 --min-lines 60 --max-lines 62 --gen-prompt old >> benchmarks_out.txt
sleep 15

# TEST 4
echo "TEST 4" >> benchmarks_out.txt
python -u llmperf.py -f runpod -r 15 -c 1  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=550 --min-lines 35 --max-lines 40 --gen-prompt both >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 200 -c 100  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=550 --min-lines 35 --max-lines 40 --gen-prompt both >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 400 -c 200  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=550 --min-lines 35 --max-lines 40 --gen-prompt both >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 100 -c 50  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=550 --min-lines 35 --max-lines 40 --gen-prompt both >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 300 -c 150  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=550 --min-lines 35 --max-lines 40 --gen-prompt both >> benchmarks_out.txt
sleep 15
python -u llmperf.py -f runpod -r 20 -c 10  -m mistralai/Mistral-7B-Instruct-v0.1 --max-tokens=550 --min-lines 35 --max-lines 40 --gen-prompt both >> benchmarks_out.txt
sleep 15
