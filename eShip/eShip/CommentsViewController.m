//
//  CommentsViewController.m
//  eShip
//
//  Created by Bin Lang on 6/4/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "CommentsViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"

@interface CommentsViewController ()<UIDocumentInteractionControllerDelegate>{
    BOOL isShown;
}

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShown = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    if(isShown){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
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
- (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return documentPath;
}



- (IBAction)getLabel:(id)sender {
    NSData *plainData = [@"zhouhao:950288" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",BLParameters.NetworkGetLabel,@"794641319407"];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodGet andrequestType:str andParams:nil andMaxTimeOut:40 andAcceptType:@"application/pdf" andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString * newFilePath = [[self documentPath] stringByAppendingPathComponent:@"name.pdf"];
        BOOL isWriteSuccess = [data writeToFile:newFilePath atomically:YES];
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if(res.statusCode == 200 && isWriteSuccess){
            NSURL *URL = [NSURL fileURLWithPath:newFilePath];
            
            if (URL) {
                isShown = YES;
                // Initialize Document Interaction Controller
                UIDocumentInteractionController *documentInteractionController = [[UIDocumentInteractionController alloc] init];
                documentInteractionController.URL = URL;
                
                // Configure Document Interaction Controller
                [documentInteractionController setDelegate:self];
                
                // Preview PDF
                [documentInteractionController presentPreviewAnimated:YES];
            }
        }
     }];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self.navigationController;
}

@end
