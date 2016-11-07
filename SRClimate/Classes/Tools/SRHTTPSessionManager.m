
#import "SRHTTPSessionManager.h"

@implementation SRHTTPSessionManager

+ (SRHTTPSessionManager *)sharedManager {
    
    static SRHTTPSessionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SRHTTPSessionManager alloc] initWithBaseURL:nil];
    });
    return sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer.timeoutInterval = 15.0;
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        [self.requestSerializer setValue:@"c6900d83e40cc69a52c8ca446c1b3176" forHTTPHeaderField:@"apikey"];
    }
    return self;
}

+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    SRLog(@"URL: %@", URLString);
    SRLog(@"parameters: %@", parameters);
    
    if (!URLString || URLString.length <= 0) {
        return;
    }
    URLString = [URLString stringByRemovingPercentEncoding];
    
    [[self sharedManager] GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        SRLog(@"%@ responseObject: %@", URLString, responseObject);
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SRLog(@"%@ error: %@", URLString, error);
        if (failure) {
            failure(task, error);
        }
    }];
}

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    SRLog(@"URL: %@", URLString);
    SRLog(@"parameters: %@", parameters);
    
    if (!URLString || URLString.length <= 0) {
        return;
    }
    URLString = [URLString stringByRemovingPercentEncoding];
    
    [[self sharedManager] POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        SRLog(@"%@ responseObject: %@", URLString, responseObject);
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        SRLog(@"%@ error: %@", URLString, error);
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
