//
//  WebService.m
//  WebServiceSample
//
//  Created by LandtoSky on 6/11/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#import "WebService.h"
#import <AFNetworking.h>
//#import "JSON.h"

@implementation WebService



+(BOOL)isValidMailAddress:(NSString *)strMailAddr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strMailAddr];
}

// API Request

+ (void) jsonHttlRequest:(NSString*) actionName jsonParam:(NSDictionary*)params withCompletion:(void(^)(NSDictionary * responseDic, NSError * error)) completionHandler
{
//    NSString * urlStr = [NSString stringWithFormat:@"%@%@", API_BASE_URL, actionName];
    NSString *urlStr = actionName;
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"123456789" forHTTPHeaderField:@"api-key"];
    
   
    
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
  


    
    if (!([actionName isEqualToString:API_SIGNUP] || [actionName isEqualToString:API_SIGNIN] || [actionName isEqualToString:API_FORGOT_PASSWORD] || [actionName isEqualToString:API_SOCIAL_SIGN])) {
        NSMutableDictionary * tempDic;
        if (params == nil) {
            tempDic = [NSMutableDictionary dictionary];
        }else{
            tempDic= [NSMutableDictionary dictionaryWithDictionary:params];
        }
        
//        [tempDic setObject:[User sharedInstance].strToken forKey:@"token"];
        params = tempDic;
    }
    NSLog(@"Params ==> %@", params);
    NSLog(@"Action Name :%@", urlStr);
    
    
    
        
    
    [manager POST:urlStr parameters:params
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              if (responseObject == nil) {
                  NSDictionary * details = [[NSDictionary alloc] initWithObjectsAndKeys:@"No Data!", NSLocalizedDescriptionKey, nil];
                  NSError * temp_error = [[[NSError alloc] init] initWithDomain:@"App" code:200 userInfo:details];
                  completionHandler(nil, temp_error);
              }else{
                  
                  NSData* data = (NSData*)responseObject;
                  NSError* error = nil;
                  NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                  NSLog(@"POST success : %@", dict);
                  
                  completionHandler(dict, nil);
//                  NSLog(@"%@", responseObject);
              }
              
          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              NSLog(@"Error = %@", [error description]);
              completionHandler(nil, error);
          }];
    
}

+ (void) jsonHttlRequest:(NSString*) actionName jsonParam:(NSDictionary*)params withPhotos:(NSArray *)photos withCompletion:(void(^)(NSDictionary * responseDic, NSError * error)) completionHandler {
    NSString * urlStr = [NSString stringWithFormat:@"%@%@", API_BASE_URL, actionName];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSMutableDictionary * tempDic;
    if (params == nil) {
        tempDic = [NSMutableDictionary dictionary];
    }else{
        tempDic= [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
//    [tempDic setObject:[User sharedInstance].strToken forKey:@"token"];
    params = tempDic;
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (photos != nil) {
            for (NSDictionary * photoDic in photos) {
                [formData appendPartWithFileData:[photoDic objectForKey:@"imageData"] name:[photoDic objectForKey:@"name"] fileName:@"temp.png" mimeType:@"image/png"];
            }
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject == nil) {
            NSDictionary * details = [[NSDictionary alloc] initWithObjectsAndKeys:@"No Data!", NSLocalizedDescriptionKey, nil];
            NSError * temp_error = [[[NSError alloc] init] initWithDomain:@"App" code:200 userInfo:details];
            completionHandler(nil, temp_error);
        }else{
            
            completionHandler(responseObject, nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completionHandler(nil, error);
    }];
    
}

+(void)runAction:(NSString *)actionName withParam:(NSDictionary*) params withCompletion:(void(^)(id result, NSError * error)) completion{
    
    [WebService jsonHttlRequest:actionName jsonParam:params withCompletion:^(NSDictionary *responseDic, NSError *error) {
        
        if (!error) {
            NSInteger statusCode = [responseDic[@"code"] integerValue];
            
            if (statusCode == 1) {
                completion(responseDic[@"response"], nil);
            }else{
                
                NSError * temp_error = [[[NSError alloc] init] initWithDomain:@"App" code:200 userInfo:responseDic[@"msg"]];
                completion(nil, temp_error);
            }
        }else{
            completion(nil, error);
        }
    }];
    
    
}


+(NSURL *)createResourceURL:(NSString *)path{
    if (path == nil || [path isEqualToString:@""]) {
        return nil;
    }
    
    NSString * tempPath = [NSString stringWithFormat:@"%@%@", API_RESOURCE_BASE_URL, path ];
    return [NSURL URLWithString:tempPath];
}


+(NSString *)fetchDocumentDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}


// Like Post

+(void)likePost:(id)post_id withCompletion:(void(^)(NSDictionary * likeDic, NSError * error)) completion
{
    NSDictionary * params = @{@"post_id": post_id};
    [WebService runAction:API_LIKE withParam:params withCompletion:completion];
}


+(void)dislikePost:(id)post_id withCompletion:(void(^)(id response, NSError * error)) completion
{
    NSDictionary * params = @{@"post_id": post_id};
    
    [WebService runAction:API_DISLIKE withParam:params withCompletion:completion];
}

+(void)fetchFollowingList:(id)user_id withStart:(NSInteger) startPoint withCount:(NSUInteger)count withCompletion:(void(^)(NSArray * followingList, NSError * error)) completion
{
    NSDictionary * params = @{@"user_id": user_id,
                              @"start_point":[NSNumber numberWithInteger:startPoint],
                              @"count":[NSNumber numberWithInteger:count]
                              };
    
    [WebService runAction:API_FETCH_FOLLOWING withParam:params withCompletion:completion];
}


+(void)fetchFollowerList:(id)user_id withStart:(NSInteger) startPoint withCount:(NSUInteger)count withCompletion:(void(^)(NSArray * followerList, NSError * error)) completion{
    
    NSDictionary * params = @{@"user_id": user_id,
                              @"start_point":[NSNumber numberWithInteger:startPoint],
                              @"count":[NSNumber numberWithInteger:count]
                              };
    
    [WebService runAction:API_FETCH_FOLLOWER withParam:params withCompletion:completion];
}


+(void)followUser:(id)owner withCompletion:(void(^)(id response, NSError * error)) completion
{
    NSDictionary * params = @{@"owner": owner};
    [WebService runAction:API_FOLLOW withParam:params withCompletion:completion];
}

+(void)unfollowUser:(id)owner withCompletion:(void(^)(id response, NSError * error)) completion
{
    NSDictionary * params = @{@"owner": owner};
    [WebService runAction:API_UNFOLLOW withParam:params withCompletion:completion];
}

+(void)test:(id)owner withCompletion:(void(^)(id response, NSError * error)) completion
{
    NSDictionary * params = @{};
    [WebService runAction:API_UNFOLLOW withParam:params withCompletion:completion];
}
@end
