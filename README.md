# llmperf

LLMPerf is a tool for benchmarking and validating the performance of LLMs. 

Benchmarking: LLMPerf measures time to first token (TTFT), 
inter-token latency (ITL) and requests that take longer than 3 seconds 
to start returning data. 

Validation: we send a simple query to the LLM and ensure the returned data 
is valid. In particular it checks for inter-request cross-over 
(request A gets the responses for request B). 

Variation in input and output token lengths is a design parameter
since this is intended to be representative. This is because
there are some optimizations (e.g. continuous batching) that 
we know work better with varying input and output length. 

## LLMPerf Leaderboard :trophy:

We have utilized the LLMPerf library to conduct benchmarking analysis of several selective endpoint providers,
including Fireworks, TogetherAI, Anyscale, Perplexity, and others. 
This benchmarking was aimed at evaluating the performance, reliability, and efficiency of these providers under various conditions. 
We hope the results obtained from this exercise help people understand the capabilities and limitations of each provider, thereby aiding in making informed decisions for future integrations and deployments. Here is a detailed report of our findings.

(Results as of November 29, 2023)

### Time to first token (seconds)

In streaming applications, the TTFT is how long before the LLM returns the first token.

![ttft](.assets/ttft.png)


| Framework  | Model                                          | Mean TTFT | Percentiles (P25 | P50 | P75 | P95 | P99)  |
|------------|------------------------------------------------|-----------|--------------------------------------------|
| anyscale   | meta-llama/Llama-2-70b-chat-hf                 | 0.288     | 0.200 | 0.287 | 0.307 | 0.522 | 0.651      |
| fireworks  | accounts/fireworks/models/llama-v2-70b-chat    | 0.416     | 0.309 | 0.335 | 0.407 | 0.651 | 0.802      |
| together   | together_ai/togethercomputer/llama-2-70b-chat  | 0.454     | 0.370 | 0.478 | 0.503 | 0.590 | 0.694      |
| perplexity | llama-2-70b-chat                               | 0.503     | 0.465 | 0.496 | 0.548 | 0.868 | 0.988      |



### E2E Time (seconds) 

The end to end time from when the request is made to the last token is received in the response.

![e2e](.assets/e2e.png)

| Framework  | Model                                          | Mean E2E  | Percentiles (P25 | P50 | P75 | P95 | P99)  |
|------------|------------------------------------------------|-----------|--------------------------------------------|
| together   | together_ai/togethercomputer/llama-2-70b-chat  | 1.952     | 1.770 | 1.967 | 2.097 | 2.277 | 2.406      |
| fireworks  | accounts/fireworks/models/llama-v2-70b-chat    | 3.587     | 3.410 | 3.502 | 3.715 | 4.127 | 4.429      |
| perplexity | llama-2-70b-chat                               | 3.716     | 3.254 | 3.460 | 3.867 | 5.153 | 5.305      |
| anyscale   | meta-llama/Llama-2-70b-chat-hf                 | 4.587     | 4.484 | 4.558 | 4.694 | 4.891 | 5.081      |


### Inter Token Latency (ms)

Inter-token latency is the average time between consecutive tokens, this is to avoid bias in systems that start streaming very late in end-to-end measurement. (Since not all systems support streaming, we have also omitted the percentiles since it's not meaningful).

![itl](.assets/itl.png)

| Framework  | Model                                          | Mean ITL  | Percentiles (P25 | P50 | P75 | P95 | P99)  |
|------------|------------------------------------------------|-----------|--------------------------------------------|
| together   | together_ai/togethercomputer/llama-2-70b-chat  | 12.120    | 11.200 | 12.273 | 12.939 | 14.083 | 14.880  |
| fireworks  | accounts/fireworks/models/llama-v2-70b-chat    | 23.082    | 21.885 | 22.560 | 23.880 | 26.715 | 28.497  |
| perplexity | llama-2-70b-chat                               | 24.591    | 21.541 | 22.913 | 25.572 | 34.125 | 35.134  |
| anyscale   | meta-llama/Llama-2-70b-chat-hf                 | 29.728    | 29.125 | 29.338 | 30.337 | 31.769 | 32.767  |



### Run Configurations

For each of the benchmark run, it is performed with the below command template:

```
   python token_benchmark_ray.py \
    --model <MODEL_NAME> \
    --mean-input-tokens 550 \
    --stddev-input-tokens 0 \
    --mean-output-tokens 150 \
    --stddev-output-tokens 0 \
    --max-num-completed-requests 150 \
    --num-concurrent-requests 5 \
    --llm-api <litellm/openai> 
```

For each provider, we perform a total of 150 requests, with concurrency of 5 (5 concurrent requests to the provider), with prompt's token length of 550, and expected output tokens length of 150. 


## Supported endpoints 

Currently supported endpoints include: 

- Any OpenAI compatible endpoints, including Anyscale Endpoints, 
Anyscale Private Endpoints, OpenAI, Fireworks, Perplexity etc
- Any [Huggingface Text Generation Inference](https://github.com/huggingface/text-generation-inference) endpoints
- Together 
- Vertex AI
- SageMaker

Please see `requirements.txt` for more details on dependency requirements.

## Upcoming refactor

This is prototype code. We are currently refactoring the code to be more
extensible (including a pluggable endpoints, varying traffic load etc). 

In addition we plan to:

- Make running the benchmark not only possible from 
command line, but also possible to integrate easily into CI/CD or job scheduling 
systems. 
- Control where the generated files and information go. 
- Automate report generation. 

We expect this refactor to be complete some time in November 2023. 

## A note on rate limits

Many LLM providers have extremely low rate limits by default (e.g. Perplexity 3 requests per 90 seconds). 

You can use the sleep parameter to overcome these difficulties, but it does affect the representativeness of the results. 

Other systems do not have rate limits, but we consider that if the TTFT exceeds 3 second for more than 
5% of queries that the system is overloaded. 


## Default values

Default values are the ones that we use for testing Anyscale Endpoints. 
The distribution of inputs and outputs roughly mirrors the input and output 
patterns we see there. 

We recommend setting the seed (or using the provided seed) to reduce variance but 
still have randomization.

Do a python llmperf.py --help to see all options. 

## Usage
1. Provide API base and key in .env file. Check out env_sample.txt
2. Test out Anyscale Endpoint with following command by sending 20 requests   
`python llmperf.py -r 20 -m "meta-llama/Llama-2-70b-chat-hf"`
3. Control input token numbers by setting min/max lines, and control output token number by setting req-lines and max_tokens  
`python llmperf.py -r 20 -f openai -m "gpt-3.5-turbo" --min-lines 8 --max-lines 10`  
`python llmperf.py -r 20 -f openai -m "gpt-3.5-turbo" --req-lines 3 --max-tokens 128`
4. Control sleep between rounds to avoid hitting rate limit  
`python llmperf.py -r 20 -f fireworks -m "accounts/fireworks/models/llama-v2-70b-chat" --sleep 10`
5. Output will be saved at **framework-timestamp.json** and **framework-timestamp_raw.json**  
6. Use Jupyter with analyze-raw.ipynb to visualize and/or interact with the raw data. 

