//
//  LoadCondition.h
//  TestPAD
//
//  Created by Clay Sanders on 6/27/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadCondition;

@protocol LoadConditionDelegate <NSObject>

-(void) loadController: (LoadCondition *)controller didSelectType:(NSArray*) loadSelectionArray;
-(void) didCancelLoad:(LoadCondition *) controller;
@end


@interface LoadCondition : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property NSDictionary* loadCases;
@property NSNumber  *selectedLoadMode;
@property float loadMagnitude;

@property (strong,nonatomic) id <LoadConditionDelegate> loadDelegate;
-(IBAction)cancelLoadSelection:(id)sender;
-(IBAction)sendLoadSelection:(id)sender;


@end
