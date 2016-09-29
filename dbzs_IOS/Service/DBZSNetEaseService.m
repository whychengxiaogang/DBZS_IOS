//
//  DBZSNetEaseService.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/16.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "DBZSNetEaseService.h"
#import "NSDate+Helper.h"
#import "NSDictionary+JSON.h"
#import "NSString+Additions.h"
#import "NSDictionary+JSON.h"

@implementation DBZSNetEaseService

+ (void)logout
{
    [DBZSUserManager saveCookies:StorageNetEasePre];
    [DBZSUserManager cleanCookies];
    [DBZSUserManager shareInstance].netEaseUser.cashier_token = @"";
    [DBZSUserManager shareInstance].netEaseUser.ou_token = @"";
    [DBZSUserManager shareInstance].netEaseUser.loginSuccess = NO;
    [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseLogoOut userInfo:nil object:nil];
}

+ (void)login
{
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    [self loginWithPass:user.password account:user.accountName];
}

+ (void)loginWithPass:(NSString *)pass account:(NSString *)account
{
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSURL *url = [NSURL URLWithString:@"https://reg.163.com/logins.jsp"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSMutableString *param = [[NSMutableString alloc] init];
    [param appendString:@"isNTES=false&"];
    [param appendString:[NSString stringWithFormat:@"password=%@&",pass]];
    [param appendString:[NSString stringWithFormat:@"username=%@&",account]];
    [param appendString:@"product=mail163&"];
    [param appendString:@"savelogin=0&"];
    [param appendString:[NSString stringWithFormat:@"t=%@&",[NSDate timeString]]];
    [param appendString:@"thirdPartyUrl=[object Object]&"];
    [param appendString:@"url=1.163.com&"];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"reg.163.com" forHTTPHeaderField:@"Host"];
    [request setValue:@"http://1.163.com/" forHTTPHeaderField:@"Referer"];
    [request setValue:@"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPShouldHandleCookies:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseLogoinFai userInfo:nil object:nil];
            return ;
        }
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        NSString *cookiestr = [[HTTPResponse allHeaderFields] valueForKey:@"Set-Cookie"];
        if(!cookiestr || [cookiestr rangeOfString:@"NTES_SESS"].location == NSNotFound){
            [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseLogoinFai userInfo:nil object:nil];
            return;
        }
        user.password = pass;
        user.accountName = account;
        user.loginSuccess = YES;
        [DBZSUserModel setNetEaseStorage:pass key:@"password"];
        [DBZSUserModel setNetEaseStorage:account key:@"accountName"];
        [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseLogoinSuccess userInfo:nil object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getUseInfo];
        });
    }];
    [task resume];
}

+ (void)getUseInfo
{
    [self saveCashAndOToken];
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSURL *url = [NSURL URLWithString:@"http://m.1.163.com/user/index.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param safeSetObject:@"m.1.163.com" forKey:@"Host"];
    [param safeSetObject:@"http://m.1.163.com/" forKey:@"Referer"];
    [param safeSetObject:@"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0" forKey:@"User-Agent"];
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    request.allHTTPHeaderFields = param;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseLogoinFai userInfo:nil object:nil];
            return ;
        }
        NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (htmlStr.length == 0) {
            return;
        }
        NSString *userName = [NSString regularExpressionSearch:htmlStr rangeOfString:@"nickname : '(.*?)'" rangeOfStringSub:@"nickname : '"];
        userName = [userName stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSString *userId = [NSString regularExpressionSearch:htmlStr rangeOfString:@"uid : '(.*?)'" rangeOfStringSub:@"uid : '"];
        userId = [userId stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSString *userWeb = [NSString regularExpressionSearch:htmlStr rangeOfString:@"cid : (.*?)," rangeOfStringSub:@"cid : "];
        userWeb = [userWeb stringByReplacingOccurrencesOfString:@"," withString:@""];
        user.userName = userName;
        user.userId = userId;
        user.userWeb = userWeb;
        [DBZSUserModel setNetEaseStorage:userName key:@"username"];
        [DBZSUserModel setNetEaseStorage:userId key:@"userId"];
        [DBZSUserModel setNetEaseStorage:userWeb key:@"userWeb"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getmoney];
        });
    }];
    [task resume];
}

+ (void)getmoney
{
    [self saveCashAndOToken];
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSString *otoken = @"8acb3065-f83f-4ba9-a767-f188e0ab5d14";
    NSString *urlStr = [NSString stringWithFormat:@"http://1.163.com/cashier/money/query.do?pid=%@&ver=0.0.1&token=%@&t=%@",user.userWeb, otoken, [NSDate timeString]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    request.HTTPMethod = @"GET";
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param safeSetObject:@"1.163.com" forKey:@"Host"];
    [param safeSetObject:[NSString stringWithFormat:@"http://1.163.com/user/index.do?t=%@", [NSDate timeString]] forKey:@"Referer"];
    [param safeSetObject:@"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0" forKey:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.allHTTPHeaderFields = param;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {        if (error) {
        [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseLogoinFai userInfo:nil object:nil];
        return ;
    }
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSDictionary initWithJsonString:dataStr];
        if ([dic safeObjectForKey:@"code"] && [[dic safeObjectForKey:@"code"] intValue] == 0) {
            NSDictionary *result = [dic safeObjectForKey:@"result"];
            user.coinbalance = [[result safeObjectForKey:@"coinbalance"] floatValue];
            user.coinlock = [[result safeObjectForKey:@"coinbalance"] floatValue];
            user.pid = [[result safeObjectForKey:@"pid"] intValue];
            [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseGetMoney userInfo:nil object:nil];
            [self saveCashAndOToken];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"查询帐户余额失败!"];
        }
    }];
    [task resume];
}

+ (void)buy
{
    [self saveCashAndOToken];
    DBZSNowModel *now = [DBZSUserManager shareInstance].currentNow;
    if (!now.time_id || now.time_id.length == 0) {
        [self showOrderErrorMsg:@"下单失败:获取最新期号错误，请稍后再试"];
        return;
    }
    NSString *token_url = [NSString stringWithFormat:@"http://m.1.163.com/cart/index.do?gid=%d&period=%@&num=%d", now.product_id, now.time_id, [DBZSUserManager shareInstance].currentUser.buynum];
    NSURL *url = [NSURL URLWithString:token_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setTimeoutInterval:5];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [param safeSetObject:contentType forKey:@"Content-Type"];
    [param safeSetObject:@"startbuy" forKey:@"tag"];
    [param safeSetObject:@"returnAll" forKey:@"true"];
    request.allHTTPHeaderFields = param;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self showOrderErrorMsg:@"下单失败，稍后再试"];
            return ;
        }
        [self addcart];
    }];
    [task resume];

}

+ (void)addcart
{
    [self saveCashAndOToken];
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSString *url = [NSString stringWithFormat:@"http://m.1.163.com/cart/get.do?t=%@&token=%@", [NSDate timeString], user.ou_token];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    [request setTimeoutInterval:3];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param safeSetObject:@"m.1.163.com" forKey:@"Host"];
    [param safeSetObject:@"http://m.1.163.com/" forKey:@"Referer"];
    [param safeSetObject:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.32 (KHTML, like Gecko) Mobile/14A5261v Html5Plus/1.0" forKey:@"User-Agent"];
    [param safeSetObject:@"gzip, deflate" forKey:@"Accept-Encoding"];
    NSString *contentType = [NSString stringWithFormat:@"gzip, deflate"];
    [param safeSetObject:contentType forKey:@"Content-Type"];
    request.allHTTPHeaderFields = param;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSDictionary initWithJsonString:dataStr];
        if ([dic safeObjectForKey:@"code"] && [[dic safeObjectForKey:@"code"] intValue] == 0) {
            NSArray *result = [dic safeObjectForKey:@"result"];
            NSString *pId = [[result firstObject] safeObjectForKey:@"id"];
            [self submitdo:pId];
        }
    }];
    [task resume];
}

+ (void)submitdo:(NSString *)pId
{
    [self saveCashAndOToken];
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSString *url = [NSString stringWithFormat:@"http://m.1.163.com/cart/submit.do?id=%@&t=%@&token=%@", pId, [NSDate timeString], user.ou_token];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    [request setTimeoutInterval:3];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param safeSetObject:@"m.1.163.com" forKey:@"Host"];
    [param safeSetObject:@"http://m.1.163.com/" forKey:@"Referer"];
    [param safeSetObject:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.32 (KHTML, like Gecko) Mobile/14A5261v Html5Plus/1.0" forKey:@"User-Agent"];
    [param safeSetObject:@"gzip, deflate" forKey:@"Accept-Encoding"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [param safeSetObject:contentType forKey:@"Content-Type"];
    request.allHTTPHeaderFields = param;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSDictionary initWithJsonString:dataStr];
        if ([dic safeObjectForKey:@"code"] &&[[dic safeObjectForKey:@"code"] intValue] == 0) {
            [self confirmOrder];
            return;
        }
        if ([[dic safeObjectForKey:@"code"] intValue] == -251) {
            [self showOrderErrorMsg:@"您没有通过网易实名认证,请电脑上登录并且实名认证之后再来下单"];
            return;
        }
        [self showOrderErrorMsg:@"提交订单失败"];
    }];
    [task resume];
}


+ (void)confirmOrder
{
    [self saveCashAndOToken];
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSString *url = [NSString stringWithFormat:@"http://m.1.163.com/newpay/order/confirm.do?bonusid=&validCode=&validToken=&token=%@&t=%@",user.ou_token,[NSDate timeString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    [request setTimeoutInterval:3];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param safeSetObject:@"m.1.163.com" forKey:@"Host"];
    [param safeSetObject:@"http://m.1.163.com/" forKey:@"Referer"];
    [param safeSetObject:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.32 (KHTML, like Gecko) Mobile/14A5261v Html5Plus/1.0" forKey:@"User-Agent"];
    [param safeSetObject:@"text/xml" forKey:@"Accept-Encoding"];
    request.allHTTPHeaderFields = param;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSDictionary initWithJsonString:dataStr];
        if ([dic safeObjectForKey:@"code"] && [[dic safeObjectForKey:@"code"] intValue] == 0) {
            NSDictionary *result = [dic safeObjectForKey:@"result"];
            [self confirmdo:[result safeObjectForKey:@"url"]];
        }else
        {
            [self showOrderErrorMsg:@"下单失败,保存订单出错！"];
        }
    }];
    [task resume];
}

+ (void)confirmdo:(NSString *)url
{
    [self saveCashAndOToken];
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SAFE_STRING(url)]];
    request.HTTPMethod = @"GET";
    [request setTimeoutInterval:3];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param safeSetObject:@"m.1.163.com" forKey:@"Host"];
    [param safeSetObject:@"http://m.1.163.com/newpay/order/info.do" forKey:@"Referer"];
    [param safeSetObject:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.32 (KHTML, like Gecko) Mobile/14A5261v Html5Plus/1.0" forKey:@"User-Agent"];
    [param safeSetObject:@"text/xml" forKey:@"Accept-Encoding"];
    request.allHTTPHeaderFields = param;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *coin = [NSString regularExpressionSearch:htmlStr rangeOfString:@"coin : (.*?)," rangeOfStringSub:@"coin : "];
        coin = [coin stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSString *cpid = [NSString regularExpressionSearch:htmlStr rangeOfString:@"cpid: '(.*?)'," rangeOfStringSub:@"cpid: "];
        cpid = [cpid stringByReplacingOccurrencesOfString:@"," withString:@""];
        cpid = [cpid stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        NSString *cporderid = [NSString regularExpressionSearch:htmlStr rangeOfString:@"cpOrderId : '(.*?)'," rangeOfStringSub:@"cpOrderId : "];
        cporderid = [cporderid stringByReplacingOccurrencesOfString:@"," withString:@""];
        cporderid = [cporderid stringByReplacingOccurrencesOfString:@"'" withString:@""];

        NSString *money = [NSString regularExpressionSearch:htmlStr rangeOfString:@"money: (.*?)," rangeOfStringSub:@"money: "];
        money = [money stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSString *orderId = [NSString regularExpressionSearch:htmlStr rangeOfString:@"orderId : '(.*?)'," rangeOfStringSub:@"orderId : "];
        orderId = [orderId stringByReplacingOccurrencesOfString:@"," withString:@""];
        orderId = [orderId stringByReplacingOccurrencesOfString:@"'" withString:@""];

        if (user.buynum > [coin intValue]) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"下单失败：余额不足,您当前的可用余额为:%@个夺宝币 ",coin]];
            return;
        }
        NSMutableString * param = [[NSMutableString alloc] init];
        [param appendString:@"apptype=web&"];
        [param appendString:@"bankid=2&"];
        [param appendString:[NSString stringWithFormat:@"coin=%@&",coin]];
        [param appendString:[NSString stringWithFormat:@"cpid=%@&",cpid]];
        [param appendString:[NSString stringWithFormat:@"cporderid=%@&",cporderid]];
        [param appendString:[NSString stringWithFormat:@"money=%@&",money]];
        [param appendString:@"needpayrmb=0&"];
        [param appendString:[NSString stringWithFormat:@"orderid=%@&",orderId]];
        [param appendString:@"paytype=01&"];
        [param appendString:[NSString stringWithFormat:@"t=%@&",[NSDate timeString]]];
        [param appendString:[NSString stringWithFormat:@"token=%@&",user.cashier_token]];
        [param appendString:@"ver=1&"];
        [self payfor:param];
    }];
    [task resume];
}

+ (void)payfor:(NSString *)paramStr
{
    [self saveCashAndOToken];
    NSString *url = @"http://1.163.com/cashier/order/confirm.do";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SAFE_STRING(url)]];
    request.HTTPMethod = @"POST";
    [request setTimeoutInterval:3];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param safeSetObject:@"m.1.163.com" forKey:@"Host"];
    [param safeSetObject:@"http://m.1.163.com/" forKey:@"Referer"];
    [param safeSetObject:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.32 (KHTML, like Gecko) Mobile/14A5261v Html5Plus/1.0" forKey:@"User-Agent"];
    [param safeSetObject:@"application/json" forKey:@"Accept-Encoding"];
    request.allHTTPHeaderFields = param;
    request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSDictionary initWithJsonString:dataStr];
        if ([dic safeObjectForKey:@"code"] && [[dic safeObjectForKey:@"code"] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"下单成功!"];
            [DBZSNotificationHelp postNotification:DBZSNotificationNetEasePaysuccess userInfo:nil object:nil];
            return ;
        }
        [self showOrderErrorMsg:@"下单失败!"];
    }];
    [task resume];
}

+ (void)saveCashAndOToken
{
    DBZSUserModel *user = [DBZSUserManager shareInstance].netEaseUser;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([cookie.name isEqualToString:@"OTOKEN"] && cookie.value.length >0) {
            user.ou_token = cookie.value;
        }
        if ([cookie.name isEqualToString:@"CASHIER_TOKEN"] && cookie.value.length > 0) {
            user.cashier_token = cookie.value;
        }
    }
}

+ (void)showOrderErrorMsg:(NSString *)msg
{
    [SVProgressHUD showErrorWithStatus:msg];
    [DBZSNotificationHelp postNotification:DBZSNotificationNetEaseLogoOut userInfo:nil object:nil];
}

@end
