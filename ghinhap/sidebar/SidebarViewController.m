//
//  SidebarViewController.m
//  ghinhap
//
//  Created by Quang Phuong on 7/19/15.
//  Copyright © 2015 fsoft. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "TableCell.h"
#import "NhapItem.h"
#import "NhapItemDAO.h"

@interface SidebarViewController ()

- (void)getAllData;

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nhapList = [[NSMutableArray alloc]init];
    
    [self getAllData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithNotification:) name:@"RefreshSidebarView" object:nil];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetBadge" object:nil userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.nhapList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableCell *cell =[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    if ((cell==nil) || (![cell isKindOfClass: TableCell.class]))
    {
        [tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil] forCellReuseIdentifier:@"tableCell"];
        
        cell = (TableCell *) [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(TableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NhapItem *nhapItem = [self.nhapList objectAtIndex:indexPath.row];
    
    cell.nhapName.text = nhapItem.name;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    cell.createDate.text = [dateFormat stringFromDate:nhapItem.createDate];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // rows in section 0 should not be selectable
//    if ( indexPath.row == 0 ) return nil;
    
    return indexPath;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NhapItem *nhapItem = [self.nhapList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"reloadWebview" sender:nhapItem.name];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getAllData{
    NhapItemDAO *dao = [[NhapItemDAO alloc]init];
    self.nhapList = [dao getAllData];
}

- (void)refreshTableWithNotification:(NSNotification *)notification
{
    [self getAllData];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"reloadWebview"]){
        ViewController *viewController = segue.destinationViewController;
        viewController.currentNhap = sender;
    }
}

@end
