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


@implementation YandexMapKitRoute
@synthesize YMKMapViewInternal,YXScrollView;
+ (void) getRouteStringFrom:(YMKMapCoordinate)from To:(YMKMapCoordinate)to{
    //NSURL * yandexUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.yandex.ru/actions/get-route/?lang=ru-RU&origin=maps&simplify=1&rll=%f,%f~%f,%f"]];
}
+ (YandexMapKitRoute *) showRouteOnMap:(YMKMapView *)mapView From:(YMKMapCoordinate) coordinateFrom To: (YMKMapCoordinate) coordinateTo{
    NSArray * geoPointArray = [YandexMapKitRoute parseData:[YandexBase64 decode:@"khM8Aq4ZVAOtAwAABvv__wAAAAAAAAAAyPD__0j8__-1____s____9P___-n_f__y____4D___8AAAAAAAAAACf8__8g____UP___6f____f____ov____H___8v_v__AAAAAAAAAAD0-P__FQAAAMz2___4____pv___xoAAACL-____P___1T9__8SAAAAAAAAAAAAAADZ_v__CAAAAAAAAAAAAAAABQkAADH0__-3AgAAI_3__60CAADi_f__AAAAAAAAAADXBgAAZff___kOAAC67f__VA0AAPbv__-zEAAAZ-v__woRAABP6___rg0AAADv__-YBAAAcvr__8UAAAA0____uwEAAJv-___mAQAAyv7__wAAAAAAAAAAvgEAAAH___9mAgAA__7__8MBAAB3____NwUAALf-___xCAAApf3__wAAAAAAAAAASgkAAIX9__9ICwAAU_z__2oZAACy-f__HwEAAOf___-HAAAAGgAAAAAAAAAAAAAA0BEAAHP7___XBAAAgf7__5MFAADP_f__AAAAAAAAAAABAAAAuP___08AAACi____UAMAAGn-__-BAAAArP___yEAAACz____AAAAAAAAAAAtBQAA0_3__3YoAADc7f__cw0AACv6__9UHQAA3vL__4ARAAB5-P__5gkAAHf7___wBAAAzf3__wAAAAAAAAAA-v___6H-__-z____TP___7n___--____hvj__5H6__9p_v__kf7__-D____P____7f___x7____y8___XPf__577__-c_P__Gf3__7X8___A-f__nff__zP9___R_P__Hfz__wz8__-r_v__Nf___zj9__-a_v__B____5z___9K_P___f7__yPv__8H_v__AP3__0f___9U-___JP7__0z___-d____Rf3__wL-__97_f__kf3__3T7___G-___ef7__5_-___a_f__pP7__4D7__-p_f__PP3__1b-__85_P__Hf3__9L8___o_P__z_7__w7-__9R-v__HvT__3n-__9h_P__XP3__-H5__9K-v__gfH__y36__879P__8v3__1v7__-w_v__zPv___P___8T_f__UQAAAJz9__-mAAAABv7__1kAAAAk____RwEAAEf9__-WAAAATf7__0wAAADl_v__vAEAAH34__9nAwAASPP__wAAAAAAAAAA2f___5j___9qAAAA6vz__54AAAC4_P__tQAAAFD-___n____pf___0UAAABQ____5f___x____94____Mf___4X9__9L_f__s_7__xv___8G_v__2P7__5T8__8t____bOn__-X6__-s9v__Ef7__xDp__-2-___8-b__437__-Gx___o_X__83o___R-___-eP__876__8AAAAAAAAAABX-__9PAAAAH____0gAAAA7____XwAAALP___8zAQAAEAAAAKMAAAAfAAAARQAAAJEAAACLAAAAUQEAAKQAAACMFwAACAQAAPgBAADI____ogAAANn___96AAAAzf___wAAAAAAAAAAkQQAAND6__8JCAAAQvf__wAAAAAAAAAAhf___2j___9d____3P___-L-__9BAAAA4vj___YHAAAAAAAAAAAAAKT6__8y____AAAAAAAAAAAqAwAAkfz__5gMAADB8v__sAIAAI39__8AAAAAAAAAAOv___85____Yur__8T1__9O_v__c____5b1__8h_v__ff7__7f___8k____rv___3z___-f____7_7__23-__9o-v__c_b__3b-__8Z_f__0Pz__7T6___-_v__zP7__4r-__-z_v__Tv___3r___-h-f__wvv__wL-__8v_v__P_3__9v9___e_f__DP7__-f-___f____6fn__w0AAADU-___0____wAAAAAAAAAAAwAAAOH-__-1____Vv7__-7-___G_f__W____wD___-0_v__dP7__7v9__90_f__AAAAAAAAAAAMEwAArfr__wAAAAAAAAAAH_v__1v6__8AAAAAAAAAAOEGAAAQ_v__"]];

    YandexMapKitRoute* returnRoute=[[YandexMapKitRoute alloc] init];
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
    
    return returnRoute;
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
    NSLog(@"%f,%f",(maxY-minY)/2+minY,(maxX-minX)/2+minX);
    return YMKMapCoordinateMake((maxY-minY)/15+minY,(maxX-minX)/3.3+minX);
}
@end
