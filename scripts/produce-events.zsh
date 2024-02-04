#!/bin/zsh

MYDIR="$(dirname "$(readlink -f "$0")")"

source $MYDIR/variables.zsh


#aws lambda list-functions
#aws lambda get-function — function-name my-function

#aws lambda invoke --function-name $LAMBDA --cli-binary-format raw-in-base64-out --payload file://event.json response.json
aws lambda invoke --function-name $LAMBDA response.json