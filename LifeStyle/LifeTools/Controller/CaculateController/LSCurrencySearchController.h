//
//  LSCurrencySearchController.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/12.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
{
errNum: 0,
errMsg: "成功",
retData:
    {
    date: "2015-08-12",  //日期
    time: "07:10:46",    //时间
    fromCurrency: "CNY", //待转化币种的简称，这里为人民币
    amount: 2,    //转化的金额
    toCurrency: "USD",  //转化后的币种的简称，这里为美元
    currency: 0.1628,   //当前汇率
    convertedamount: 0.3256  //转化后的金额
    }
}
 */

@interface LSCurrencySearchController : UITableViewController

@end
