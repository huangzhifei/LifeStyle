//
//  LSSettingsViewController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/14.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSSettingsViewController.h"
#import "RETableViewManager.h"
#import "MBProgressHUD+MJ.h"
#import "GCDTimer.h"
#import "LSAboutViewController.h"
#import <MessageUI/MessageUI.h>
#import "LSWebViewController.h"

@interface LSSettingsViewController()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) RETableViewManager *tableViewManager;

@end

@implementation LSSettingsViewController

#pragma mark - init
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if( self )
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableViewManager = ({
        
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
        manager.style.cellHeight = 44;
        
        manager;
    });
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kCollectionHeaderColor;

    [self addTopImageSection];
    [self addUpdateSection];
    [self addSystemSection];
    [self addFeedbackSection];
    [self addAboutSection];
}

- (void)addTopImageSection
{
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, kScreenWidth, 90);
    topView.backgroundColor = [UIColor clearColor];
    
    UIImageView *photo = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting-image"]];
        imageView.frame = CGRectMake(0, 20, self.view.frame.size.width, 64);
        imageView.contentMode = UIViewContentModeCenter;
        imageView;
    });
    
    [topView addSubview:photo];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"版本:V1.0";
    [versionLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [versionLabel setTextColor:[UIColor darkGrayColor]];
    [versionLabel sizeToFit];
    versionLabel.frame = CGRectMake( (kScreenWidth - versionLabel.bounds.size.width)/2, 86,
                                    versionLabel.bounds.size.width, versionLabel.bounds.size.height);
    [topView addSubview:versionLabel];
    
    RETableViewSection *topSection = ({
        
        RETableViewSection *section = [RETableViewSection sectionWithHeaderView:topView];
        
        section;
    });
    
    [self.tableViewManager addSection:topSection];
}

- (void)addUpdateSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.tableViewManager addSection:section];
    
    section.headerTitle = @"检查更新";
    section.headerHeight = 40;
    section.footerHeight = 1;
    
    weakify(self)
    RETableViewItem *item = [RETableViewItem itemWithTitle:@"检查更新"
                                             accessoryType:UITableViewCellAccessoryNone
                                          selectionHandler:^(RETableViewItem *item) {
                                              
                                              strongify(self)
                                              
                                              MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                              HUD.mode = MBProgressHUDModeIndeterminate;
                                              HUD.labelText = @"检查更新中...";
                                              
                                              [GCDTimer scheduledTimerWithTimeInterval:1.5f repeats:NO block:^{
                                                  
                                                   HUD.mode = MBProgressHUDModeText;
                                                   HUD.labelText = @"没有更新！";
                                                  
                                                  [GCDTimer scheduledTimerWithTimeInterval:0.2f repeats:NO block:^{
                                                      
                                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  }];
                                              }];
        
    }];
    item.image = [UIImage imageNamed:@"set_icon_download"];
    //item.image = [UIImage imageNamed:@"set_icon_download"];
    [section addItem:item];
}

- (void)addSystemSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.tableViewManager addSection:section];
    
    section.headerTitle = @"系统设置";
    section.headerHeight = 40;
    section.footerHeight = 1;
    
    weakify(self)
    RETableViewItem *cleanItem = [RETableViewItem itemWithTitle:@"清除缓存"
                                                  accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                               selectionHandler:^(RETableViewItem *item) {
                                                   
                                                   strongify(self)
                                                   
                                                   MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   HUD.mode = MBProgressHUDModeIndeterminate;
                                                   HUD.labelText = @"正在清除中...";
                                                   
                                                   [GCDTimer scheduledTimerWithTimeInterval:1.2f repeats:NO block:^{
                                                       
                                                       NSString *cachPath = kPath_Of_Document;
                                                       
                                                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                                                       NSUInteger fileCount = [files count];
                                                       //NSLog(@"files :%ld",[files count]);
                                                       for (NSString *p in files)
                                                       {
                                                           NSError *error;
                                                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                                                           if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                                                           {
                                                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                                                           }
                                                       }
                                                       
                                                       HUD.mode = MBProgressHUDModeText;
                                                       HUD.labelText = [NSString stringWithFormat:@"清除缓存文件%ld个!",(unsigned long)fileCount];
                                                       
                                                       [GCDTimer scheduledTimerWithTimeInterval:0.3f repeats:NO block:^{
                                                           
                                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                       }];
                                                       
                                                   }];
                                               }];

    
    cleanItem.image = [UIImage imageNamed:@"set_icon_clear"];
                        
    [section addItem:cleanItem];
    
    BOOL showFlag = [[NSUserDefaults standardUserDefaults] boolForKey:@"WIFIKey"];
    REBoolItem *locationItem = [REBoolItem itemWithTitle:@"仅在wifi下显示图片" value:showFlag
                            switchValueChangeHandler:^(REBoolItem *item) {
                                
                                // 处理保存
                                NSLog(@"BOOL %d",item.value);
                                [[NSUserDefaults standardUserDefaults] setBool:item.value forKey:@"WIFIKey"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                            }];
    
    locationItem.image = [UIImage imageNamed:@"set_icon_wifi"];
    [section addItem:locationItem];
}

- (void)addFeedbackSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.tableViewManager addSection:section];
    
    section.headerTitle = @"反馈与建议";
    section.headerHeight = 40;
    section.footerHeight = 1;
    
    weakify(self)
    
    RETableViewItem *scoreItem = [RETableViewItem itemWithTitle:@"评价打分" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        // 跳转到 app store
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://"]];
    }];
    
    scoreItem.image = [UIImage imageNamed:@"set_icon_star"];
    [section addItem:scoreItem];
    
    // 建议
    RETableViewItem *suggestItem = [RETableViewItem itemWithTitle:@"问题与建议" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        strongify(self)
        [self sendEmail];
        
    }];
    
    suggestItem.image = [UIImage imageNamed:@"set_icon_mailbox"];
    [section addItem:suggestItem];
}

- (void)addAboutSection
{
    RETableViewSection *section = [RETableViewSection section];
    [self.tableViewManager addSection:section];
    
    section.headerTitle = @"关于";
    section.headerHeight = 40;
    section.footerHeight = 20;
    
    weakify(self)
    
    RETableViewItem *scoreItem = [RETableViewItem itemWithTitle:@"关注微博" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        // 跳转到 sina
        [self.navigationController pushViewController:[[LSWebViewController alloc] initWithUrl:@"http://weibo.com/chongzizizizizizi" ] animated:YES];
    }];
    
    scoreItem.image = [UIImage imageNamed:@"set_icon_sina"];
    [section addItem:scoreItem];
    
    RETableViewItem *suggestItem = [RETableViewItem itemWithTitle:@"关于我" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        
        strongify(self)
        
        [self.navigationController pushViewController:[LSAboutViewController loadDIY] animated:YES];
        
    }];
    
    suggestItem.image = [UIImage imageNamed:@"set_icon_about"];
    [section addItem:suggestItem];
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)sendEmail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"意见反馈"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"513115854@qq.com"];

    [mailPicker setToRecipients: toRecipients];
    
    NSString *emailBody = @"\n\n ～来自我的iPhone";
    
    [mailPicker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:mailPicker animated:YES completion:nil];
}

// 转到系统邮件
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
   
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

// 邮件发送返回
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            //[self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            //[self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            //[self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [MBProgressHUD showSuccess:msg];
        
    }];
}

@end
