//
//  AddBuddiesViewController.h
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBuddiesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * people;
@property (nonatomic, strong) NSMutableArray * buddies;
@property (weak, nonatomic) IBOutlet UITableView *peopleTableView;
@property (weak, nonatomic) id delegate;


@end
