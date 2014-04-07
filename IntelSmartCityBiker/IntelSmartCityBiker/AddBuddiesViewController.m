//
//  AddBuddiesViewController.m
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "AddBuddiesViewController.h"
#import "People.h"

@interface AddBuddiesViewController ()

@end

@implementation AddBuddiesViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (bool) isPersonABuddy: (People *) pers
{
    for (People *buddy in _buddies)
    {
        if (buddy.persID == pers.persID)
        {
            return YES;
        }
    }
    return NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_people count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * peopleCell = @"peopleCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:peopleCell];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:peopleCell];
    }
    People * person = (People *)[_people objectAtIndex:indexPath.row];
    cell.textLabel.text = [person fullName];
    cell.accessoryType = [self isPersonABuddy:person]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegate && [_delegate respondsToSelector:@selector(addABuddy:)])
    {
        [_delegate performSelector:@selector(addABuddy:) withObject:[_people objectAtIndex:indexPath.row]];
    }
}



@end
