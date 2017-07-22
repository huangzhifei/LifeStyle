//
//  LSLimitSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  身份证查询链接！
 *  使用curl方式快速查看
 *  curl  --get --include  'http://apis.baidu.com/netpopo/vehiclelimit/query?city=hangzhou&date=2015-12-17'  -H 'apikey:您自己的apikey'
 */

/**
{
    "status": "0",
    "msg": "ok",
    "result":
    {
        "cityname": "杭州",
        "date": "2015-12-03",
        "week": "星期四",
        "time": [
                 "07:00-09:00",
                 "16:30-18:30"
                 ],
        "area": "1、本市号牌：留祥路—石祥路—石桥路—秋涛路—复兴路—老复兴路—虎跑路—满觉陇路—五老峰隧道—吉庆山隧道—梅灵北路—九里松隧道—灵溪南路—灵溪隧道—西溪路—紫金港路—文一西路—古墩路构成的围合区域内所有道路以及高架(含匝道以及附属桥梁、隧道)。其中留祥路、石祥路、石桥路、秋涛路、复兴路、老复兴路、紫金港路、文一西路和古墩路不含。2、外地号牌：上述“错峰限行”区域以及绕城高速合围区域内的其他高架道路(含匝道以及附属桥梁、隧道)。",
        
        "summary": "本市号牌尾号限行，外地号牌全部限行。法定上班的周六周日不限行。",
        
        "numberrule": "最后一位数字",
        
        "number": "4和6"
    }
}
 
 返回参数信息：
 cityname：城市名称
 date：日期
 week：星期
 time：限行时间
 area：限行区域
 summary：限行摘要
 number：限行尾号
 numberrule：尾号规则
*/

@interface LSLimitSearchController : UITableViewController

@end
