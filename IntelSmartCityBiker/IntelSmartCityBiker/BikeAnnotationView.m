//
//  BikeAnnotationView.m
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "BikeAnnotationView.h"
#import "BikeAnnotation.h"

@interface BikeAnnotationView ()

@property (nonatomic, strong) UILabel *label;
@end
@implementation BikeAnnotationView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
        
        BikeAnnotation *bikeAnn = (BikeAnnotation *) annotation;
        self.opaque = NO;
        _bikeID = bikeAnn.bikeID;
        
        //self.image = [UIImage imageNamed:@"station.png"];
        _label = [[UILabel alloc] initWithFrame:(CGRect){-10,0,self.frame.size.width+20,20}];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor redColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"Helvetica" size:13];
        _label.layer.cornerRadius = 5;
        _label.text = @"Reserved";
        [self addSubview:_label];
        [self refreshStatus];

    }
    return self;
    
}
- (void) refreshStatus
{
     BikeAnnotation *bikeAnn = (BikeAnnotation *) self.annotation;
    _label.hidden = ![bikeAnn.status isEqualToString:@"Reserved"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGRect imgRect = rect;
    imgRect.size.height -=20;
    imgRect.origin.y = 20;
    
    BikeAnnotation * ann = (BikeAnnotation *) [self annotation];
    NSString *imgPath = [NSString stringWithFormat:@"%@.png",ann.color];
    NSLog(imgPath);
    UIImage *img = [UIImage imageNamed:imgPath];

    [img drawInRect:imgRect];

}


@end
