#!/bin/bash

VERSION=1.20

usage() {
cat <<EOF
Eschalot version $VERSION
Copyright (C) 2015 Bright Things UN Ltd. <info@bright-things.com>

Eschalot will use brute force to create "readable" .onion addresses.

Usage: eschalot [option [option]...]

Options:

    -h --help          Display this help text
    -v --verbose       Verbose output
    -i --interval      Minimum interval between updates in seconds (default: 10)
    --mqtthost         MQTT server hostname or IP address (default: mqtt.bright-things.net)
    --mqttuser         MQTT user name
    --mqttpwd          MQTT password
    --tshost           ThingSpeak server hostname or IP address (default: demo.bright-things.com)
    --tsapikey         ThingSpeak API key
    --topic1           MQTT topic for field1
    --topic2           MQTT topic for field2
    --topic3           MQTT topic for field3
    --topic4           MQTT topic for field4
    --topic5           MQTT topic for field5
    --topic6           MQTT topic for field6
    --topic7           MQTT topic for field7
    --topic8           MQTT topic for field8
    --value1           JSON value for field1
    --value2           JSON value for field2
    --value3           JSON value for field3
    --value4           JSON value for field4
    --value5           JSON value for field5
    --value6           JSON value for field6
    --value7           JSON value for field7
    --value8           JSON value for field8
    
EOF
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

TEMP=`getopt -n mqtt2ts -o vhi: --longoptions help,verbose,interval:,mqtthost:,mqttuser:,mqttpwd:,tsurl:,tsapikey:,topic1:,topic2:,topic3:,topic4:,topic5:,topic6:,topic7:,topic8:,value1:,value2:,value3:,value4:,value5:,value6:,value7:,value8 -- "$@"`

if [ $? != 0 ]; then 
    usage
    exit 1
fi

eval set -- "$TEMP"

INTERVAL=10
MQTTHOST=mqtt.bright-things.net
TSURL=https://demo.bright-things.com
while true; do
    case "$1" in
        --help) 
            usage
            exit 1
            ;;
        --verbose)
            VERBOSE=1
            shift
            ;;
        -i|--interval)
            INTERVAL="$2"
            shift 2
            ;;
        --mqtthost)
            MQTTHOST="$2"
            shift 2
            ;;
        --mqttuser)
            MQTTUSER="$2"
            shift 2
            ;;
        --mqttpwd)
            MQTTPWD="$2"
            shift 2
            ;;
        --tsurl)
            TSURL="$2"
            shift 2
            ;;
        --tsapikey)
            TSAPIKEY="$2"
            shift 2
            ;;
        --topic1)
            T1="$2"
            shift 2
            ;;
        --topic2)
            T2="$2"
            shift 2
            ;;
        --topic3)
            T3="$2"
            shift 2
            ;;
        --topic4)
            T4="$2"
            shift 2
            ;;
        --topic5)
            T5="$2"
            shift 2
            ;;
        --topic6)
            T6="$2"
            shift 2
            ;;
        --topic7)
            T7="$2"
            shift 2
            ;;
        --topic8)
            T8="$2"
            shift 2
            ;;
        --value1)
            V1="$2"
            shift 2
            ;;
        --value2)
            V2="$2"
            shift 2
            ;;
        --value3)
            V3="$2"
            shift 2
            ;;
        --value4)
            V4="$2"
            shift 2
            ;;
        --value5)
            V5="$2"
            shift 2
            ;;
        --value6)
            V6="$2"
            shift 2
            ;;
        --value7)
            V7="$2"
            shift 2
            ;;
        --value8)
            V8="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *) 
            break;
            ;;
    esac
done

if [ -z "$T1" -a -z "$T2" -a -z "$T3" -a -z "$T4" -a -z "$T5" -a -z "$T6" -a -z "$T7" -a -z "$T8" ]; then
    echo "Error: At least one topic must be subscribed!"
    usage
    exit 1
fi 

SUBSCRIBE="mosquitto_sub -v -i ${HOSTNAME}"
[ -z "$MQTTHOST" ] || SUBSCRIBE="${SUBSCRIBE} -h ${MQTTHOST}"
[ -z "$MQTTUSER" ] || SUBSCRIBE="${SUBSCRIBE} -u ${MQTTUSER}"
[ -z "$MQTTPWD" ] || SUBSCRIBE="${SUBSCRIBE} -P ${MQTTPWD}"
[ -z "$T1" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T1}"
[ -z "$T2" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T2}"
[ -z "$T3" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T3}"
[ -z "$T4" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T4}"
[ -z "$T5" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T5}"
[ -z "$T6" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T6}"
[ -z "$T7" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T7}"
[ -z "$T8" ] || SUBSCRIBE="${SUBSCRIBE} -t ${T8}"

echo "Got here"

[ -z "$VERBOSE" ] || echo "Interval: $INTERVAL"
[ -z "$VERBOSE" ] || echo "Subscribe: $SUBSCRIBE"

LAST=`date +%s`       
${SUBSCRIBE} | while read LINE; do

    LINE_TOPIC=`echo $LINE | sed 's/ .*$//g'`
    LINE_MESSAGE=`echo $LINE | sed 's/^[^ ]* //'`

    [ -z "$VERBOSE" ] || echo "Got MQTT topic=${LINE_TOPIC} message=${LINE_MESSAGE}"

    # Handle each topic in turn
    if [ "$LINE_TOPIC" == "$T1" ]; then 
        if [ -z "$V1" ]; then
            F1_VALUE="$LINE_MESSAGE"
        else
            F1_VALUE=`echo $LINE_MESSAGE | jq ".${V1}"`
        fi
    elif [ "$LINE_TOPIC" == "$T2" ]; then
        if [ -z "$V2" ]; then
            F2_VALUE="$LINE_MESSAGE"
        else
            F2_VALUE=`echo $LINE_MESSAGE | jq ".${V2}"`
        fi
    elif [ "$LINE_TOPIC" == "$T3" ]; then
        if [ -z "$V3" ]; then
            F3_VALUE="$LINE_MESSAGE"
        else
            F3_VALUE=`echo $LINE_MESSAGE | jq ".${V3}"`
        fi
    elif [ "$LINE_TOPIC" == "$T4" ]; then
        if [ -z "$V4" ]; then
            F4_VALUE="$LINE_MESSAGE"
        else
            F4_VALUE=`echo $LINE_MESSAGE | jq ".${V4}"`
        fi
    elif [ "$LINE_TOPIC" == "$T5" ]; then
        if [ -z "$V5" ]; then
            F5_VALUE="$LINE_MESSAGE"
        else
            F5_VALUE=`echo $LINE_MESSAGE | jq ".${V5}"`
        fi
    elif [ "$LINE_TOPIC" == "$T6" ]; then
        if [ -z "$V6" ]; then
            F6_VALUE="$LINE_MESSAGE"
        else
            F6_VALUE=`echo $LINE_MESSAGE | jq ".${V6}"`
        fi
    elif [ "$LINE_TOPIC" == "$T7" ]; then
        if [ -z "$V7" ]; then
            F7_VALUE="$LINE_MESSAGE"
        else
            F7_VALUE=`echo $LINE_MESSAGE | jq ".${V7}"`
        fi
    elif [ "$LINE_TOPIC" == "$T8" ]; then
        if [ -z "$V8" ]; then
            F8_VALUE="$LINE_MESSAGE"
        else
            F8_VALUE=`echo $LINE_MESSAGE | jq ".${V8}"`
        fi
    fi

    PASSED=$[ `date +%s` - $LAST ]
    [ -z $VERBOSE ] || echo "$PASSED seconds since last update"

    if [ $PASSED -ge $INTERVAL ]; then

        URL="${TSURL}/update"
        [ -z "${TSAPIKEY}" ] || URL="${URL}?api_key=${TSAPIKEY}"
        [ -z "${F1_VALUE}" ] || URL="${URL}&field1=${F1_VALUE}"
        [ -z "${F2_VALUE}" ] || URL="${URL}&field2=${F2_VALUE}"
        [ -z "${F3_VALUE}" ] || URL="${URL}&field3=${F3_VALUE}"
        [ -z "${F4_VALUE}" ] || URL="${URL}&field4=${F4_VALUE}"
        [ -z "${F5_VALUE}" ] || URL="${URL}&field5=${F5_VALUE}"
        [ -z "${F6_VALUE}" ] || URL="${URL}&field6=${F6_VALUE}"
        [ -z "${F7_VALUE}" ] || URL="${URL}&field7=${F7_VALUE}"
        [ -z "${F8_VALUE}" ] || URL="${URL}&field8=${F8_VALUE}"

        [ -z $VERBOSE ] || echo "Running: ${URL}"

        curl --silent "${URL}" >/dev/null

        LAST=`date +%s`       

    fi

done

# vim: ts=4 et
