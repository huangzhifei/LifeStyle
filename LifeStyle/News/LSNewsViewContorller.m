//
//  LSNewsContorller.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/13.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSNewsViewContorller.h"
#import "REMenu.h"
#import "LSWebViewController.h"

@interface LSNewsViewContorller()

@property (strong, nonatomic) REMenu *menu;

@end

@implementation LSNewsViewContorller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kCollectionHeaderColor;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImage *imageMenu = [UIImage imageNamed:@"icon_menu"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageMenu style:UIBarButtonItemStyleDone target:self action:@selector(openMenu)];
    
    [self setUpMenu];
}


- (void)setUpMenu
{
   
    weakify(self)
    
    REMenuItem *fhItem = [[REMenuItem alloc] initWithTitle:@"凤凰资讯"
                                                    subtitle:@"24小时提供最客观的新闻资讯"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          
                                                          strongify(self)
                                                          
                                                          [self loadWebViewVC:FHNewUrl];
                                                          
                                                      }];
    
    REMenuItem *sinaItem = [[REMenuItem alloc] initWithTitle:@"新浪新闻"
                                                    subtitle:@"最新，最快头条新闻一网打尽"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          
                                                          strongify(self)
                                                          
                                                          [self loadWebViewVC:SNNewUrl];
                                                          
                                                      }];
    REMenuItem *txItem = [[REMenuItem alloc] initWithTitle:@"腾讯新闻"
                                                      subtitle:@"浏览最大的中文门户网站"
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            
                                                            strongify(self)
                                                            [self loadWebViewVC:TXNewUrl];
                                                            
                                                        }];
    
    REMenuItem *wyItem = [[REMenuItem alloc] initWithTitle:@"网易新闻"
                                                      subtitle:@"快速，评论犀利而备受推崇"
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            
                                                            strongify(self)
                                                            [self loadWebViewVC:WYNewUrl];
                                                            
                                                        }];
    
    REMenuItem *sohuItem = [[REMenuItem alloc] initWithTitle:@"搜狐新闻"
                                                      subtitle:@"提供24小时不间断的最新资讯"
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            
                                                            strongify(self)
                                                            [self loadWebViewVC:SHNewUrl];
                                                            
                                                        }];
    
        REMenuItem *HaoItem = [[REMenuItem alloc] initWithTitle:@"hao123头条"
                                                         subtitle:@"全球最不正经的资讯网站"
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
    
                                                               strongify(self)
    
                                                               [self loadWebViewVC:H123Url];
    
                                                           }];
    
    REMenuItem *PeopleItem = [[REMenuItem alloc] initWithTitle:@"人民网"
                                                   subtitle:@"世界十大报纸之一《人民日报》的新闻平台"
                                                      image:nil
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         
                                                         strongify(self)
                                                         
                                                         [self loadWebViewVC:PeopleUrl];
                                                         
                                                     }];
    
    self.menu = [[REMenu alloc] initWithItems:@[fhItem, sinaItem, txItem, wyItem, sohuItem, HaoItem, PeopleItem]];
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    self.menu.textColor = [UIColor whiteColor];
    self.menu.subtitleTextColor = [UIColor whiteColor];
    
    [self.menu showInView:self.view];

}

- (void)loadWebViewVC:(NSString *)urlString
{
    LSWebViewController *newCtrl = [[LSWebViewController alloc] initWithUrl:urlString];
    
    [self.navigationController pushViewController:newCtrl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self openMenu];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self.menu isOpen])
    {
        [self.menu close];
    }
}

- (void)openMenu
{
    if( ![self.menu isOpen] )
    {
        [self.menu showInView:self.view];
    }
}

@end
