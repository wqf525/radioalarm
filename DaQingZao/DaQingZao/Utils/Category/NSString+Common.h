//
//  NSString+Common.h
//  CiweiProtect
//
//  Created by 吴启飞 on 14/12/23.
//  Copyright (c) 2014年 吴启飞. All rights reserved.
//

#define Regex_Null          @"/s"                       // 空字符
#define Regex_NotNull       @"/S"                       // 非空字符

#define Regex_Sign          @"^\\p{Punct}$"             // 符号字符
#define Regex_AllSign       @"^\\p{Punct}+$"            // 全部符号

#define Regex_Number        @"^\\d{1}$"                 // 数字字符
#define Regex_AllNumber     @"^\\d+$"                   // 全部数字

#define Regex_Char          @"^[A-Za-z]$"               // 字母字符
#define Regex_AllChar       @"^[A-Za-z]+$"              // 全部字母

#define Regex_China         @"^[\\u4E00-\\u9FA5]$"      // 中文字符
#define Regex_AllChina      @"^[\\u4E00-\\u9FA5]+$"     // 全部字符

// 网址地址
#define Regex_Url           @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?"

// 电子邮件
#define Regex_Email         @"^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$"

// 座机号码
#define Regex_Telephone     @"(\\(\\d{3,4}\\)|\\d{3,4}-|\\s)?\\d{6,14}"

#import <Foundation/Foundation.h>

@interface NSString (Common)
+ (NSString *)appPath;		// 程序目录，不能存任何东西
+ (NSString *)docPath;		// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrefPath;	// 配置目录，配置文件存这里
+ (NSString *)libCachePath;	// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;		// 缓存目录，APP退出后，系统可能会删除这里的内容
+(BOOL)touch:(NSString *)path;//创建新文件

//是否是中文
-(BOOL)isChinese;

//是否是合法邮箱
-(BOOL)isValidEmail;

//是否是合法号码
-(BOOL)isValidPhoneNumber;

//是否是合法的18位身份证号码
- (BOOL)isValidPersonID;

//md5 加密
- (NSString *)md5Digest;
//sha1 加密
- (NSString *)sha1Digest;
//是否是网址
- (BOOL)isValidUrl;
- (BOOL)isTelephone;
//- (BOOL)isNullOrEmpty;
+(BOOL)isNullOrEmpty:(NSString *)str;

-(NSString *)base64Digest;

//+(NSString *)makeID2ImageUrl:(NSString *)userId;//[NSString stringWithFormat:@"%@/system/avatar?uid=%@",RequestUrl,self.sceneListEntity.ownerName]

@end
