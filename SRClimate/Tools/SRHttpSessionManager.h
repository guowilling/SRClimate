
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface SRHTTPSessionManager : AFHTTPSessionManager

+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
