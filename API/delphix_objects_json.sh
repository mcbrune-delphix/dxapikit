#!/bin/bash
#v1.x

#########################################################
## Subroutines ...

source ./jqJSON_subroutines.sh

#########################################################
#                   DELPHIX CORP                        #
#########################################################

#########################################################
#Parameter Initialization

. ./delphix_engine.conf

#########################################################
#         NO CHANGES REQUIRED BELOW THIS POINT          #
#########################################################

echo "Authenticating on ${BaseURL}"

#########################################################
## Session and Login ...

RESULTS=$( RestSession "${DMUSER}" "${DMPASS}" "${BaseURL}" "${COOKIE}" "${CONTENT_TYPE}" )
#echo "Results: ${RESULTS}"
if [ "${RESULTS}" != "OK" ]
then
   echo "Error: Exiting ..."
   exit 1;
fi

echo "Session and Login Successful ..."

#
# about action alert analytics authorization capacity connectivity database environment fault group host
# jetstream job maskingjob namespace network permission policy replication repository role service session
# snapshot source sourceconfig system timeflow timezone toolkit user
#
 
JSON="{ \"delphix\": [ ";

STATUS=`curl -s -X GET -k ${BaseURL}/group -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON { \"group\": ${STATUS} }"

STATUS=`curl -s -X GET -k ${BaseURL}/database -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON , { \"database\": ${STATUS} }"

STATUS=`curl -s -X GET -k ${BaseURL}/source -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON , { \"source\": ${STATUS} }"

STATUS=`curl -s -X GET -k ${BaseURL}/sourceconfig -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON , { \"sourceconfig\": ${STATUS} }"

STATUS=`curl -s -X GET -k ${BaseURL}/environment -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON , { \"environment\": ${STATUS} }"

STATUS=`curl -s -X GET -k ${BaseURL}/host -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON , { \"host\": ${STATUS} }"

STATUS=`curl -s -X GET -k ${BaseURL}/about -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON , { \"about\": ${STATUS} }"

#
# DE keeps the last 1000 jobs within the DE so this could be pretty big ...
# But NOTE: the default pageSize=25, so if no option is set, then only the last 25 jobs are returned.
#
STATUS=`curl -s -X GET -k ${BaseURL}/job -b "${COOKIE}" -H "${CONTENT_TYPE}"`
RESULTS=$( jqParse "${STATUS}" "status" )
JSON="$JSON , { \"job\": ${STATUS} }"

#
# The end of concatenating JSON strings ...
#
JSON="$JSON ] }"

#echo $JSON

#echo $JSON | jq ".delphix[] | select (.database)"
#echo $JSON | jq ".delphix[] | select (.host)"

export JSON

echo "# Usage: . ./delphix_objects_json.sh"
echo "# The JSON environment variable will contain the API JSON data output from the APIs called within this script"
echo "# Examples: "
echo "#  echo \$JSON"
echo "#  echo \$JSON | jq \".delphix[] | select (.group)\""
echo "#  echo \$JSON | jq \".delphix[] | select (.database)\""
echo "#  echo \$JSON | jq \".delphix[] | select (.source)\""
echo "#  echo \$JSON | jq \".delphix[] | select (.sourceconfig)\""
echo "#  echo \$JSON | jq \".delphix[] | select (.environment)\""
echo "#  echo \$JSON | jq \".delphix[] | select (.host)\""
echo "#  echo \$JSON | jq \".delphix[] | select (.about)\""
echo "#  echo \$JSON | jq \".delphix[] | select (.job)\""

############## E O F ####################################
echo " "
echo "Done ..."
echo " "
###exit 0

