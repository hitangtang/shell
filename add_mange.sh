#!/usr/bin/env bash

###############################
# 脚本名称 : userManager.sh
# 脚本功能 : 账号管理
# 脚本参数 : 无
# 创建时间 : 2020-05-1
# 版    本 : v1.0
###############################

# 提示信息 []<-()
function menu(){
cat <<EOF
    --------用户管理程序-----------
		1.显示当前所有的用户记录
		2.查询显示特定的用户记录
		3.创建用户
		4.删除用户
		5.批量添加用户
		6.批量删除用户
		7.批量修改用户密码
		8.退出程序
EOF

}
#显示系统所有的用户
function list_users(){
    awk -F: '{print "id "$1}' /etc/passwd | bash
}

#查询特定的用户记录
function query_users(){
    read -p "please input a username:" username
    if id -u $username >/dev/null 2>&1; then
            id  $username
    else
            echo "user $username does not exist"
    fi
}


# 创建账户 []<-(user:string,passwd:string)
function create_user(){
    user="$1"
    pwd="$2"

    useradd "$user" # 添加账户
    if [ $? -ne 0 ];then
        echo "user exist"
        return
    fi
    echo "$pwd" | passwd --stdin "$user" # 设置密码

    if [[ "$?" == 0  ]];
       then
        echo "用户已经创建成功"

    fi
}

# 批量创建账户 user001 user002等
function create_users(){
    user="$1"
    pwd="$2"
    num="$3"
    for ((i=1;i<=$num;i++))
    do
        username=${user}${i}
        useradd "$username" # 添加账户
        if [ $? -ne 0 ];then
            echo "user exist"
        fi
        echo "$pwd" | passwd --stdin "$username" # 设置密码

        if [[ "$?" == 0  ]];
           then
            echo "用户已经创建成功"
        fi
    done

}

# 删除账户 []<-(user:string)
function delete_user(){
    user="$1"
    userdel -r "$user" # 删除用户

    if [[ $?  -eq 0 ]];
       then
        echo "已经删除${user}用户"
    else
            echo "user $username does not exist"
    fi
}

# 批量删除账户 []<-(user:string)
function delete_users(){
    user="$1"
    num="$2"
     for ((i=1;i<=$num;i++))
     do
       username=${user}${i}
       userdel -r "${username}" # 删除用户
        if [[ $?  -eq 0 ]];
           then
            echo "已经删除${username}用户"
        else
                echo "user $username does not exist"
        fi
     done

}

# 批量修改账户密码 user001 user002等
function passwd_users(){
    user="$1"
    pwd="$2"
    num="$3"
    for ((i=1;i<=$num;i++))
    do
        username=${user}${i}
        id "$username" # 查看账户是否存在

        if [ $? -ne 0 ];
        then
            echo "user $username exist"
            return
        fi
        echo "$pwd" | passwd --stdin "$username" # 设置密码

        if [[ "$?" == 0  ]];
           then
            echo "用户$username 密码修改成功"
        fi
    done

}




# 退出脚本 []<-()
function exit_script(){
    read -p "是否退出脚本(yes)" tu

    if [[ "$tu" == "yes" ]];
       then
        exit

    fi
}

# 主函数 []<-()
function main(){
while [ 1 ] ;
do
    menu    # 提示信息

    read -p "请输入操作选择(1-8):" sn

    case "$sn" in
         1)
            list_users
            echo ""
            ;;
         2)
            query_users
            echo ""
            ;;
        3)
            read -p "请输入需要创建的用户名:" uname
            read -p "请给该账户设置一个密码:" passwd
            create_user "$uname" "$passwd"
        ;;
        4)
            read -p "请输入需要删除的用户名:" uname
            delete_user "$uname"
        ;;
        5)
            read -p "请输入需要创建的用户名:" uname
            read -p "请输入创建的个数:" num
            passwd="123456"
           create_users "$uname" "$passwd" "$num"

        ;;
        6)
            read -p "请输入需要删除的用户名:" uname
            read -p "请输入需要删除的个数:" num
            delete_users "$uname" "$num"
        ;;
        7)
             read -p "请输入需要修改的用户名:" uname
            read -p "请给该账户设置一个密码:" passwd
            read -p "请输入修改的个数:" num
            passwd_users $uname $passwd $num
        ;;
        8)
            printf "退出程序\n"
            exit_script
        ;;
    esac
done
}

# 函数运行
main

