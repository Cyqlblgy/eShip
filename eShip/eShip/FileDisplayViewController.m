//
//  FileDisplayViewController.m
//  eShip
//
//  Created by Bin Lang on 6/13/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "FileDisplayViewController.h"
#import "BLParams.h"
#import "BLNetwork.h"
#import "SVProgressHUD.h"

@interface FileDisplayViewController ()<UIDocumentInteractionControllerDelegate>

@end

@implementation FileDisplayViewController

@synthesize trackingNumber,labelButton,customButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快递文件";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(goMap)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    labelButton.layer.cornerRadius = 5.0f;
    labelButton.layer.masksToBounds = YES;
    customButton.layer.cornerRadius = 5.0f;
    customButton.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)goMap{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getLabel:(id)sender {
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",BLParameters.NetworkGetLabel,trackingNumber];
    [SVProgressHUD showWithStatus:@"生成快递单中..." maskType:SVProgressHUDMaskTypeGradient];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodGet andrequestType:str andParams:nil andMaxTimeOut:40 andAcceptType:@"application/pdf" andAuthorization:[self getAuthMethod] andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        NSString * newFilePath = [[self documentPath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@_label.pdf",trackingNumber]];
        BOOL isWriteSuccess = [data writeToFile:newFilePath atomically:YES];
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if(res.statusCode == BLNetworkGetLabelSuccess && isWriteSuccess){
            NSURL *URL = [NSURL fileURLWithPath:newFilePath];
            
            if (URL) {
                // Initialize Document Interaction Controller
                UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
                
                // Configure Document Interaction Controller
                [documentInteractionController setDelegate:self];
                
                // Preview PDF
                [documentInteractionController presentPreviewAnimated:YES];
            }
        }
        else{
            UIAlertController * alert1=   [UIAlertController
                                           alertControllerWithTitle:@"出错了"
                                           message:@"PDF生成过程中出错了"
                                           preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok1 = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action){
                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                  }];
            [alert1 addAction:ok1];
            [self presentViewController:alert1 animated:YES completion:nil];
        }
    }];
}

- (IBAction)getCustomFile:(id)sender {
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",BLParameters.NetworkGetCustomFile,trackingNumber];
    [SVProgressHUD showWithStatus:@"生成报关文件中..." maskType:SVProgressHUDMaskTypeGradient];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodGet andrequestType:str andParams:nil andMaxTimeOut:40 andAcceptType:@"application/pdf" andAuthorization:[self getAuthMethod] andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [SVProgressHUD dismiss];
        NSString * newFilePath = [[self documentPath] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@_invoice.pdf",trackingNumber]];
        BOOL isWriteSuccess = [data writeToFile:newFilePath atomically:YES];
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if(res.statusCode == BLNetworkGetCustomFileSuccess && isWriteSuccess){
            NSURL *URL = [NSURL fileURLWithPath:newFilePath];
            
            if (URL) {
                // Initialize Document Interaction Controller
                UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
                
                // Configure Document Interaction Controller
                [documentInteractionController setDelegate:self];
                
                // Preview PDF
                [documentInteractionController presentPreviewAnimated:YES];
            }
        }
        else{
            UIAlertController * alert1=   [UIAlertController
                                           alertControllerWithTitle:@"出错了"
                                           message:@"PDF生成过程中出错了"
                                           preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok1 = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action){
                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                  }];
            [alert1 addAction:ok1];
            [self presentViewController:alert1 animated:YES completion:nil];
        }
    }];
}

- (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return documentPath;
}

- (NSString *)getAuthMethod{
        NSDictionary *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUser"];
        NSString *usrnm = [currentUser valueForKey:@"userName"];
        NSString *pswd= [currentUser valueForKey:@"passWord"];
        NSString *authStr = [[NSString alloc] initWithFormat:@"%@:%@",usrnm,pswd];
        NSData *plainData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64String = [plainData base64EncodedStringWithOptions:0];
        return [[NSString alloc] initWithFormat:@"Basic %@",base64String];
}


#pragma UIDocumentInteractionControllerDelegate implementation
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self.navigationController;
}
@end
