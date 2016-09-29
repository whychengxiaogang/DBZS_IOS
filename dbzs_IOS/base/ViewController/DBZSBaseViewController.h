//
//  DBZSBaseViewController.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBZSBaseViewController : UIViewController

- (void)showBackNav;

- (void)configNavigationBarTitle:(NSString *)aTitle;

- (NSString *)navTitlePre:(NSString *)navTitle;

@end
