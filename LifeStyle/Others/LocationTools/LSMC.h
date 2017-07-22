//
//  LSMC.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/27.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#ifndef LSMC_h
#define LSMC_h

typedef struct MC{
    
    double x;
    double y;
}MC;

MC convertLL2MC(double longitude, double latitude);

#endif /* LSMC_h */
