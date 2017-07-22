//
//  LSIPSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  链接：
    curl --get --include 'http://apis.baidu.com/apistore/iplookupservice/iplookup?ip=117.89.35.58' -H 'apikey:你的apikey'

 */

/**
 *  
 {
    "errNum": 0,
    "errMsg": "success",
    "retData": 
    {
        "ip": "117.89.35.58", //IP地址
        "country": "中国", //国家
        "province": "江苏", //省份 国外的默认值为none
        "city": "南京", //城市  国外的默认值为none
        "district": "鼓楼",// 地区 国外的默认值为none
        "carrier": "中国电信" //运营商  特殊IP显示为未知
    }
 }
 */

@interface LSIPSearchController : UITableViewController

@end
