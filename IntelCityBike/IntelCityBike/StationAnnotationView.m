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
@property (nonatomic, strong) UILabel *animLabel;
@property (nonatomic, assign) int avBikes;
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
        
        CGRect rect = (CGRect){-10,0,self.frame.size.width+20,20};
        
        _label = [[UILabel alloc] initWithFrame:rect];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.adjustsFontSizeToFitWidth = true;
        _label.text = [NSString stringWithFormat:@"%d bikes",((StationAnnotation *)annotation).availableBikes];
        
        rect = (CGRect){self.frame.size.width-10,-20,20,20};
        _animLabel = [[UILabel alloc] initWithFrame:rect];
        _animLabel.textAlignment = NSTextAlignmentCenter;
        _animLabel.backgroundColor = [UIColor redColor];
        _animLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
       // _animLabel.adjustsFontSizeToFitWidth = true;
        _animLabel.textColor = [UIColor whiteColor];
        _animLabel.layer.cornerRadius = 10;
        _animLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _animLabel.alpha = 0;
        
        _animView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Fade.png"]];
        _animView.frame = (CGRect){0,0,60,40};
        _animView.center = _label.center;

        _animView.alpha = 0;
        
        [self addSubview:_animLabel];
        [self addSubview:_animView];
        [self addSubview:_label];
        
        _avBikes = ((StationAnnotation *)annotation).availableBikes;

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
    
    int bikeChange = newAvailableBikes- _avBikes;
    _animLabel.text = bikeChange<0?[NSString stringWithFormat:@"%d",bikeChange]:[NSString stringWithFormat:@"+%d",bikeChange];
    
    [UIView animateWithDuration:0.6
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn |
        UIViewAnimationOptionAllowUserInteraction
                     animations:^{
//                         _animView.alpha = 0.8;
                         _animLabel.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                        
                         [UIView animateWithDuration:0.2 animations:^{
                                _label.alpha =1;
//                             _animView.alpha = 0;
                             _animLabel.alpha =0;
                         } completion:^(BOOL finished) {
                             _label.text = [NSString stringWithFormat:@"%d bikes",newAvailableBikes];
                             _avBikes = newAvailableBikes;

                         }];

                     }];
}
@end
