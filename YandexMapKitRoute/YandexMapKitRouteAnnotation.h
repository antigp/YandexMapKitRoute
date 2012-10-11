//
//  YandexMapKitRouteAnnotation.h
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/10/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YandexMapKit.h"
#import "YandexMapKitRouteAnnotationView.h"
@interface YandexMapKitRouteAnnotation : NSObject<YMKAnnotation>

@property (nonatomic, assign) YMKMapCoordinate coordinate;
@property (nonatomic) NSArray * routeArray;
@property (nonatomic) YandexMapKitRouteAnnotationView * view;
@end
