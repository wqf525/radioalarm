//
//  LocalService+WebService.h
//  DaQingZao
//
//  Created by 吴启飞 on 15/8/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "LocalService.h"
typedef void(^success_call_back)(id retValue);
typedef void(^fail_call_back)(NSError *error);

@interface LocalService (WebService)
-(void)getWeather:(success_call_back)success_block fail_block:(fail_call_back)fail_block;
@end
