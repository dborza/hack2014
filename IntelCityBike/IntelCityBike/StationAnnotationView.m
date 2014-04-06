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
@property (nonatomic, strong) UIImageView *animView;
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
        myFrame.size.height = 100;
        self.frame = myFrame;
        
        self.opaque = NO;
        
        CGRect rect = (CGRect){-10,0,self.frame.size.width+20,20};
        
        _label = [[UILabel alloc] initWithFrame:rect];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.adjustsFontSizeToFitWidth = true;
        _label.text = [NSString stringWithFormat:@"%d bikes",((StationAnnotation *)annotation).availableBikes];
        
//        _animView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Fade2.png"]];
//        _animView.frame = (CGRect){0,0,60,100};
//        _animView.center = self.center;

        _animView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Fade.png"]];
        _animView.frame = (CGRect){0,0,60,40};
        _animView.center = _label.center;

        _animView.alpha = 0;
        
        [self addSubview:_animView];
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
    UIImage *img = [UIImage imageNamed:@"Station.png"];
    [img drawInRect:imgRect];
}

- (void) animateBikeChange:(int) newAvailableBikes
{
    CGRect frame = _label.frame;
    frame.size = CGSizeMake(frame.size.width-20, frame.size.height);
    frame.origin = CGPointMake(frame.origin.x+10, frame.origin.y);
    CGRect originalFrame = _label.frame;
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn |
        UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         _label.alpha = 0.3;
                         _animView.alpha = 0.8;
                         
                      //  _label.frame = frame;
                        
                     }
                     completion:^(BOOL finished) {
                        
                         [UIView animateWithDuration:0.2 animations:^{
                            // _label.frame = originalFrame;
                             _label.text = [NSString stringWithFormat:@"%d bikes",newAvailableBikes];
                             _label.alpha =1;
                             _animView.alpha = 0;
                         } completion:^(BOOL finished) {
                             
                         }];

                     }];
}
@end
