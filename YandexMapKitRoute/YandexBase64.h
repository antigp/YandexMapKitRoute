//
//  YandexBase64.h
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/8/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YandexBase64 : NSObject
+ (NSData *) decode:(NSString*) string;
+ (NSString *) encode:(NSString*) string;
@end

