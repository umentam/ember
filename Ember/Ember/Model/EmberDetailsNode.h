//
//  EmberDetailsNode.h
//  bounceapp
//
//  Created by Gabriel Wamunyu on 8/19/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AsyncDisplayKit/ASVideoNode.h>
#import <UIKit/UIKit.h>
#import "EmberSnapShot.h"
@import Firebase;

@protocol OrgImageClickedDelegate;

@interface EmberDetailsNode : ASCellNode


@property(strong, nonatomic) FIRDatabaseReference *ref;
@property(nonatomic, assign) BOOL isVideo;
@property (nonatomic, weak) id<OrgImageClickedDelegate> delegate;

- (instancetype)initWithEvent:(EmberSnapShot *)event;

-(ASTextNode *) getTextNode;
-(ASTextNode *)getDateTextNode;
-(ASButtonNode *)getButtonNode;
- (NSDictionary *)textStyle;
-(void)setFollowButtonHidden;
-(ASNetworkImageNode*)getOrgProfilePhotoNode;
-(ASTextNode*)getUserNameNode;
-(void)showFireCount;
-(void)setIsPoster:(BOOL)isPoster;


@end

@protocol OrgImageClickedDelegate <NSObject>

-(void)orgClicked:(NSString*)orgId;


@end

