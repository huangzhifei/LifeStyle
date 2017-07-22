//
//  LSTelephoneSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  身份证查询链接！
 *  使用curl方式快速查看
 *  curl  --get --include  'http://apis.baidu.com/apistore/mobilenumber/mobilenumber?phone=15210011578'  -H 'apikey:您自己的apikey'
 */

/**
 *  返回格式
 
 {
    "errNum": 0,
    "retMsg": "success",
    "retData":
    {
        "phone": "15210011578",
        "prefix": "1521001",
        "supplier": "移动 ",
        "province": "北京 ",
        "city": "北京 ",
        "suit": "152卡"
    }
 }
 
 备注 :
 "phone": 手机号码,
 "prefix": 手机号码前7位,
 "supplier": "移动 ",
 "province": 省份,
 "city": 城市,
 "suit": "152卡"
 */

@interface LSTelephoneSearchController : UITableViewController

@end
