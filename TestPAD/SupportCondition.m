//
//  SupportCondition.m
//  TestPAD
//
//  Created by Clay Sanders on 6/29/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import "SupportCondition.h"
#import "MyView.h"

@interface SupportCondition ()


@property NSArray * supportTypes;

@property (weak, nonatomic) IBOutlet UIPickerView *supportSelector;


@end

@implementation SupportCondition

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@synthesize supportDelegate;
@synthesize selectedSupportModeNumber;


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  [self.supportTypes count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.supportTypes[row];
    
}



-(IBAction)cancel:(id)sender{
    [self.supportDelegate didCancelSupportCondition:self];
    
}

-(IBAction)didSelect:(id)sender{
    
    [self.supportDelegate didSelectSupportCondition:self withModeSelected:self.selectedSupportModeNumber];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *numberArray =[[NSArray alloc]initWithObjects:@0,@1,@2, nil];
    
    NSDictionary *supportTypesDict= [[NSDictionary alloc]initWithObjects:numberArray forKeys:self.supportTypes];
    
    self.selectedSupportModeNumber = [supportTypesDict objectForKey:[self.supportTypes objectAtIndex:row]];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.supportTypes = [NSArray arrayWithObjects:@"Fixed Support",@"Pin",@"Roller", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
 
 
    // Pass the selected object to the new view controller.
}
*/

@end
