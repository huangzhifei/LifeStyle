//
//  LSCoachSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  邮编查询链接！
 *  使用curl方式快速查看
 *  curl  --get --include  'http://apis.baidu.com/netpopo/bus/city2c?start=深圳&end=广州'  -H 'apikey:您自己的apikey'
 */

/**
 *  返回格式
{
    "status": "0",
    "msg": "ok",
    "result": [
               {
                   "startcity": "杭州",
                   "endcity": "上海",
                   "startstation": "客运中心站",
                   "endstation": "上海",
                   "starttime": "06:50",
                   "price": "68",
                   "bustype": "大高3",
                   "distance": "181"
               },
               {
                   "startcity": "杭州",
                   "endcity": "上海",
                   "startstation": "客运中心站",
                   "endstation": "上海南站",
                   "starttime": "07:10",
                   "price": "68",
                   "bustype": "大高3",
                   "distance": "181"
               },
               {
                   "startcity": "杭州",
                   "endcity": "上海",
                   "startstation": "杭州南站",
                   "endstation": "上海南站",
                   "starttime": "07:10",
                   "price": "68",
                   "bustype": "大高2",
                   "distance": "181"
               }
               ]
}*/

// 按汽车出发时间来分类，内容实在是太多
// 07:10 深圳 - 广州
@interface LSCoachSearchController : UITableViewController

@end
