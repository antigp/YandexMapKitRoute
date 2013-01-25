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
#include "SBJson.h"


@implementation YandexMapKitRoute
@synthesize YMKMapViewInternal,YXScrollView,delegate;

+ (NSString *) getRouteStringFrom:(YMKMapCoordinate)from To:(YMKMapCoordinate)to{
   NSString * returnString;
    //Address to request route
   NSURL * yandexUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.yandex.ru/actions/get-route/?lang=ru-RU&origin=maps&simplify=1&rll=%f,%f~%f,%f&rtm=atm",from.longitude,from.latitude,to.longitude,to.latitude]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:yandexUrl];
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    if(result!=nil){
        //NSJSONSerialization reolization
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
        returnString=[[[json valueForKey:@"stages"] valueForKey:@"encodedPoints"] objectAtIndex:0];
        //\NSJSONSerialization reolization
        
        //USE this for ios < 5 support
            //SBJson reolization
            //NSDictionary * returnDict=[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] JSONValue];
            //returnString=[[[returnDict valueForKey:@"stages"] valueForKey:@"encodedPoints"] objectAtIndex:0];
            //\SBJson reolization
    }
    return returnString;
}

+ (YandexMapKitRoute *) showRouteOnMap:(YMKMapView *)mapView From:(YMKMapCoordinate) coordinateFrom To: (YMKMapCoordinate) coordinateTo{
    YandexMapKitRoute* returnRoute;
    @try {
        //Check if already have routeView
        if([[((UIScrollView<UIScrollViewDelegate> *) [mapView.subviews objectAtIndex:1]).subviews objectAtIndex:1] isKindOfClass:[YandexMapKitRoute class]]){
            //Update existen
            returnRoute=[((UIScrollView<UIScrollViewDelegate> *) [mapView.subviews objectAtIndex:1]).subviews objectAtIndex:1];
        }
        else{
            //Create new View
            returnRoute = [[YandexMapKitRoute alloc] initWithFrame:(CGRect){0,0,mapView.frame.size}];
            //Get UIScrollView
            returnRoute.YXScrollView = (UIScrollView<UIScrollViewDelegate> *) [mapView.subviews objectAtIndex:1];
            //Insert RouteView
            [returnRoute.YXScrollView insertSubview:returnRoute atIndex:1];
            returnRoute.YMKMapViewInternal = mapView;
            
            //Set proxy delegate to handle events
            YandexMapKitRouteDelegate * delegate=[[YandexMapKitRouteDelegate alloc] init];
            if(mapView.delegate!=nil)
                delegate.oldDelegate=mapView.delegate;
            delegate.mapView=mapView;
            mapView.delegate=nil;
            mapView.delegate=delegate;
            
            //Setting properties of Route view
            [returnRoute setBackgroundColor:[UIColor clearColor]];
            [returnRoute setUserInteractionEnabled:NO];
            
            delegate.route=returnRoute;
            returnRoute.delegate= delegate;
        }
        
        NSString * routeString=[YandexMapKitRoute getRouteStringFrom:coordinateFrom To:coordinateTo];
        if(routeString==nil)
            return nil;
        returnRoute.geoPointArray = [YandexMapKitRoute parseData:[YandexBase64 decode:routeString]];
        
        
        
        CGRect frame=returnRoute.frame;
        frame.origin=returnRoute.YXScrollView.contentOffset;
        returnRoute.frame=frame;
        [returnRoute setNeedsDisplay];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Can't show route");
    }
    @finally {
        return returnRoute;
    }
}
- (void) drawRect:(CGRect)rect{
    //Get values of zoom
    float zoomScale = [(fakeYMKMapView *)self.YMKMapViewInternal zoomScale];
    float metersInPixel = ((fakeYMKMapView *)self.YMKMapViewInternal).metersInPixel;
    
    //Magic constat numbers need to convert lat and long to pixel by zoom level
    float constantY=2913*1.775*2*(10.76/(metersInPixel / zoomScale));
    float constantX=2913*2*(10.76/(metersInPixel / zoomScale));
    
    //Lat and long of zero point rect
    float  minY=self.YMKMapViewInternal.region.center.latitude+(self.YMKMapViewInternal.region.span.latitudeDelta/2);
    float  minX=self.YMKMapViewInternal.region.center.longitude-(self.YMKMapViewInternal.region.span.longitudeDelta/2);
    
    //Setting CGContext
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, 0);
    CGContextScaleCTM(context, 1.0, -1.0);
    //Width of route line
    CGContextSetLineWidth(context, 5.0);
    //Color of route line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].CGColor);
    
    //Move to first position of route
    CGContextMoveToPoint(context, ([[[_geoPointArray objectAtIndex:0] objectForKey:@"X"] floatValue]-minX)*constantX , ([[[_geoPointArray objectAtIndex:0] objectForKey:@"Y"] floatValue]-minY)*constantY);
    for (NSDictionary * position in _geoPointArray) {
        //Draw route
        CGContextAddLineToPoint(context, ([[position objectForKey:@"X"] floatValue]-minX)*constantX,([[position objectForKey:@"Y"] floatValue]-minY)*constantY);
    }
    
    CGContextStrokePath(context);
    
}

//Function to convert Yandex dif coordinate to absoulute lat long coordinate
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

@end
