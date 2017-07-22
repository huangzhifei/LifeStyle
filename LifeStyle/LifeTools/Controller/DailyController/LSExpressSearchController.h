//
//  LSExpressSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  快递查询接口:
 *  curl  --get --include  'http://apis.baidu.com/netpopo/express/express1?type=SFEXPRESS&number=ss1658943036'  -H 'apikey:xxxx'
 */

/**
 *  返回接口
 *  
    {
        "status": "0", // 205 & 0
        "msg": "ok",
        "result": {
        "list": [
        {
            "time": "2015-10-20 10:24:04",
            "status": "顺丰速运 已收取快件"
        },
        {
            "time": "2015-10-20 11:49:26",
            "status": "快件离开【广州龙怡服务点】,正发往 【广州番禺集散中心】"
        }
        {
            "time": "2015-10-21 09:22:10",
            "status": "已签收,感谢使用顺丰,期待再次为您服务"
        },
        {
            "time": "2015-10-21 09:22:10",
            "status": "在官网\"运单资料&签收图\",可查看签收人信息"
        }
        ],
        "issign": "1" // 表示签收
    }
 } */

// 只缓存 top 4  快递单号&快递公司 自动填充
@interface LSExpressSearchController : UITableViewController

@end
