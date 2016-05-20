//
//  SupportCondition.h
//  TestPAD
//
//  Created by Clay Sanders on 6/29/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupportCondition;
@protocol SupportConditionDelegate <NSObject>

-(void)didCancelSupportCondition: (SupportCondition *)controller;
-(void)didSelectSupportCondition:(SupportCondition *) controller withModeSelected: (NSNumber *) numMode;


@end

@interface SupportCondition : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) id <SupportConditionDelegate> supportDelegate;
@property (nonatomic,strong) NSNumber *selectedSupportModeNumber;

-(IBAction)cancel:(id)sender;
-(IBAction)didSelect:(id)sender;



@end
