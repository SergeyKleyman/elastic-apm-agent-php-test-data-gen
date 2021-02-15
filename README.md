# elastic-apm-agent-php-test-data-gen

## Usage
```
docker build --rm -t php_agent_test_data_gen . && docker run --rm -e ELASTIC_APM_SERVER_URL=http://<HOST>:<PORT> -t php_agent_test_data_gen
```
