//
//  MyView.h
//  TestPAD
//
//  Created by Clay Sanders on 6/6/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadCondition.h"

@interface MyView : UIView 


{int counter;}


@property NSArray * loadSelectedArray;
@property NSNumber * supportConditionNumberSelected;

@property NSMutableArray * loadData;
@property NSMutableArray * supportData;
@property NSMutableArray * nodalCoordinates;
@property NSMutableArray * nodalConnectivity;



@end
