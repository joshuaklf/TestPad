//
//  ViewController.h
//  TestPAD
//
//  Created by Clay Sanders on 6/5/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
#import "MyView.h"
#import "SupportCondition.h"
#import "MaterialSelection.h"
#import "ProcessModule.h"
@interface ViewController : UIViewController <LoadConditionDelegate, SupportConditionDelegate, MaterialSelectionDelegate>

@property (strong, nonatomic) IBOutlet MyView *myViewData;
@property int drawMode;
@property NSArray * loadSelectionArrayNumbers;
@property NSNumber * supportSelectionNumber;
@property NSArray * materialProperties;
@property NSArray * nodalConnecivity;
@property NSArray * nodalCoordinates;
@property NSArray * loadData;
@property NSArray * supportData;



@end
