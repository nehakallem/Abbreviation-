//
//  Webservice.h
//  DictionaryOfAb
//
//  Created by ivcmbp022adm on 3/8/16.
//  Copyright © 2016 NehaKallem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Webservice : NSObject

+(Webservice*) sharedInstance;

- (void) fetchAbbreviation:(NSString*) shortForm
                 completionHandler: (void(^)(NSError *, NSArray<NSString*> *)) completionHandler;

@end
