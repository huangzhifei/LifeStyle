//
//  LSOilPriceSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

/**
 *  油价查询链接！
 *  使用curl方式快速查看
 *  curl  --get --include  'http://apis.baidu.com/showapi_open_bus/oil_price/find?prov=湖北'  -H 'apikey:您自己的apikey'
 */

/**
 * 返回格式
{
    "showapi_res_code": 0,
    "showapi_res_error": "",
    "showapi_res_body": {
        "list": [
                 {
                     "ct": "2016-01-11 04:10:15.050",
                     "p0": "5.15",
                     "p90": "5.19",
                     "p93": "5.5",
                     "p97": "5.95",
                     "prov": "湖北"
                 }
                ],
        "ret_code": 0
    }
}
*/

#import <UIKit/UIKit.h>

@interface LSOilPriceSearchController : UITableViewController

@end
