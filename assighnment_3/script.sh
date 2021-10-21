#!/bin/bash
element={"a":{"b":{"c":{"d":{"e":{"f":"g"}}}}}}

keyval()
{
key=$1
val=`echo ${element} |cut -d${key} -f2`
subst=${val:0:2}
if [ "${subst}" == ':{' ]
then
strg=`echo ${element} |cut -d${key} -f2 |cut -c3-`
cnt=`echo $strg |grep -o '{'|wc -l`
nstrg=`echo $strg |cut -d'}' -f1`
storerep=`repstr=$(printf "%${cnt}s");echo ${repstr// /'}'}`
fnlval=`echo ${nstrg}${storerep}`
echo "value for key ${key} is ${fnlval}"
else
fnlval=${subst:1:1}
echo "value for key ${key} is ${fnlval}"
fi
}

keyval a
