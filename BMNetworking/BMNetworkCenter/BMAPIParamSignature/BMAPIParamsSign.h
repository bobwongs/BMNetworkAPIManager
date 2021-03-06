//
//  BMAPIParamsSign.h
//  BMNetworking
//
//  Created by fenglh on 2017/2/14.
//  Copyright © 2017年 BlueMoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMEnumType.h"

@interface BMAPIParamsSign : NSObject

/**
 * 生成已签名的url查询字符串，业务参数参与签名
 * 此签名算法默认为至尊洗衣的签名（当type==BMAPIManagerRequestTypePostMimeType时，参数param不加入签名）
 *
 */
+ (NSString *)generateSignaturedUrlQueryStringWithParam:(NSDictionary *)param requestType:(BMAPIManagerRequestType)type;

@end
