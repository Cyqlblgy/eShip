// LeftViewController.m
// KitchenSink
//
// Copyright (c) 2014 Jon Danao (danao.org | jondanao)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "LeftViewController.h"
#import "TheSidebarController.h"
#import "LeftTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@interface LeftViewController(){
    NSArray *menuItems;
    NSArray *imageNames;
    NSArray *vcNames;
}

- (void)dismissThisViewController;

@end



@implementation LeftViewController

@synthesize logoButton,mytableView,nameLabel;

- (void)viewDidLoad
{
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissThisViewController)];
//    [self.view addGestureRecognizer:tapGesture];
    menuItems = @[@"地图", @"查件", @"我的", @"设置"];
    imageNames = @[@"Map.png",@"track.png",@"login.png",@"Mine.png"];
    vcNames = @[@"findVC",@"MineVC",@"SettingsVC"];
    CGRect frame = mytableView.frame;
    mytableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50*menuItems.count);
}

- (void)viewWillAppear:(BOOL)animated{
    logoButton.imageView.layer.cornerRadius = 50;
    logoButton.imageView.clipsToBounds = YES;
    nameLabel.text = @"coolboy";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShipCell"];
    
    if (cell == nil) {
        cell = (LeftTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"LeftTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.label.text = [menuItems objectAtIndex:indexPath.row];
    cell.leftimageView.image = [UIImage imageNamed:[imageNames objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.sidebarController dismissSidebarViewController];
    if(indexPath.row != 0){
    UINavigationController *contentNC = (UINavigationController *)self.sidebarController.contentViewController;
    [contentNC pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:[vcNames objectAtIndex:indexPath.row-1]] animated:NO];
    }
 //   [self.sidebarController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"findVC"]];
}

- (void)dismissThisViewController
{
    [self.sidebarController dismissSidebarViewController];
}

@end