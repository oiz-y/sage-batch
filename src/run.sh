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

sage batch_calc_galois.sage ${MAX_TIMES} ${DEGREE} ${PRIME_RANGE} ${COEFFICIENT_RANGE} ${EXCEPT_GROUP}
