//
//  TapItRequest.h
//  TapIt-iOS-Sample
//
//  Created by Nick Penteado on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapItRequest : NSURLRequest

@property (copy, nonatomic) NSDictionary *parameters;
@property (retain, nonatomic) NSString *rawResults;

+ (TapItRequest *)requestWithParams:(NSDictionary *)theParams;

@end
