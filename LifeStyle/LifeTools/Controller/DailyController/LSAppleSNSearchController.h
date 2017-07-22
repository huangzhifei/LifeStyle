//
//  LSAppleSNSearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/8.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  查询链接！
 *  使用curl方式快速查看
 *  curl  --get --include  'http://apis.baidu.com/3023/apple/apple?sn=C39PPPT5G5QY'  -H 'apikey:您自己的apikey'
 */

/**
 *  返回格式
 *  {
	"model": "iPhone 6 Plus",  //设备型号
    "capacity":"64GB",          // 容量
    "color":"金色",           // 颜色
	"activated": "1",         //激活状态，0未激活，1已激活
	"time": "2015-06-29",  //激活时间
	"start": "2015-05-21",
	"end": "2015-05-27",  //出厂日期start ~ end
	"warranty": "2016-06-28",  //硬件保修服务到期时间，若为0则已过期
	"daysleft": "182",  //硬件保修剩余（天）
	"tele": "0",  //电话支持服务到期时间，若为0则已过期
	"product": "iPhone",  //产品类型
	"purchasing": "1",  //有效购买时间，0不是，1是
	"origin": "中国",  //产地
	"locked": "0",  //激活锁状态，0关闭，1锁定
 }
 */
@interface LSAppleSNSearchController : UITableViewController

@end
