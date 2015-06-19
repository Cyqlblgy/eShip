//
//  ItemViewController.m
//  eShip
//
//  Created by Bin Lang on 5/27/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//
#define kTabBarHeight 0

#import "ItemViewController.h"
#import "CheckPriceViewController.h"

@interface ItemViewController (){
}

@end

@implementation ItemViewController

@synthesize longthTextField,heightTextField,widthTextField,priceTextField,weightTextField,lengthSegment,priceSegment,weightSegment,weightLabel,widthLabel,heightLabel,longLabel,rateObject,myScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"寄件地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndgoBack)];
    CGRect frame = weightLabel.frame;
    longthTextField.frame =  CGRectMake(frame.origin.x, longthTextField.frame.origin.y, frame.size.width/3, longthTextField.frame.size.height);
    longLabel.frame = CGRectMake(longthTextField.frame.origin.x, longLabel.frame.origin.y, longthTextField.frame.size.width, longLabel.frame.size.height);
    widthTextField.frame = CGRectMake(frame.origin.x + frame.size.width/3, widthTextField.frame.origin.y, frame.size.width/3, widthTextField.frame.size.height);
    widthLabel.frame = CGRectMake(widthTextField.frame.origin.x, widthLabel.frame.origin.y, widthTextField.frame.size.width, widthLabel.frame.size.height);
    heightTextField.frame = CGRectMake(frame.origin.x + frame.size.width*2/3, heightTextField.frame.origin.y, frame.size.width/3, heightTextField.frame.size.height);
    heightLabel.frame = CGRectMake(heightTextField.frame.origin.x, heightLabel.frame.origin.y, heightTextField.frame.size.width, heightLabel.frame.size.height);
    weightTextField.frame = CGRectMake(weightTextField.frame.origin.x, weightTextField.frame.origin.y, frame.size.width/2, weightTextField.frame.size.height);
    priceTextField.frame = CGRectMake(priceTextField.frame.origin.x, priceTextField.frame.origin.y, frame.size.width/2, priceTextField.frame.size.height);
    priceSegment.frame = CGRectMake(priceTextField.frame.origin.x + priceTextField.frame.size.width + 10, priceSegment.frame.origin.y,priceSegment.frame.size.width, priceSegment.frame.size.height);
    weightSegment.frame = CGRectMake(weightTextField.frame.origin.x + weightTextField.frame.size.width + 10, weightSegment.frame.origin.y,weightSegment.frame.size.width, weightSegment.frame.size.height);
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    button.layer.cornerRadius = 4.0;
    button.frame= CGRectMake(0.0, 0.0, 60, 35);
    [button addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flex,doneButton, nil]];
    longthTextField.inputAccessoryView = keyboardDoneButtonView;
    widthTextField.inputAccessoryView = keyboardDoneButtonView;
    heightTextField.inputAccessoryView = keyboardDoneButtonView;
    weightTextField.inputAccessoryView = keyboardDoneButtonView;
    priceTextField.inputAccessoryView = keyboardDoneButtonView;
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAndgoBack{
    if([longthTextField.text isEqualToString:@""] || [widthTextField.text isEqualToString:@""] || [heightTextField.text isEqualToString:@""] || [weightTextField.text isEqualToString:@""] || [priceTextField.text isEqualToString:@""]){
        UIAlertController *alert =   [UIAlertController
                                      alertControllerWithTitle:@"信息不完全"
                                      message:@"请保证完成必填信息再保存"
                                      preferredStyle:UIAlertControllerStyleAlert];;
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
    NSDictionary *size = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithInt:longthTextField.text.intValue],@"length",
                          [NSNumber numberWithInt:widthTextField.text.intValue],@"width",
                          [NSNumber numberWithInt:heightTextField.text.intValue],@"height",
                          [lengthSegment titleForSegmentAtIndex:lengthSegment.selectedSegmentIndex],@"unit",
                             nil];
    NSDictionary *weight = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInt:weightTextField.text.intValue],@"weight",
                            [weightSegment titleForSegmentAtIndex:weightSegment.selectedSegmentIndex],@"unit",
                            nil];
    NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [priceSegment titleForSegmentAtIndex:priceSegment.selectedSegmentIndex],@"currency",
                           [NSNumber numberWithFloat:priceTextField.text.floatValue],@"amount",
                           nil];
    rateObject.size = size;
    rateObject.weight = weight;
    rateObject.value = value;
    NSArray *arrayViewControllers = [self.navigationController viewControllers];
    CheckPriceViewController *vc = (CheckPriceViewController *)[arrayViewControllers objectAtIndex:arrayViewControllers.count-1];
    vc.rateObject = rateObject;
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    NSDictionary * sizeDic = rateObject.size;
    if(sizeDic){
        longthTextField.text = [[sizeDic valueForKey:@"length"] stringValue];
        widthTextField.text = [[sizeDic valueForKey:@"width"] stringValue];
        heightTextField.text = [[sizeDic valueForKey:@"height"] stringValue];
        NSString *unit = [sizeDic valueForKey:@"unit"];
        for (int i = 0; i<lengthSegment.subviews.count; i++) {
            if([[lengthSegment titleForSegmentAtIndex:i] isEqualToString:unit]){
                [lengthSegment setSelectedSegmentIndex:i];
            }
        }
    }
    NSDictionary * weightDic = rateObject.weight;
    if(weightDic){
        weightTextField.text = [[weightDic valueForKey:@"weight"] stringValue];
        NSString *unit = [weightDic valueForKey:@"unit"];
        for (int i = 0; i<weightSegment.subviews.count; i++) {
            if([[weightSegment titleForSegmentAtIndex:i] isEqualToString:unit]){
                [weightSegment setSelectedSegmentIndex:i];
            }
        }
    }
    NSDictionary * valueDic = rateObject.value;
    if(valueDic){
        priceTextField.text = [[valueDic valueForKey:@"amount"] stringValue];
        NSString *unit = [valueDic valueForKey:@"currency"];
        for (int i = 0; i<priceSegment.subviews.count; i++) {
            if([[priceSegment titleForSegmentAtIndex:i] isEqualToString:unit]){
                [priceSegment setSelectedSegmentIndex:i];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TextFieldDelegate implementation

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField: textField up: YES];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = textField.frame.origin.y / 2; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
