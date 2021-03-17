## SCONE FSPF Volume Demo
This repository contains SCONE FSPF volume demo.

### Details
Try it out by executing:
```bash
git clone https://github.com/YueWang1996/volume-demo-test.git && cd volume-demo-test
```
Then, you execute the following command:
```bash
docker-compose run volume-demo-test bash
```
Note that running with docker-compose it automatically start CAS service for you.
Next go to the demo directory:
```bash
 cd /demo/ && ./run.sh
```
Alternatively, you can just run this demo by a single command: 
```bash
docker-compose up
```
It will automatically run benchmark of paddle
