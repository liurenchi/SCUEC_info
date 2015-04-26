//
//  libraryData.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/4/22.
//  Copyright (c) 2015年  Lrcray. All rights reserved.



/*———————————————————————————————————————
lib的一个通用的方法定义
-string类的一个拓展
———————————————————————————————————————*/

import Foundation

//扩展string类
extension String {
    //添加了string的长度
    // readonly computed property
    var length: Int {
        return count(self)
    }
    
    
}
//判断string是不是全为数字
func isPureNumandCharacters(var string:String) -> Bool
{
    //先去除""字符串的可能
    //把字符的数字去除然后判断string的长度
    if string != ""{
        string = string.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
        if(string.length > 0)
        {
            return false
        }else{
            return true
        }
    }else{
        return false
    }
}

