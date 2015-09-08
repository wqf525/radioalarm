//
//  LocalService+WebService.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/8/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "LocalService+WebService.h"
#import <AFNetworking/AFNetworking.h>

typedef void(^success_call_from_help_handle_method)(id retValue);
@implementation LocalService (WebService)

-(void)getWeather:(success_call_back)success_block fail_block:(fail_call_back)fail_block;
{
    
    if(!self.myCityName)
    {
        NSError *locError = [NSError errorWithDomain:@"未获取到城市信息" code:404 userInfo:nil];
        fail_block(locError);
        return;
    }
    
    NSString *encodeStr = [[[LocalService sharedInstance] myCityName] componentsSeparatedByString:@"市"][0];
    encodeStr = [encodeStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *sendUrl = @"http://apis.baidu.com/apistore/weatherservice/recentweathers";
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?cityname=%@", sendUrl, encodeStr];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"9397e00f173108fc18f6257ddb62d718" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   fail_block(error);
                               } else {
                                   NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                   if([[weatherDic objectForKey:@"errNum"] integerValue] ==0)
                                   {
                                       success_block(weatherDic);
                                   }
                                   else
                                   {
                                       fail_block(nil);
                                   }
                                   
                               }
                           }];
}

#pragma mark --Help post method
-(void)POST:(NSDictionary *)jsonValue to:(NSString *)url withSuccess:(success_call_from_help_handle_method)success_block orFail:(fail_call_back)fail_block;
{
    NSLog(@"post send msg:%@ withUrl:%@",jsonValue,url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:jsonValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get ret msg:%@",responseObject);
        NSDictionary *jsonValue = responseObject;
        if(jsonValue)
        {
            success_block(jsonValue);
//            NSDictionary *dic = [jsonValue objectForKey:@"data"];
//            NSInteger retCode = [[jsonValue objectForKey:@"code"]integerValue];
//            if(retCode != 200)
//            {
//                if(retCode == 402 || retCode == 403)
//                {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//                    return;
//                }
//                NSString * msg = [jsonValue objectForKey:@"message"];
//                if(!msg)
//                {
//                    msg =@"未知错误类型";
//                }
//                NSLog(@"error msg:%@",msg);
//                fail_block([[NSError alloc]initWithDomain:msg code:retCode userInfo:nil]);
//            }
//            else
//            {
//                [ExtraThread enqueueForeground:^{
//                    success_block(dic);
//                }];
//            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        assert(error);
    }];
}

#pragma mark --Help get method
-(void)GET:(NSDictionary *)jsonValue to:(NSString *)url withSuccess:(success_call_from_help_handle_method)success_block orFail:(fail_call_back)fail_block;
{
    NSLog(@"get send msg:%@ withUrl:%@",jsonValue,url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:url parameters:jsonValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get ret msg:%@",responseObject);
        NSDictionary *jsonValue = responseObject;
        if(jsonValue)
        {
            success_block(jsonValue);
//            NSDictionary *dic = [jsonValue objectForKey:@"data"];
//            NSInteger retCode = [[jsonValue objectForKey:@"code"]integerValue];
//            if(retCode != 200)
//            {
//                if(retCode == 402 || retCode == 403)
//                {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//                    return;
//                }
//                NSString * msg = [jsonValue objectForKey:@"message"];
//                if(!msg)
//                {
//                    msg =@"未知错误类型";
//                }
//                NSLog(@"error msg:%@",msg);
//                fail_block([[NSError alloc]initWithDomain:msg code:retCode userInfo:nil]);
//            }
//            else
//            {
//                [ExtraThread enqueueForeground:^{
//                    success_block(dic);
//                }];
//            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        assert(error);
    }];
}

@end
