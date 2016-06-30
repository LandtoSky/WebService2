//
//  ServiceVC.m
//  WebServiceSample
//
//  Created by LandtoSky on 6/11/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#import "ServiceVC.h"
#import "WebService.h"

@interface ServiceVC ()

@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onTestRequest:(id)sender
{
    MBProgressHUD * hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Data...";
    NSDictionary *params = @{
                             @"last_activity_id":@(0),
                             @"user_id":@(26),
                             @"category_id":@(0)

                             };
    
    [WebService jsonHttlRequest:API_TEST jsonParam:params withCompletion:^(NSDictionary *responseDic, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            NSInteger statusCode = [responseDic[@"status"] integerValue];
            NSLog(@"response ==> %@", responseDic);
            
            if (statusCode == 1) {
                NSDictionary * shirtData = responseDic[@"response"];
//                self.menShirts = [shirtData objectForKey:@"men"];
//                self.womenShirts = [shirtData objectForKey:@"women"];
                
//                [menCollectionView reloadData];
//                [womenColle/ctionView reloadData];
//                
            }else{
//                [CommonUtil showAlertView:@"Alert!" withMessage:responseDic[@"msg"]];
            }
        }else{
//            [CommonUtil showAlertView:@"Alert!" withMessage:error.localizedDescription];
        }
    }];

    
}

@end
