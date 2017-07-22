//
//  LSIDCardSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  身份证查询链接！
 *  使用curl方式快速查看
 *  curl  --get --include  'http://apis.baidu.com/apistore/idservice/id?id=身份证号'  -H 'apikey:你的apikey'
 */

/**
 *  返回格式
 {
    "errNum":0,
    "retMsg":"success",
    "retData":
    {
        "address":"湖北省省直辖县级行政区划天门市",   //身份证归属地、市/县
        "sex":"M",                               //性别
        "birthday":"1990-02-01"                  //出身日期
    }
 }
 */

@interface LSIDCardSearchController : UITableViewController

@end
