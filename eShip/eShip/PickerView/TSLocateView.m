//
//  UICityPicker.m
//

#import "TSLocateView.h"

#define kDuration 0.3

@implementation TSLocateView

@synthesize titleLabel;
@synthesize locatePicker;
@synthesize address;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        countries = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AddressList.plist" ofType:nil]];
        provinces = [[countries objectAtIndex:0] objectForKey:@"States"];
        cities = [[provinces objectAtIndex:0] objectForKey:@"Cities"];
        address = [[BLAddressObject alloc] init];
        address.country = [[countries objectAtIndex:0] objectForKey:@"Country"];
        address.state = [[provinces objectAtIndex:0] objectForKey:@"State"];
        address.city = [[cities objectAtIndex:0] objectForKey:@"city"];
        address.countryCode = [[countries objectAtIndex:0] objectForKey:@"CountryCode"];
        if([[provinces objectAtIndex:0] objectForKey:@"ProvinceCode"]){
            address.provinceCode = [[provinces objectAtIndex:0] objectForKey:@"ProvinceCode"];
        }
        else{
            address.provinceCode = [[cities objectAtIndex:0] objectForKey:@"ProvinceCode"];
        }
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, view.frame.size.width, self.frame.size.height);
    self.pickButton.frame = CGRectMake(self.frame.size.width-52, self.pickButton.frame.origin.y, 42, self.pickButton.frame.size.height);
    [view addSubview:self];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        CGRect frame;
        switch (component) {
            case 0:
                tView.text = [[countries objectAtIndex:row] objectForKey:@"Country"];
                tView.textAlignment = NSTextAlignmentCenter;
                frame = CGRectMake(0, 0, 80, 40);
                break;
            case 1:
                tView.text = [[provinces objectAtIndex:row] objectForKey:@"State"];
                tView.textAlignment = NSTextAlignmentCenter;
                frame = CGRectMake(0, 0, 120, 40);
                break;
            case 2:
                tView.text = [[cities objectAtIndex:row] objectForKey:@"city"];
                tView.textAlignment = NSTextAlignmentCenter;
                frame = CGRectMake(0, 0, 120, 40);
                break;
            default:
                return nil;
                break;
        }
        tView.frame = frame;
    }
    return tView;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [countries count];
            break;
        case 1:
            return [provinces count];
            break;
        case 2:
            return [cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[countries objectAtIndex:row] objectForKey:@"Country"];
            break;
        case 1:
            return [[provinces objectAtIndex:row] objectForKey:@"State"];
            break;
        case 2:
            return [[cities objectAtIndex:row] objectForKey:@"city"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            provinces = [[countries objectAtIndex:row] objectForKey:@"States"];
            cities = [[provinces objectAtIndex:0] objectForKey:@"Cities"];
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker reloadComponent:1];
            [self.locatePicker reloadComponent:2];
            address.country = [[countries objectAtIndex:row] objectForKey:@"Country"];
            address.state = [[provinces objectAtIndex:0] objectForKey:@"State"];
            address.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            address.countryCode = [[countries objectAtIndex:row] objectForKey:@"CountryCode"];
            if([[provinces objectAtIndex:0] objectForKey:@"ProvinceCode"]){
                address.provinceCode = [[provinces objectAtIndex:0] objectForKey:@"ProvinceCode"];
            }
            else{
                address.provinceCode = [[cities objectAtIndex:0] objectForKey:@"ProvinceCode"];
            }
            break;
        case 1:
            cities = [[provinces objectAtIndex:row] objectForKey:@"Cities"];
            [self.locatePicker selectRow:0 inComponent:2 animated:NO];
            [self.locatePicker reloadComponent:2];
            address.state = [[provinces objectAtIndex:row] objectForKey:@"State"];
            address.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            if([[provinces objectAtIndex:row] objectForKey:@"ProvinceCode"]){
                address.provinceCode = [[provinces objectAtIndex:row] objectForKey:@"ProvinceCode"];
            }
            else{
                address.provinceCode = [[cities objectAtIndex:0] objectForKey:@"ProvinceCode"];
            }
            break;
        case 2:
            address.city = [[cities objectAtIndex:row] objectForKey:@"city"];
            if([[cities objectAtIndex:row] objectForKey:@"ProvinceCode"]){
                address.provinceCode = [[cities objectAtIndex:row] objectForKey:@"ProvinceCode"];
            }
            break;
        default:
            break;
    }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}

@end
