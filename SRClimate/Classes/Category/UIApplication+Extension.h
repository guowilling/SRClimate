//
//  UIApplication+Extension.h
//  SRClimate
//
//  Created by 郭伟林 on 15/12/29.
//  Copyright © 2015年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extension)

/// "Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL    *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/// "Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL    *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/// "Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL    *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

@end
