//
//  YandexMapKitRoute.m
//  YandexMapKitRoute
//
//  Created by Eugen Antropov on 10/8/12.
//  Copyright (c) 2012 Eugen Antropov. All rights reserved.
//

#import "YandexMapKitRoute.h"
#import "YandexBase64.h"
#import <objc/runtime.h>
#import "YandexMapKitRouteDelegate.h"
#import "YandexMapKitRouteAnnotation.h"
#include "SBJson.h"


@implementation YandexMapKitRoute
@synthesize YMKMapViewInternal,YXScrollView;
+ (NSString *) getRouteStringFrom:(YMKMapCoordinate)from To:(YMKMapCoordinate)to{
   NSString * returnString;
   NSURL * yandexUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.yandex.ru/actions/get-route/?lang=ru-RU&origin=maps&simplify=1&rll=%f,%f~%f,%f&rtm=atm",from.longitude,from.latitude,to.longitude,to.latitude]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:yandexUrl];
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    if(result!=nil){
        //SBJson reolization
        NSDictionary * returnDict=[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] JSONValue];
        returnString=[[[returnDict valueForKey:@"stages"] valueForKey:@"encodedPoints"] objectAtIndex:0];
        //\SBJson reolization
    }
    return returnString;
}
+ (YandexMapKitRoute *) showRouteOnMap:(YMKMapView *)mapView From:(YMKMapCoordinate) coordinateFrom To: (YMKMapCoordinate) coordinateTo{
    YandexMapKitRoute* returnRoute;
    @try {
        NSString * routeString=[YandexMapKitRoute getRouteStringFrom:coordinateFrom To:coordinateTo];
        if(routeString==nil)
            return nil;
        NSArray * geoPointArray = [YandexMapKitRoute parseData:[YandexBase64 decode:routeString]];
        
        returnRoute=[[YandexMapKitRoute alloc] init];
        returnRoute.YMKMapViewInternal = mapView;
        YandexMapKitRouteDelegate * delegate=[[YandexMapKitRouteDelegate alloc] init];
        returnRoute.delegate= delegate;
        if(mapView.delegate!=nil)
            delegate.oldDelegate=mapView.delegate;
        delegate.mapView=mapView;
        mapView.delegate=nil;
        mapView.delegate=delegate;
        
        
        returnRoute.YXScrollView = (UIScrollView<UIScrollViewDelegate> *) [mapView.subviews objectAtIndex:1];
        returnRoute.YMMapOverlayView=[returnRoute.YXScrollView.subviews objectAtIndex:1];
        
        returnRoute.annotation=[[YandexMapKitRouteAnnotation alloc] init];
        
        returnRoute.annotation.coordinate=[returnRoute calcMediumCoordinateOfArray:geoPointArray];
        returnRoute.annotation.routeArray=geoPointArray;
        delegate.anotation=returnRoute.annotation;
        [mapView addAnnotation:returnRoute.annotation];
    }
    @catch (NSException *exception) {
        NSLog(@"Can't show route");
    }
    @finally {
        return returnRoute;
    }
}
- (BOOL)respondsToSelector:(SEL)aSelector{
    NSLog(@"selector %@",NSStringFromSelector(aSelector));
    return [super respondsToSelector:(SEL)aSelector];
}

+ (NSArray *) parseData:(NSData *) globalData{
    int lastx=0;
    int lasty=0;
    NSMutableArray * mutablePoints=[[NSMutableArray alloc] init];
    for(int i=0; i<[globalData length]/8;i++){
        NSData *data = [globalData subdataWithRange:NSMakeRange((i*8), 4)];
        int value = *(int*)([data bytes]);
        NSData *data2 = [globalData subdataWithRange:NSMakeRange(i*8+4,4)];
        int value2 = *(int*)([data2 bytes]);
        [mutablePoints addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:(value+lastx)/1000000.0f],@"X",[NSNumber numberWithFloat:(value2+lasty)/1000000.0f],@"Y", nil]];
        lastx+=value;
        lasty+=value2;
    }
    return mutablePoints;
}
- (YMKMapCoordinate) calcMediumCoordinateOfArray:(NSArray*) routeArray{
    float minX=MAXFLOAT;
    float minY=MAXFLOAT;
    float maxX=0;
    float maxY=0;
    
    for (NSDictionary * position in routeArray) {
        if([[position objectForKey:@"X"] floatValue]>maxX)
            maxX=[[position objectForKey:@"X"] floatValue];
        if([[position objectForKey:@"Y"] floatValue]>maxY)
            maxY=[[position objectForKey:@"Y"] floatValue];
        if([[position objectForKey:@"X"] floatValue]<minX)
            minX=[[position objectForKey:@"X"] floatValue];
        if([[position objectForKey:@"Y"] floatValue]<minY)
            minY=[[position objectForKey:@"Y"] floatValue];
    }
    //Why this? don't know, but work =)
    return YMKMapCoordinateMake((maxY-minY)/2+minY,(maxX-minX)/2+minX);
}
@end
