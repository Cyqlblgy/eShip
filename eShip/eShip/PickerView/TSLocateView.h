//
//  UICityPicker.h
//
//
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BLAddressObject.h"

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
    NSArray *provinces;
    NSArray	*cities;
    NSArray *countries;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (weak, nonatomic) IBOutlet UIButton *pickButton;
@property (strong, nonatomic) BLAddressObject *address;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;

- (IBAction)cancel:(id)sender;

@end
