//
//  Webservice.m
//  DictionaryOfAb
//
//  Created by ivcmbp022adm on 3/8/16.
//  Copyright © 2016 NehaKallem. All rights reserved.
//

#import "Webservice.h"
#import "AFNetworking.h"


@implementation Webservice

+(Webservice*) sharedInstance {
    static dispatch_once_t token;
    static Webservice* sharedManager;
    dispatch_once(&token, ^ {
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (AFHTTPSessionManager *) createJSONSessionManagerForURL:(NSURL*) url {
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    //for some reason the API is returning the header as text/html
    AFHTTPRequestSerializer *jsonRequestSerializer = [AFHTTPRequestSerializer serializer];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    sessionManager.requestSerializer = jsonRequestSerializer;
    sessionManager.responseSerializer = jsonResponseSerializer;
    return sessionManager;
}

- (void) fetchAbbreviation:(NSString*) sf
                 completionHandler: (void(^)(NSError *, NSArray<NSString*> *)) completionHandler{
    NSMutableArray <NSString*>* fullforms = [NSMutableArray arrayWithArray:@[]];
    
    NSURL *apiURL = [NSURL URLWithString:@"http://www.nactem.ac.uk/software/acromine/dictionary.py"];
    AFHTTPSessionManager *manager = [self createJSONSessionManagerForURL:apiURL];
    [manager GET:@"" parameters:@{@"sf":sf} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray* response = (NSArray *) responseObject;
        if(response.count < 1){
            NSLog(@"Empty dataset");
            [fullforms addObject:@"No Results found"];
        }
        else {
            NSDictionary* firstResult = response[0];
            NSArray *results = firstResult[@"lfs"];
            for(NSDictionary* result in results){
                NSString* fullForm = result[@"lf"];
                [fullforms addObject:fullForm];
            }
        }
        completionHandler(nil, fullforms);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [fullforms addObject:@"Error occurred"];
        completionHandler(error, fullforms);
    }];
}

@end
