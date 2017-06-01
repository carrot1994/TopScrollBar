//
//  AppDelegate.h
//  TopScrollBar
//
//  Created by 周恩慧 on 2017/6/1.
//  Copyright © 2017年 周恩慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

