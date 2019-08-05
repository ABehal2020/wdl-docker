#!/bin/bash
# updated

set -e # exit on error

WDL=$1
INPUT=$2
DOCKER_IMAGE=$3
CROMWELL_JAR=cromwell-42.jar
BACKEND_CONF=backends/backend.conf
RESULT_PREFIX=$(basename ${INPUT} .json)
METADATA=${RESULT_PREFIX}.metadata.json # metadata
RESULT=${RESULT_PREFIX}.result.json # output

if [ $4 = "docker" ]; then
    # Write workflow option JSON file for docker
    BACKEND=Local
    TMP_WF_OPT=$RESULT_PREFIX.test_toy_wf_opt.json
    cat > $TMP_WF_OPT << EOM
    {
        "default_runtime_attributes" : {
            "docker" : "$DOCKER_IMAGE"
        }
    }
EOM
fi

java -Dconfig.file=${BACKEND_CONF} -Dbackend.default=${BACKEND} -jar ${CROMWELL_JAR} run ${WDL} -i ${INPUT} -o ${TMP_WF_OPT} -m ${METADATA}

rm -f ${TMP_WF_OPT}
