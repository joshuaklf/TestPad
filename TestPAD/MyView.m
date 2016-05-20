//
//  MyView.m
//  TestPAD
//
//  Created by Clay Sanders on 6/6/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import "MyView.h"
#import "LoadCondition.h"


@interface MyView()
@property (nonatomic) CGPoint myPoint;
@property (nonatomic) CGPoint myPoint2;
@property (nonatomic)  NSInteger mode;
@property IBOutlet UILabel *ModeReading;



@end

@implementation MyView{
    NSMutableArray *nodalCoord;
    NSMutableArray *connectCoord;
    NSMutableArray *coordVar;

    
}
@synthesize myPoint=_myPoint, myPoint2=_myPoint2;
@synthesize mode;
@synthesize loadSelectedArray;
@synthesize supportConditionNumberSelected;
@synthesize loadData,supportData,nodalConnectivity,nodalCoordinates;

int counter=0;
NSInteger  node = 1;



-(void)setMyPoint:(CGPoint)myPoint{
    _myPoint=myPoint;
    [self setNeedsDisplay];
}

-(void)setMyPoint2:(CGPoint)myPoint2{
    _myPoint2=myPoint2;
    [self setNeedsDisplay];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setMode:(NSInteger) modal{
    mode = modal;
    switch (mode) {
        case 0:
            [self.ModeReading setText:@"Select a Mode"];
            break;
        case 1:
            [self.ModeReading setText:@"Mode: Draw"];
            break;
        case 3:
            [self.ModeReading setText:@"Mode: Delete"];
            break;
        case 4:
            [self.ModeReading setText:@"Mode: Add Load Condition"];
            break;
        case 5:
            [self.ModeReading setText:@"Mode: Add Support Condition"];
            break;
        default:
            break;
    }
}

-(IBAction)drawMode:(id)sender{
    [self setMode:1];
    
}



bool clearVals = 0;
-(void)alertView: (UIAlertView *) wantToClear clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==wantToClear.cancelButtonIndex) {
        return;
    }else{
        clearVals = 1;
        [nodalCoord removeAllObjects];
        [connectCoord removeAllObjects];
        [self.loadData removeAllObjects];
        [self.supportData removeAllObjects];
        
        counter = 0;
        node = 1;
        
        [self setNeedsDisplay];
        clearVals = 0;
        [self.ModeReading setText:@"Select Mode"];
        
    }
}

-(IBAction)clearMode:(id)sender{
    [self.ModeReading setText:@"Mode: Clear"];
    UIAlertView *wantToClear =[[UIAlertView alloc]initWithTitle:@"Clear All Objects" message:@"Are you sure you want to clear all objects?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Clear", nil];
    [wantToClear show];
    
}

-(IBAction)delMode:(id)sender{
    [self setMode:3];
    
}

//LOAD DELEGATE
-(IBAction)addLoadCondition:(id)sender{
    [self setMode:4];
}



-(IBAction)addSupportCondition:(id)sender{
    [self setMode:5];
    
}






//RoundPoint
-(CGPoint) roundPoint: (CGPoint) pointed{
    float bb = pointed.x;
    float ee = pointed.y;
    
    float cc = bb/20;
    float ff = ee/20;
    
    
    float dd = floorf(cc);
    float gg = floorf(ff);
    
    
    float j= bb - dd*20;
    float k= ee - gg*20;

    
    float m = pow(j,2);
    float n = pow(k,2);
    
    
    float a = pow((25-j),2);
    float c = pow((25-k),2);
    
    
    float b = sqrt(m + n);
    float d = sqrt(m + c);
    float e = sqrt(a + n);
    float f = sqrt(a + c);
    
    NSNumber *bn = [NSNumber numberWithFloat:b];
    NSNumber *dn = [NSNumber numberWithFloat:d];
    NSNumber *en = [NSNumber numberWithFloat:e];
    NSNumber *fn = [NSNumber numberWithFloat:f];
    
    
    NSArray *numberarray =[[NSArray alloc]init];
    numberarray = [NSArray arrayWithObjects:bn,dn,en,fn, nil];
    
    NSNumber *min = [numberarray valueForKeyPath:@"@min.doubleValue"];
    
    NSInteger buzz= [numberarray indexOfObject:min];
    
    
    int finalX;
    int finalY;
    switch (buzz) {
        case 0:
            finalX =0;
            finalY = 0;
            break;
        case 1:
            finalX =0;
            finalY = 20;
            break;
        case 2:
            finalX =20;
            finalY = 0;
            break;
        case 3:
            finalX =20;
            finalY = 20;
            break;
        default:
            break;
    }
    
    
    float endX = finalX + dd*20;
    float endY = finalY + gg*20;
    NSLog(@"Original Point is %f, %f",bb,ee);
    NSLog(@"Final Point is (%f, %f) ",endX,endY);

    CGPoint pointedNew = CGPointMake(endX, endY);
    
    return pointedNew;
}



-(NSArray*) getCoords: (CGPoint) point{
    NSArray *coords = [[NSArray alloc]init];
    NSNumber * numX = [NSNumber numberWithFloat:point.x];
    NSNumber * numY =[NSNumber numberWithFloat: point.y];
    coords= [NSArray arrayWithObjects: numX, numY, nil];
    return coords;
    //LoadCondition
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    NSLog(@"mode %li",(long)mode);
    UITouch *touch = [[allTouches allObjects]objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
    switch (mode) {
            //DRAW MODE
        case 1:{
            counter++;
            if(counter %2 !=0){
                self.myPoint= [self roundPoint:point];
            }
            else{
                 self.myPoint2= [self roundPoint:point];
            }
    
            NSArray *coords = [[NSArray alloc]init];
            NSMutableArray *connect = [[NSMutableArray alloc]init];
            
            if(counter %2 ==1)
            {
                coords = [self getCoords:self.myPoint];
            }
            else{
                coords = [self getCoords:self.myPoint2];
                
            }

            
            BOOL duplicate;
            duplicate = [nodalCoord containsObject: coords];
            
            NSNumber *nodeNumMinus;
            NSNumber *nodeNum;
            if (counter ==1){
                nodalCoord = [NSMutableArray arrayWithObjects:coords, nil];

            }
            
            else{
                
                if(duplicate == 0){

                    node ++;
                    
                    
                    [nodalCoord insertObject:coords atIndex:node- 1];
                    NSLog(@"nodalCoord %@",nodalCoord);
                }
            }

            if(counter %2 == 0){
                
                NSNumber *pointOneX= [NSNumber numberWithFloat:self.myPoint.x];
                NSNumber *pointOneY= [NSNumber numberWithFloat:self.myPoint.y];
                NSArray *pointOne = [[NSArray alloc] init];
                pointOne = [NSArray arrayWithObjects:pointOneX, pointOneY, nil];
                
      
                NSInteger pointOneNode;
                pointOneNode = [nodalCoord indexOfObject:pointOne]+1;

                
                nodeNumMinus = [NSNumber numberWithInteger:pointOneNode];
                
                
                NSInteger nodeNew1 = [nodalCoord indexOfObject: coords]+1 ;
                nodeNum = [NSNumber numberWithInteger:nodeNew1];
                
                connect = [NSMutableArray arrayWithObjects:nodeNumMinus,nodeNum, nil];
                

                if([connectCoord count]==0){
                    connectCoord = [NSMutableArray arrayWithObjects:connect, nil];
                    NSLog(@"connectCoord %@",connectCoord);
                }
                else{
                    [connectCoord insertObject:connect atIndex:[connectCoord count]];
                    NSLog(@"connectCoord %@",connectCoord);
                }
                

            }
            break;}
            
        //DELETE CODE
        case 3:{
            CGPoint pointed = [self roundPoint: point];
            NSArray * nodeCoordinatesToDelete = [[NSArray alloc]init];
            nodeCoordinatesToDelete = [self getCoords:pointed];
            BOOL duplicate = [nodalCoord containsObject:nodeCoordinatesToDelete];
            
            if(duplicate ==1){
                NSNumber *nodeSel = [NSNumber numberWithInteger:[nodalCoord indexOfObject:nodeCoordinatesToDelete]+1];
                NSLog(@"Node Selected is %@",nodeSel);
                


                for (int i =0; i<[connectCoord count]; i++) {
                    BOOL nodeConnected =[[connectCoord objectAtIndex:i] containsObject:nodeSel];
                    NSArray *tempArray = [connectCoord objectAtIndex:i];
                    //NSLog(@"temp Array is %@ and node connected %i",tempArray,nodeConnected);

                    if (nodeConnected ==1) {
                        [connectCoord removeObject: tempArray];
                        i=i-1;
                    }
                }
                //Delete Supports
                for (int i= 0; i<[self.supportData count]; i++) {
                    BOOL nodeConnected =[[self.supportData objectAtIndex: i] containsObject:nodeSel];
                    NSArray *tempArray = [self.supportData objectAtIndex: i];
                    if  (nodeConnected ==1){
                        [self.supportData removeObject:tempArray];
                        i=i-1;
                    }
                }
                //Delete Loads
                for (int i=0; i<[self.loadData count]; i++) {
                    BOOL nodeConnected =[[self.loadData objectAtIndex: i] containsObject:nodeSel];
                    NSArray *tempArray = [self.loadData objectAtIndex: i];
                    if  (nodeConnected ==1){
                        [self.loadData removeObject:tempArray];
                        i=i-1;
                    }
                    
                }
                
                [nodalCoord removeObjectAtIndex:[nodeSel intValue]-1];

                NSLog(@"connectCoord is %@",connectCoord);
                NSLog(@"Nodal Coordinates are %@",nodalCoord);
                NSLog(@"Load Data Now: %@ with count %lu",self.loadData,(unsigned long)[self.loadData count]);
                NSLog(@"Support Data: %@ with count %lu",self.supportData,(unsigned long)[self.supportData count]);
                
                node = node-1;
                
                //LOOK AT
                if (counter %2 ==1) {
                    counter = counter-1;
                }
                
                if ([connectCoord count]>0) {
                    
                for (int i = 0; i<[connectCoord count]; i++) {
                    NSArray * memberArray = [[NSArray alloc]init];
                    memberArray = [connectCoord objectAtIndex: i];
                    NSInteger nodeOne = [[memberArray objectAtIndex:0] integerValue];
                    NSInteger nodeTwo = [[memberArray objectAtIndex:1]integerValue];
                    
                    if ([nodeSel integerValue]< nodeOne){
                        nodeOne = nodeOne -1;
                    }
                    if ([nodeSel integerValue] <nodeTwo) {
                        nodeTwo = nodeTwo -1;
                    }
                    
                    memberArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:nodeOne], [NSNumber numberWithInteger:nodeTwo], nil];
                    [connectCoord replaceObjectAtIndex:i withObject:memberArray];
                    
                    
                }
                }
                
                
                //DELETE SUPPORTS
                
                for (int i = 0; i<[self.supportData count]; i++) {
                    NSMutableArray * memberArray = [[NSMutableArray alloc]init];
                    memberArray = [self.supportData objectAtIndex: i];
                    NSInteger nodeOne = [[memberArray objectAtIndex:0] integerValue];
                    NSNumber *xR = [memberArray objectAtIndex:1];
                    NSNumber *yR = [memberArray objectAtIndex:2];
                    
                    if ([nodeSel integerValue]< nodeOne){
                        nodeOne = nodeOne -1;
                    }
                    NSNumber *nodeOneNum = [NSNumber numberWithInteger:nodeOne];
                    NSLog(@"NSNumber %@",nodeOneNum);
                    
                    //[memberArray replaceObjectAtIndex:0 withObject:nodeOneNum];
                    
                    memberArray = [NSMutableArray arrayWithObjects:nodeOneNum, xR,yR, nil];
                                        
                    [self.supportData replaceObjectAtIndex:i withObject:memberArray];
                }
                
                //DELETE LOADS
                for (int i = 0; i<[self.loadData count]; i++) {
                    NSMutableArray * memberArray = [[NSMutableArray alloc]init];
                    memberArray = [self.loadData objectAtIndex: i];
                    NSInteger nodeOne = [[memberArray objectAtIndex:0] integerValue];
                    NSNumber *xR = [memberArray objectAtIndex:1];
                    NSNumber *yR = [memberArray objectAtIndex:2];
                    NSNumber *tR = [memberArray objectAtIndex:3];
                    
                    
                    if ([nodeSel integerValue]< nodeOne){
                        nodeOne = nodeOne -1;
                    }
                    NSNumber *nodeOneNum = [NSNumber numberWithInteger:nodeOne];
                    memberArray = [NSMutableArray arrayWithObjects:nodeOneNum, xR,yR,tR, nil];
                    
                    [self.loadData replaceObjectAtIndex:i withObject:memberArray];
                }
                NSLog(@"Node is %li",(long)node);
                
                NSLog(@"Counter is %i",counter);

                
            }

            [self setNeedsDisplay];
           
            
            break;}
            
        //CASE 5: SUPPORT MODE
            
        case 5:{
            NSArray * supportRowEntry = [[NSArray alloc]init];
            CGPoint pointed= [self roundPoint:point];
            NSArray *supportPoint = [self getCoords:pointed];
            BOOL duplicate = [nodalCoord containsObject:supportPoint];
            if(duplicate == 1){
                NSNumber *nodeSel = [NSNumber numberWithInteger:[nodalCoord indexOfObject:supportPoint]+1];
                for (int i= 0; i<[self.supportData count]; i++) {
                    BOOL nodeConnected =[[self.supportData objectAtIndex: i] containsObject:nodeSel];
                    NSArray *tempArray = [self.supportData objectAtIndex: i];
                    if  (nodeConnected ==1){
                        [self.supportData removeObject:tempArray];
                        i=i-1;
                    }
                }
                NSNumber *loadNode = [[NSNumber alloc]init];
                loadNode = [NSNumber numberWithLong:[nodalCoord indexOfObject:supportPoint]+1];
                NSInteger supportNumber = [self.supportConditionNumberSelected intValue ];
                
                switch (supportNumber) {
                        //FIXED SUPPORT
                    case 0:
                        supportRowEntry = @[loadNode,@1,@1,@1];
                        NSLog(@"Support Row Entry is %@",supportRowEntry);
                        
                        break;
                        //PIN
                    case 1:
                        supportRowEntry = @[loadNode,@3,@1,@0];
                         NSLog(@"Support Row Entry is %@",supportRowEntry);
                        break;
                        //ROLLER
                    case 2:
                        supportRowEntry = @[loadNode,@0,@1,@0];
                         NSLog(@"Support Row Entry is %@",supportRowEntry);
                        break;
                        //SIDE ROLLER
//                    case 3:
//                        supportRowEntry = @[loadNode,@1,@0,@0];
//                        break;
                    default:
                        break;
                }
                if ([self.supportData count] ==0) {
                    self.supportData = [NSMutableArray arrayWithObject: supportRowEntry];
                    NSLog(@"Support Data %@",self.supportData);
                }else{
                    [self.supportData addObject:supportRowEntry];
                    NSLog(@"Support Data %@",self.supportData);
                }
            }
            [self setMode:0];
            [self setNeedsDisplay];
            break;
        }
            
        //LOAD MODE
        case 4:{
            CGPoint pointed = [self roundPoint:point];
            NSArray *loadPoint = [self getCoords:pointed];

            BOOL duplicate = [nodalCoord containsObject:loadPoint];
            if (duplicate == 1) {
                NSNumber *loadNode = [NSNumber numberWithLong:[nodalCoord indexOfObject:loadPoint]+1];
                NSMutableArray *loadRowEntry = [[NSMutableArray alloc]initWithArray:self.loadSelectedArray];
                [loadRowEntry insertObject:loadNode atIndex:0];
                NSLog(@"LoadRowEntry is %@",loadRowEntry);
                if([self.loadData count] ==0){
                    self.loadData =[NSMutableArray arrayWithObject:loadRowEntry];
                    NSLog(@"Load data is %@",self.loadData);
                }else{
                    [self.loadData addObject:loadRowEntry];
                    NSLog(@"Load data is %@",self.loadData);
                }
            [self setMode:0];
            [self setNeedsDisplay];
            }
        }
            break;
  
        default:
            break;
    }
    self.nodalCoordinates = nodalCoord;
    self.nodalConnectivity = connectCoord;
    
}





// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
//GRID CODE
    CGContextSetRGBStrokeColor(ctx, 1,1,1, 1);
        CGContextSetLineWidth(ctx, 5);

    for (int i = 1; i<42; i++) {
        
        if (i%2 ==0) {
            CGContextSetLineWidth(ctx, 1.1);
        }else{
           CGContextSetLineWidth(ctx, 0.5);
        }
        
            CGContextMoveToPoint(ctx, i*20, 0);
            CGContextAddLineToPoint(ctx, i*20, 600);
        CGContextStrokePath(ctx);
    }

    
    for (int j = 1; j<30; j++) {
        
        if (j%2 ==0) {
            CGContextSetLineWidth(ctx, 1.1);
        }else{
            CGContextSetLineWidth(ctx, 0.5);
        }
        
        CGContextMoveToPoint(ctx, 0, j*20);
        CGContextAddLineToPoint(ctx, 850, j*20);
        
        CGContextStrokePath(ctx);

    }
    
    // Drawing code
    if(counter >=1){

        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetRGBFillColor(ctx, 0.481,0.130,0.105,1.0);
        CGContextSetRGBStrokeColor(ctx, 0.56,0.130,0.105,1.0);
        
        for (int i=0; i<[nodalCoord count]; i++) {
            NSArray *nodeToConnect = [[NSArray alloc]init];
            nodeToConnect = [nodalCoord objectAtIndex:i];
            float nodeX = [[nodeToConnect objectAtIndex:0] floatValue];
            float nodeY = [[nodeToConnect objectAtIndex:1] floatValue];
            
            CGRect circlePointed = CGRectMake(nodeX -4, nodeY - 4, 8, 8);
            CGContextFillEllipseInRect(ctx, circlePointed);
            
        }
        
        for (int i = 0; i<[connectCoord count]; i++) {
            NSArray *memberToDraw = [[NSArray alloc]init];
            memberToDraw = [connectCoord objectAtIndex: i];
            NSInteger nodeOne =[[memberToDraw objectAtIndex:0] integerValue];
            NSInteger nodeTwo = [[memberToDraw objectAtIndex:1] integerValue];
            
            NSArray *memberCoordinates = [nodalCoord objectAtIndex:nodeOne -1];
            
            float nodeOneX = [[memberCoordinates objectAtIndex:0] floatValue];
            float nodeOneY = [[memberCoordinates objectAtIndex: 1] floatValue];
            
            memberCoordinates =[nodalCoord objectAtIndex: nodeTwo -1];
            
            float nodeTwoX = [[memberCoordinates objectAtIndex: 0] floatValue];
            float nodeTwoY = [[memberCoordinates objectAtIndex: 1] floatValue];
            
            CGContextMoveToPoint(ctx, nodeOneX, nodeOneY);
            CGContextAddLineToPoint(ctx, nodeTwoX, nodeTwoY);
            
            CGContextStrokePath(ctx);

            
        }

        
        
        //SUPPORT DRAWINGS
        CGContextSetRGBStrokeColor(ctx, 0,0,0,1.0);
        CGContextSetLineWidth(ctx, 2);
        
             for (int i=0; i<([self.supportData count]); i++) {

            // what is a row of sd? A: [node xcheck ycheck rcheck]
            NSArray *nodeSupportEntry = [self.supportData objectAtIndex:i];
            NSInteger nodeSupported= [[nodeSupportEntry objectAtIndex:0] integerValue];
                 
                 NSArray *supportInfo = [NSArray arrayWithObjects:[nodeSupportEntry objectAtIndex:1],[nodeSupportEntry objectAtIndex:2],[nodeSupportEntry objectAtIndex:3], nil];
            
            NSArray *coordsvar = [[NSArray alloc]init];
            coordsvar = [nodalCoord objectAtIndex:(nodeSupported-1)];
            NSLog(@"COORDSVAR is %@",coordsvar);
            NSNumber *xvals= [coordsvar objectAtIndex:0];
            
            NSNumber *yvals = [coordsvar objectAtIndex:1];
            
            float xval= [xvals floatValue];
            float yval = [yvals floatValue];
                 
            //come back here to fix support redraw issue
            if ([supportInfo isEqualToArray:@[@1,@1,@1]]==1) {
                CGContextSetLineWidth(ctx, 4);
                CGContextMoveToPoint(ctx, xval-15, yval+5);
                CGContextAddLineToPoint(ctx, xval + 15, yval+5);
                
                CGContextMoveToPoint(ctx, xval -15, yval + 10);
                CGContextAddLineToPoint(ctx, xval + 15, yval + 10);
                CGContextStrokePath(ctx);
                CGContextSetLineWidth(ctx, 2);

            }else if ([supportInfo isEqualToArray:@[@3,@1,@0]]==1){
                CGContextMoveToPoint(ctx, xval, yval);
                CGContextAddLineToPoint(ctx,xval-7.5,yval+15);
                CGContextAddLineToPoint(ctx, xval+7.5, yval+15);
                CGContextAddLineToPoint(ctx, xval, yval);
                
                CGContextMoveToPoint(ctx, xval-15, yval+15);
                CGContextAddLineToPoint(ctx, xval+15, yval + 15);
                CGContextStrokePath(ctx);
            }else if ([supportInfo isEqualToArray:@[@0,@1,@0]]==1){
                //TRIANGLE
                CGContextMoveToPoint(ctx, xval, yval);
                CGContextAddLineToPoint(ctx,xval-7.5,yval+12);
                CGContextAddLineToPoint(ctx, xval+7.5, yval+12);
                CGContextAddLineToPoint(ctx, xval, yval);
                CGContextStrokePath(ctx);
                
                //ROLLER CIRCLES
                CGRect circlePointOne = CGRectMake(xval-8.5, yval+13, 8, 8);
                CGContextFillEllipseInRect(ctx, circlePointOne);
                CGRect circlePointTwo = CGRectMake(xval +1.5, yval+13, 8, 8);
                CGContextFillEllipseInRect(ctx, circlePointTwo);
                
                //Ground
                CGContextMoveToPoint(ctx, xval -15,yval + 21);
                CGContextAddLineToPoint(ctx, xval +15, yval + 21);
                CGContextStrokePath(ctx);
                
                
            }

            
            
             }
        //LOAD DRAWINGS
        for (int i=0; i<[self.loadData count]; i++) {
            // loadRowEntry = [ node number, load type, load magn. ]?
            NSArray * loadRowEntry = [self.loadData objectAtIndex:i];
            NSInteger nodeLoaded = [[loadRowEntry objectAtIndex:0] intValue];
            NSArray *coordsvar = [nodalCoord objectAtIndex:(nodeLoaded-1)];
            NSInteger loadValue = [[loadRowEntry objectAtIndex:2]integerValue];
            
            NSNumber *xvals= [coordsvar objectAtIndex:0];
            NSNumber *yvals = [coordsvar objectAtIndex:1];
            
            float xval= [xvals floatValue];
            float yval = [yvals floatValue];

            
            NSInteger loadType = [[loadRowEntry objectAtIndex:1] integerValue];
            
            switch (loadType) {
                case 1:{
                    CGContextSetRGBStrokeColor(ctx, 0, .5, .20, 1);
                    CGContextMoveToPoint(ctx,xval,yval);
                    CGContextAddLineToPoint(ctx, xval + 50, yval);
                    
                    if (loadValue <0) {
                        CGContextMoveToPoint(ctx, xval, yval);
                        CGContextAddLineToPoint(ctx, xval + 10, yval + 7);
                        CGContextMoveToPoint(ctx, xval, yval);
                        CGContextAddLineToPoint(ctx, xval+10, yval -7);
                        
                    }else{
                        CGContextMoveToPoint(ctx, xval+50, yval);
                        CGContextAddLineToPoint(ctx, xval +40, yval + 7);
                        CGContextMoveToPoint(ctx, xval +50, yval);
                        CGContextAddLineToPoint(ctx, xval+40, yval -7);
                    }
                    CGContextStrokePath(ctx);

                    break;
                }
                case 2:{
                    CGContextSetRGBStrokeColor(ctx, 0, .2, .60, 1);
                    CGContextMoveToPoint(ctx,xval,yval);
                    CGContextAddLineToPoint(ctx, xval, yval-50);
                    if (loadValue >0) {
                        CGContextMoveToPoint(ctx, xval, yval-50);
                        CGContextAddLineToPoint(ctx, xval + 7, yval -40);
                        CGContextMoveToPoint(ctx, xval, yval-50);
                        CGContextAddLineToPoint(ctx, xval - 7, yval -40);
                    }else{
                        CGContextMoveToPoint(ctx, xval, yval);
                        CGContextAddLineToPoint(ctx, xval +7, yval - 10);
                        CGContextMoveToPoint(ctx, xval , yval);
                        CGContextAddLineToPoint(ctx, xval-7, yval -10);
                    }
                    CGContextStrokePath(ctx);
                    break;
                }
                    //moment drawing
                case 3:{
                    CGContextSetRGBStrokeColor(ctx, .60, .2, 0, 1);
                    CGContextMoveToPoint(ctx,xval,yval);
                    CGFloat radius = 25;
                    CGFloat startAngle = -((float)M_PI/2);
                    CGFloat endAngle = ((float)M_PI + startAngle);
                    CGContextMoveToPoint(ctx, xval, yval-radius);
                    CGContextAddArc(ctx, xval, yval, radius, startAngle, endAngle, 0);
                    if (loadValue <0) {
                        CGContextMoveToPoint(ctx, xval-10, yval+radius);
                        CGContextAddLineToPoint(ctx, xval, yval+radius+7);
                        CGContextMoveToPoint(ctx, xval-10, yval+radius);
                        CGContextAddLineToPoint(ctx, xval, yval+radius-7);
                        CGContextMoveToPoint(ctx, xval-10, yval+radius);
                        CGContextAddLineToPoint(ctx, xval, yval+radius);
                    }else{
                        CGContextMoveToPoint(ctx, xval-10, yval-radius);
                        CGContextAddLineToPoint(ctx, xval, yval-radius-7);
                        CGContextMoveToPoint(ctx, xval-10, yval-radius);
                        CGContextAddLineToPoint(ctx, xval, yval-radius+7);
                        CGContextMoveToPoint(ctx, xval-10, yval-radius);
                        CGContextAddLineToPoint(ctx, xval, yval-radius);
                    }
                    CGContextStrokePath(ctx);
                    break;
                }
                default:
                    break;
            }
        }
       
        
    }
    
}



@end
