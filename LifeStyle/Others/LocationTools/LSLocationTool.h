//
//  LSLocationTool.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/13.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LSLocationInfo.h"

@protocol LSLocationToolDelegate <NSObject>

- (void)stopLocation:(LSLocationInfo *)locaInfo;

@end

@interface LSLocationTool : NSObject

@property (weak, nonatomic)id<LSLocationToolDelegate>delegate;

- (void)startLocation;


@end
