//
//  LoadCondition.m
//  TestPAD
//
//  Created by Clay Sanders on 6/27/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import "LoadCondition.h"

@interface LoadCondition ()

@property (weak, nonatomic) IBOutlet UIPickerView *loadType;
@property (weak, nonatomic) IBOutlet UITextField *loadMag;
@property NSDictionary *loadTypes;
@property NSArray *loadKeys;
@property NSArray *selectedLoadArrays;

@end



@implementation LoadCondition

@synthesize loadDelegate;

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}


//PICKERVIEW CODE
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.loadKeys count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.loadKeys[row];
    
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *loadSelect;
    
    loadSelect = [NSString stringWithString:[self.loadKeys objectAtIndex:row]];
    
    self.selectedLoadMode = [self.loadTypes objectForKey:loadSelect];
}

-(IBAction)cancelLoadSelection:(id)sender{
    [self.loadDelegate didCancelLoad:self];
}

-(IBAction)sendLoadSelection:(id)sender{
    NSString *loadMagInput = self.loadMag.text;
    
    NSNumber *magNumber = [NSNumber numberWithFloat: [loadMagInput floatValue]];
    
    self.selectedLoadArrays = [NSArray arrayWithObjects:self.selectedLoadMode, magNumber, nil];
    NSLog(@"selected Load Array is %@",self.selectedLoadArrays);
    
    [self.loadDelegate loadController:self didSelectType:self.selectedLoadArrays];
}

//FORCE INPUT CODE
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /* for backspace */
    if([string length]==0){
        return YES;
    }
    
    /*  limit to only numeric characters  */
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-.e"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    
    return NO;
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadMag.keyboardType = UIKeyboardTypeDecimalPad;
    
   
    NSArray *loadObjects = [[NSArray alloc]init];
    loadObjects = [NSArray arrayWithObjects:@1,@2,@3, nil];
    self.selectedLoadArrays = @[@1,@1];
    self.selectedLoadMode = @1;
    
    self.loadKeys = [NSArray arrayWithObjects:@"Nodal X Load",@"Nodal Y Load",@"Nodal Moment", nil];
    
    self.loadTypes = [[NSDictionary alloc]init];
    self.loadTypes = [NSDictionary dictionaryWithObjects:loadObjects forKeys:self.loadKeys];
 
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
