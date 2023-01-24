set -x

if [ "${MAX_TIMES}" = "" ]; then
  MAX_TIMES=1
fi

if [ "${DEGREE}" = "" ]; then
  DEGREE=2
fi

if [ "${PRIME_RANGE}" = "" ]; then
  PRIME_RANGE=500
fi

if [ "${COEFFICIENT_RANGE}" = "" ]; then
  COEFFICIENT_RANGE=1000000000
fi

if [ "${EXCEPT_GROUP}" = "" ]; then
  EXCEPT_GROUP=NotSelected
fi

if [ "${OUTPUT_FILE_PATH}" = "" ]; then
  OUTPUT_FILE_PATH=./output.txt
fi

if [ "${S3_BUCKET}" = "" ]; then
  S3_BUCKET=sage-batch-bucket
fi

sage batch_calc_galois.sage ${MAX_TIMES} ${DEGREE} ${PRIME_RANGE} ${COEFFICIENT_RANGE} ${EXCEPT_GROUP} ${OUTPUT_FILE_PATH}

filename=`basename ${OUTPUT_FILE_PATH} | sed 's/\.[^\.]*$//'`.`date +%Y%m%d-%H%M%S`.txt
# tar -zcf ${filename}.tar.gz ${OUTPUT_FILE_PATH}

# aws s3 cp ${filename} s3://${S3_BUCKET}/`date +%Y`/`date +%m`/

aws s3 cp ${OUTPUT_FILE_PATH} s3://${S3_BUCKET}/`date +%Y`/`date +%m`/`date +%d`/${filename}
