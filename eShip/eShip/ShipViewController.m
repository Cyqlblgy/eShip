//
//  ShipViewController.m
//  eShip
//
//  Created by Bin Lang on 6/1/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "ShipViewController.h"
#import "BLNetwork.h"
#import "BLParams.h"

@interface ShipViewController ()

@end

@implementation ShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)ship:(id)sender {
    NSData *plainData = [@"zhouhao:950288" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    NSString *x = [[NSString alloc] initWithFormat:@"Basic %@",base64String];

        NSArray *streetLines1 = [[NSArray alloc] initWithObjects:@"东川路800号", nil];
        NSDictionary *senderAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @"Shanghai",@"city",
                                       @"SH",@"stateOrProvinceCode",
                                       @"200240",@"postalCode",
                                       [NSNull null],@"urbanizationCode",
                                       @"CN",@"countryCode",
                                       [NSNull null],@"countryName",
                                       [NSNumber numberWithBool:NO],@"residential",
                                       streetLines1,@"streetLines",
                                       nil];
        NSArray *streetLines2 = [[NSArray alloc] initWithObjects:@"269 Mill Rd", nil];
        NSDictionary *receiverAddress = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @"Chelmsford",@"city",
                                       @"MA",@"stateOrProvinceCode",
                                       @"01824",@"postalCode",
                                       [NSNull null],@"urbanizationCode",
                                       @"US",@"countryCode",
                                       [NSNull null],@"countryName",
                                       [NSNumber numberWithBool:NO],@"residential",
                                       streetLines2,@"streetLines",
                                       nil];
        NSDictionary *size = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         [NSNumber numberWithInt:108],@"length",
                                         [NSNumber numberWithInt:5],@"width",
                                         [NSNumber numberWithInt:5],@"height",
                                         @"CM",@"units",
                                         nil];
       NSDictionary *weightObject = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"KG",@"value",
                            nil];
        NSDictionary *weight = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:1],@"value",
                              weightObject,@"units",
                              nil];
    
        NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"CNY",@"currency",
                                [NSNumber numberWithFloat:100],@"amount",
                                nil];
    NSDictionary *contact1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Zhang Laosan",@"personName",
                          @"02188888888",@"phoneNumber",
                          @"zls@hotmail.com",@"emailAddress",
                          nil];
    NSDictionary *contact2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"James Cook",@"personName",
                              @"4123560000",@"phoneNumber",
                              nil];
    long long i = (long long)[[NSDate date] timeIntervalSince1970]* 1000.0;
    NSDictionary *responsibleParty = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"510087682",@"accountNumber",
                               contact1,@"contact",
                               senderAddress,@"address",
                               nil];
    NSDictionary *dutyPayor = [[NSDictionary alloc] initWithObjectsAndKeys:
                                responsibleParty,@"responsibleParty",
                              nil];
    NSDictionary *commodity = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:1],@"numberOfPieces",
                               @"China",@"countryOfManufacture",
                               @"Books",@"description",
                               weight, @"weight",
                               [NSNumber numberWithInt:1],@"quantity",
                               @"EA",@"quantityUnits",
                               value,@"unitPrice",
                               value,@"customsValue",
                               nil];
    NSArray *commodities = [[NSArray alloc] initWithObjects:commodity, nil];
    
    
    /*Unnecessary customerRefrence*/
    
    NSDictionary *customerReference1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"CUSTOMER_REFERENCE",@"customerReferenceType",
                                        @"CR1234", @"value",
                                        nil];
    NSDictionary *customerReference2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"INVOICE_NUMBER",@"customerReferenceType",
                                        @"IV1234", @"value",
                                        nil];
    NSDictionary *customerReference3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"P_O_NUMBER",@"customerReferenceType",
                                        @"PO1234", @"value",
                                        nil];
    NSArray *customerReferences = [[NSArray alloc] initWithObjects:customerReference1,customerReference2,customerReference3, nil];
    
    
    NSDictionary *packageLineitem = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:1],@"sequenceNumber",
                               [NSNumber numberWithInt:1],@"groupPackageCount",
                               weight,@"weight",
                               size,@"dimensions",
                             //  customerReferences,@"customerReferences",
                               nil];
    NSArray *packageLineitems = [[NSArray alloc] initWithObjects:packageLineitem, nil];
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"Fedex",@"carrier",
                                    [NSNumber numberWithLongLong:i],@"shipDate",
                                    @"INTERNATIONAL_PRIORITY",@"serviceType",
                                    @"REGULAR_PICKUP",@"dropoffType",
                                    @"YOUR_PACKAGING",@"packagingType",
                                    contact1,@"senderContact",
                                    senderAddress,@"senderAddress",
                                    contact2,@"recipientContact",
                                    receiverAddress,@"recipientAddress",
                                    @"510087682",@"accountNumber",
                                    @"SENDER", @"paymentType",
                                    [NSNull null], @"responsibleParty",
                                    @"SENDER", @"dutyPaymentType",
                                    dutyPayor, @"dutyPayor",
                                    value, @"customValue",
                                    @"NON_DOCUMENTS",@"documentContentType",
                                    commodities, @"commodities",
                                    [NSNumber numberWithInt:1],@"packageNum",
                                    packageLineitems,@"packageLineItems",
                                    nil];
    [BLNetwork urlConnectionRequest:BLParameters.NetworkHttpMethodPost andrequestType:BLParameters.NetworkShip andParams:jsonDictionary andMaxTimeOut:40 andAcceptType:nil andAuthorization:x andResponse:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        NSData *wwww= data;
//        if(res.statusCode == BLNetworkRateSuccess){
//            rateResults = [NSJSONSerialization JSONObjectWithData:data
//                                                          options:NSJSONReadingMutableContainers
//                                                            error:&e];
//            if(rateResults.count != 0){
//                [self performSegueWithIdentifier:@"checkIdentifier" sender:self];
//            }
//        }
    }];

}
@end
