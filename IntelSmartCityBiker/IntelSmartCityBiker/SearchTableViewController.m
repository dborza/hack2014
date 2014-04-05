//
//  SearchTableViewController.m
//  IntelCityBiker
//
//  Created by Iustina Gligor on 4/4/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "SearchTableViewController.h"
#import "BikeSearchCriteria.h"
//#import "MapViewController.h"

@interface SearchTableViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *ColorPickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *GenderSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *TypeSegment;
@property (weak, nonatomic) IBOutlet UISwitch *ShoppingBasketSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *ChildSeatSwitch;


@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorWSArray;
@end

@implementation SearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.colorArray = @[ @"Red",@"Blue",@"Dark Blue",@"Light Blue", @"Orange",@"Yellow",@"Green"];
    self.colorWSArray = @[ @"Red",@"Blue",@"DarkBlue",@"LightBlue", @"Orange",@"Yellow",@"Green"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Color Picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_colorArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _colorArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)findBikeTapped:(id)sender {
    if (_delegate)
    {
        BikeSearchCriteria *searchCriteria = [[BikeSearchCriteria alloc]init];

        if (_GenderSegment.selectedSegmentIndex >0)
        {
         searchCriteria.gender = [_GenderSegment titleForSegmentAtIndex:_GenderSegment.selectedSegmentIndex];
        }
        
        switch (_TypeSegment.selectedSegmentIndex) {
            case 0:
                break;
            case 1:
                searchCriteria.type =@"CityBike";
                break;
            case 2:
                searchCriteria.type =@"MountainBike";
                break;
                
            default:
                break;
        }

        searchCriteria.color = [_colorWSArray objectAtIndex:[_ColorPickerView selectedRowInComponent:0]];
        searchCriteria.shoppingBasket = _ShoppingBasketSwitch.on;
        searchCriteria.childrenSeat = _ChildSeatSwitch.on;
        
        if (_delegate && [_delegate respondsToSelector:@selector(search:)])
        {
            [_delegate performSelector:@selector(search:) withObject:searchCriteria];
        }
    //    [self.tabBarController setSelectedIndex:0];
    }
}
- (IBAction)CancelButtonTapped:(id)sender {
    if (self.tabBarController)
    {
  //      [self.tabBarController setSelectedIndex:0];
    }
}
@end
