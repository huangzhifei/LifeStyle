//
//  LSPostCodeSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  邮编查询链接！
 *  使用curl方式快速查看
 *  curl  --get --include  'http://apis.baidu.com/netpopo/zipcode/addr2code?address=地址&areaid=0'  -H 'apikey:你的apikey'
 */

/**
 *  返回格式
 {
	"status":"0",
	"msg":"ok",
	"result":
	[
        {
            "province":"广东省",
            "city":"深圳",
            "town":"",
            "address":"",
            "zipcode":"518000"
        }
	]
    [
        //模糊查询可能会出现多个list，默认取 firtObject
    ]
 } */

// 10次
@interface LSPostCodeSearchController : UITableViewController

@end
