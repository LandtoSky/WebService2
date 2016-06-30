//
//  WebService.h
//  WebServiceSample
//
//  Created by LandtoSky on 6/11/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#import <Foundation/Foundation.h>

#define API_TEST @"http://172.16.1.214:8080/kamiwaza/api/explore_activities"
#define API_DOMAIN @"http://172.16.1.70:8087/"
#define API_BASE_URL @"http://172.16.1.70:8087/api/"
#define API_RESOURCE_BASE_URL @"http://172.16.1.70:8087/upload/"
//APIs

#define API_SIGNIN @"userSignIn"
#define API_SIGNUP @"userSignUp"
#define API_SOCIAL_SIGN @"userSocialSign"
#define API_UPDATE_USER @"updateUserData"

#define API_FORGOT_PASSWORD @"forgotPassword"

#define API_FETCH_SHIRT_LIST @"fetchShirtList"
#define API_POST_SHIRT @"addPost"

#define API_FETCH_RECENT_POST_LIST @"fetchRecentPostList"
#define API_FETCH_POPULAR_POST_LIST @"fetchPopularPostList"
#define API_FETCH_USER_POST @"fetchUserPostList"

#define API_LIKE @"likePost"
#define API_DISLIKE @"dislikePost"
#define API_FETCH_LIKE_LIST @"fetchLikeList"

#define API_COMMENT @"commentToPost"
#define API_FETCH_COMMENT_LIST @"fetchCommentList"

#define API_FETCH_FOLLOWING @"fetchFollowingList"
#define API_FETCH_FOLLOWER @"fetchFollowerList"

#define API_FOLLOW @"followUser"
#define API_UNFOLLOW @"unfollowUser"



#define API_SAVE_SHIRT @"saveShirtToWardrobe"
#define API_FETCH_WARDROBE_SHIRTS @"fetchWardrobeShirtList"

#define API_FETCH_MY_PROFILE @"fetchMyProfile"
#define API_FETCH_USER_PROFILE @"fetchUserProfile"


#define API_DOMAIN @"http://172.16.1.70:8087/"
@interface WebService : NSObject

+(BOOL)isValidMailAddress:(NSString *)strMailAddr;

+ (void) jsonHttlRequest:(NSString*) actionName jsonParam:(NSDictionary*)params withCompletion:(void(^)(NSDictionary * responseDic, NSError * error)) completionHandler;
+ (void) jsonHttlRequest:(NSString*) actionName jsonParam:(NSDictionary*)params withPhotos:(NSArray *)photos withCompletion:(void(^)(NSDictionary * responseDic, NSError * error)) completionHandler;

+(NSURL *)createResourceURL:(NSString *)path;
+(NSString *)fetchDocumentDirectory;

+(void)runAction:(NSString *)actionName withParam:(NSDictionary*) params withCompletion:(void(^)(id result, NSError * error)) completion;

+(void)likePost:(id )post_id withCompletion:(void(^)(NSDictionary * likeDic, NSError * error)) completion;
+(void)dislikePost:(id)post_id withCompletion:(void(^)(id response, NSError * error)) completion;

+(void)fetchFollowingList:(id)user_id withStart:(NSInteger) startPoint withCount:(NSUInteger)count withCompletion:(void(^)(NSArray * followingList, NSError * error)) completion;
+(void)fetchFollowerList:(id)user_id withStart:(NSInteger) startPoint withCount:(NSUInteger)count withCompletion:(void(^)(NSArray * followerList, NSError * error)) completion;

+(void)followUser:(id)owner withCompletion:(void(^)(id response, NSError * error)) completion;
+(void)unfollowUser:(id)owner withCompletion:(void(^)(id response, NSError * error)) completion;




@end
