//
//  SearchTableViewController.h
//  IntelCityBiker
//
//  Created by Iustina Gligor on 4/4/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource>
- (IBAction)findBikeTapped:(id)sender;
- (IBAction)CancelButtonTapped:(id)sender;

@property (nonatomic, weak) id delegate;
@end
