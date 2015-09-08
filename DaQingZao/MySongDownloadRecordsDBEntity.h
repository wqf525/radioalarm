//
//  MySongDownloadRecordsDBEntity.h
//  DaQingZao
//
//  Created by 吴启飞 on 15/8/3.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MySongDownloadRecordsDBEntity : NSManagedObject

@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSNumber * sceneId;
@property (nonatomic, retain) NSString * songUrl;

@end
