# volume-demo/helper_scripts/alpine_wait_for_las_and_cas.sh
echo "Waiting for LAS to become ready..."
RET=0
timeout 60 bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 0.4; done' las 18766 || RET=$? || true
if [ $RET -ne 0 ]; then
    echo "FAIL! LAS didn't become available within one minute"
    exit 1
fi
echo "LAS is ready!"

echo "Waiting for CAS to become ready..."
RET=0
timeout 60 bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 0.4; done' cas 8081 || RET=$? || true
if [ $RET -ne 0 ]; then
    echo "FAIL! CAS didn't become available within one minute"
    exit 1
fi
echo "CAS is ready!"

# volume-demo/run.sh
set -x -e

# deploy the security policy session of the python app to CAS
# ./gen_policy.sh
#set -x -e

# generate a security policy session for python app using template
unset MRENCLAVE SCONE_CONFIG_ID
export MRENCLAVE=$(SCONE_HASH=1 python) # get MRENCLAVE/HASH of python
envsubst '$MRENCLAVE' < session_template.yml > session.yml
unset MRENCLAVE SCONE_CONFIG_ID 

# ./submit_policy.sh
#set -x -e

CAS_ADDR=cas
# get MRENCLAVE of CAS by running: docker-compose run -eSCONE_HASH=1 cas
CAS_MRENCLAVE="663ddae4f0036a39c18a533d97f7a5ba0850f2efb0147d63afa459a20315a7e1"

echo "Attesting CAS ..."
scone cas attest -G --only_for_testing-debug --only_for_testing-ignore-signer "$CAS_ADDR" "$CAS_MRENCLAVE"

echo "Uploading policy to CAS ..."
scone session create --use-env "session.yml"
echo ""

# clean output volume
rm -rf /demo/encrypted_volume/
mkdir /demo/encrypted_volume/

# execute the python app with the deployed security session
SCONE_VERSION=7 SCONE_CONFIG_ID=volume_policy/volume_service python3
