#!/bin/bash

path=$1
target_lib=""
current_lib=""

first_find=true

lib_arr=()
target_lib_arr=()

# 找文件
find_libs()
{
    for lib in `ls ${path} | grep "so"`
    do 
        lib_arr[${#lib_arr[@]}]=${lib}
    done
}

# 找到目标库
find_target_libs()
{
    for lib in ${lib_arr[@]}
    do
        # 标记current_lib
        current_lib=${lib}
        # 首次查找
        if [[ ${first_find} == true ]]; then
            target_lib=${current_lib}
            first_find=false
        fi

        # 如果current不包含target，则说明已经跳到下一个库
        if [[ ${current_lib} =~ ${target_lib} ]]; then
            index=`expr ${#lib_arr[@]} - 1`
            if [[ ${current_lib} == ${lib_arr[index]} ]]; then
            # 此时是有效最长链接
                target_lib=${current_lib}
                target_lib_arr+=(${target_lib})
            fi
        else
        # 此时target_lib是最长链接版本，加入target_lib_arr
            target_lib_arr+=(${target_lib})
        fi

        # 更新target_lib
        target_lib=${current_lib}
    done

    echo ${target_lib_arr[@]}
}

# 链接目标库
link_target_libs()
{
    for lib in ${lib_arr[@]}
    do
        for t_lib in ${target_lib_arr[@]} :
        do
            # t_lib应包含lib，但不应该等于lib
            if [[ ${t_lib} =~ ${lib} ]] && [[ ${t_lib} != ${lib} ]]; then
                # echo ${lib}
                # 重新链接
                `ln -sf ${t_lib} ${path}/${lib}`
            fi
        done
    done
}

find_libs
find_target_libs
link_target_libs