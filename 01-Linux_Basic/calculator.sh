#!/bin/bash

read -p "请输入第一个数字" num1
read -p "请输入第二个数字" num2
read -n 1 -p "请输入运算符(+-*/)" operator
echo

if [ -n "$num1" ] && [ -n "$num2" ]
then
	if [ "$operator" = "+" ]
	then
		echo "sum=$((num1+num2))"
	elif [ "$operator" = "-" ]
	then
	       	echo "sum=$((num1-num2))"
        elif [ "$operator" = "*" ]
	then
	       	echo "sum=$((num1*num2))"
	elif [ "$operator" = "/" ]
	then	
		if [ "$num2" -eq 0 ]
		then
			echo "除数不能为0"
		else
			echo "sum=$((num1/num2))"
		fi
	else
		echo "请输入正确运算符"
	fi
else
	echo "请输入数字"
fi
