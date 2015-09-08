//
//  DownLoadTask.h
//  DaQingZao
//
//  Created by 吴启飞 on 15/4/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownLoadTask : NSObject
@property (nonatomic,strong,readonly) NSString *url;
-(id)initWithUrl:(NSString *)url;
@property (nonatomic,assign) CGFloat downLoadProgross;
@property (nonatomic,assign) BOOL isCompleted;
@property (nonatomic,strong) NSString *error;
@property (nonatomic,strong) NSString *bytesProgress;
@property (nonatomic,strong) NSString *bytesTotal;

-(void)start;
-(void)stop;

@end
