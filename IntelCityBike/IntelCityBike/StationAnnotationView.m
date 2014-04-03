//
//  StationAnnotationView.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "StationAnnotationView.h"
#import "StationAnnotation.h"

@interface StationAnnotationView()

@property (nonatomic, strong) UILabel *label;
@end
@implementation StationAnnotationView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    //    self.image = [UIImage imageNamed:@"station.png"];
        
    }
    return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect  myFrame = self.frame;
        myFrame.size.width = 40;
        myFrame.size.height = 80;
        self.frame = myFrame;
        
        self.opaque = NO;
        
        //self.image = [UIImage imageNamed:@"station.png"];
        _label = [[UILabel alloc] initWithFrame:(CGRect){-10,0,self.frame.size.width+20,20}];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.text = [NSString stringWithFormat:@"%d bikes",((StationAnnotation *)annotation).availableBikes];
        [self addSubview:_label];
        
    }
    return self;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGRect imgRect = rect;
    imgRect.size.height -=20;
    imgRect.origin.y = 20;
    UIImage *img = [UIImage imageNamed:@"station.png"];
    [img drawInRect:imgRect];
}


@end
