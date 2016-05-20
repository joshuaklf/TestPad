//
//  AnalysisView.m
//  TestPAD
//
//  Created by Clay Sanders on 7/13/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import "AnalysisView.h"

@interface AnalysisView()

@property IBOutlet UILabel *dispReading;
// @property IBOutlet UILabel *fReading;
// @property CGPoint myPoint1;
// @property CGPoint myPoint2;

@end

@implementation AnalysisView
@synthesize nodalConnectivity;
@synthesize nodalCoordsMod,nodalCoordinates;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setDrawingMode:(NSInteger)m{
    self.drawMode =m;
    
    
    
}
-(IBAction)deformedShape:(id)sender{
    self.drawMode = 1;
    NSLog(@"self mode %li",(long)self.drawMode);
    [self.dispReading setText:@"Displaying: Deflected Shape"];
    [self setNeedsDisplay];
    
}

-(IBAction) membersinTC:(id)sender{
    [self setDrawingMode:2];
    [self setNeedsDisplay];
    
}

-(IBAction)deflections:(id)sender{
    [self.dispReading setText:@"Node Displacements"];
    [self setDrawingMode:3];
    [self setNeedsDisplay];
    
}

-(IBAction)memberForces:(id)sender{
    [self.dispReading setText:@"Member Forces"];
    [self setDrawingMode:4];
    [self setNeedsDisplay];
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
    
    
    float b = sqrt(m+n);
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
    
    NSUInteger buzz= [numberarray indexOfObject:min];
    
    
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
    NSLog(@"mode %li",(long)self.drawMode);
    UITouch *touch = [[allTouches allObjects]objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
//    UITouch *touch2 = [[allTouches allObjects]objectAtIndex:1];
//    CGPoint point2 = [touch2 locationInView:self];
    
    switch (self.drawMode) {
        case 3:{
            CGPoint pointed = [self roundPoint: point];
            NSArray * nodeCoordinatestoDisplay = [[NSArray alloc]init];
            nodeCoordinatestoDisplay = [self getCoords:pointed];
            BOOL duplicate = [self.nodalCoordinates containsObject:nodeCoordinatestoDisplay];
            
            if (duplicate ==1) {
                NSInteger nodeSelected = [self.nodalCoordinates indexOfObject:nodeCoordinatestoDisplay] + 1;
                float xDisp = self.del[3*nodeSelected - 3];
                float yDisp = self.del[3*nodeSelected - 2];
                float tDisp = self.del[3*nodeSelected - 1];
                
                NSString *dispString = [NSString stringWithFormat:@"Node %li Displacement: (x: %f, y: %f, rot: %f)",(long)nodeSelected,xDisp,yDisp,tDisp];
                
                [self.dispReading setText:dispString];
            }
            break;
        }
        //case 4:{
            /*
            CGPoint pointed1 = [self roundPoint:point];
            CGPoint pointed2 = [self roundPoint:point2];
            NSArray * n1Coords = [self getCoords:pointed1];
            NSArray * n2Coords = [self getCoords:pointed2];
            BOOL dup1 = [self.nodalCoordinates containsObject:n1Coords];
            BOOL dup2 = [self.nodalCoordinates containsObject:n2Coords];
            int member = 0;
            int test1;
            int test2;
            if (dup1 == 1 && dup2 == 1) {
                int node1 = (int)[self.nodalCoordinates indexOfObject:n1Coords] + 1;
                int node2 = (int)[self.nodalCoordinates indexOfObject:n2Coords] + 1;
                for (int i=0; i<[self.nodalConnectivity count]; i++) {
                    NSArray *testRow = [self.nodalConnectivity objectAtIndex:i];
                    test1 = [(NSNumber*)[testRow objectAtIndex:0] intValue];
                    test2 = [(NSNumber*)[testRow objectAtIndex:1] intValue];
                    if (test1==node1 && test2==node2) {
                        member = i+1;
                    }
                }
                NSArray *f = [self.memberForces objectAtIndex:member];
                
                NSString *fString = [NSString stringWithFormat:@"Member %i element forces: (T: %@, V: %@, M: %@)",member,f[0],f[1],f[2]];
                
                [self.fReading setText:fString];
            }
            break;
            */
        //}
        default:
            break;
    }
    
    
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetRGBFillColor(ctx, 0.281,0.130,0.805,1.0);
    CGContextSetRGBStrokeColor(ctx, 0.256,0.130,0.805,1.0);
    
    
    for (int i=0; i<[self.nodalCoordinates count]; i++) {
        NSArray *nodeToConnect = [[NSArray alloc]init];
        nodeToConnect = [self.nodalCoordinates objectAtIndex:i];
        float nodeX = [[nodeToConnect objectAtIndex:0] floatValue];
        float nodeY = [[nodeToConnect objectAtIndex:1] floatValue];
        
        CGRect circlePointed = CGRectMake(nodeX -3, nodeY - 3, 6, 6);
        CGContextFillEllipseInRect(ctx, circlePointed);
        
    }
    
    for (int i = 0; i<[self.nodalConnectivity count]; i++) {
        NSArray *memberToDraw = [[NSArray alloc]init];
        memberToDraw = [self.nodalConnectivity objectAtIndex: i];
        NSInteger nodeOne =[[memberToDraw objectAtIndex:0] integerValue];
        NSInteger  nodeTwo = [[memberToDraw objectAtIndex:1]integerValue];
        
        NSArray *memberCoordinates = [self.nodalCoordinates objectAtIndex:nodeOne -1];
        
        
        float nodeOneX = [[memberCoordinates objectAtIndex:0] floatValue];
        float nodeOneY = [[memberCoordinates objectAtIndex: 1] floatValue];
        
        memberCoordinates =[self.nodalCoordinates objectAtIndex: nodeTwo -1];
        
        float nodeTwoX = [[memberCoordinates objectAtIndex: 0] floatValue];
        float nodeTwoY = [[memberCoordinates objectAtIndex: 1] floatValue];
        
        CGContextMoveToPoint(ctx, nodeOneX, nodeOneY);
        CGContextAddLineToPoint(ctx, nodeTwoX, nodeTwoY);
        
        CGContextStrokePath(ctx);
        
        
    }
    
    
    
    if (self.drawMode ==1) {
        
        
        CGContextSetRGBStrokeColor(ctx, 0.856,0.130,0.805,1.0);
        
        for (int i = 0; i<[self.nodalConnectivity count]; i++) {
            NSArray *memberToDraw = [[NSArray alloc]init];
            memberToDraw = [self.nodalConnectivity objectAtIndex: i];
            NSInteger nodeOne =[[memberToDraw objectAtIndex:0] integerValue];
            NSInteger  nodeTwo = [[memberToDraw objectAtIndex:1]integerValue];
            
            NSArray *memberCoordinates = [self.nodalCoordsMod objectAtIndex:nodeOne -1];
            
            
            float nodeOneX = [[memberCoordinates objectAtIndex:0] floatValue];
            float nodeOneY = [[memberCoordinates objectAtIndex: 1] floatValue];
            
            memberCoordinates =[self.nodalCoordsMod objectAtIndex: nodeTwo -1];
            
            float nodeTwoX = [[memberCoordinates objectAtIndex: 0] floatValue];
            float nodeTwoY = [[memberCoordinates objectAtIndex: 1] floatValue];
            
            CGContextMoveToPoint(ctx, nodeOneX, nodeOneY);
            CGContextAddLineToPoint(ctx, nodeTwoX, nodeTwoY);
            
            CGContextStrokePath(ctx);
        }
        
    }
    
    
    
}


@end
