//
//  EmberSnapShot.h
//  bounceapp
//
//  Created by Gabriel Wamunyu on 7/21/16.
//  Copyright © 2016 Anthony Wamunyu Maina. All rights reserved.
//

@import Firebase;
@class EmberUser;

@interface EmberSnapShot : NSObject

@property(strong, nonatomic) NSString *key;

- (instancetype)initWithSnapShot:(FIRDataSnapshot *)snapShot;

-(instancetype)initWithMyEventsSnapShot:(FIRDataSnapshot*)snapShot key:(NSString*)key;
-(void)addMyEventsSnapShot:(FIRDataSnapshot*)snap key:(NSString*)key;

- (instancetype)init;
-(void)addSnapShotToIndex:(FIRDataSnapshot*)snap user:(EmberUser*)user;
-(void)addSnapShotToEnd:(FIRDataSnapshot *)snap user:(EmberUser*)user;
-(NSUInteger)getPrefsLastIndex;

-(instancetype)initWithEventsSnapShot:(FIRDataSnapshot*)snapShot;

-(instancetype)initWithOrgsSnapShot:(FIRDataSnapshot*)snapShot;
-(BOOL)shouldAddOrgsSnapShot:(FIRDataSnapshot*)snap user:(EmberUser*)user;
-(void)addOrgSnap:(FIRDataSnapshot*)snap;
-(void)addOrgToIndex:(FIRDataSnapshot*) snap index:(NSUInteger)index;

-(NSInteger)addIndividualProfileSnapShot:(FIRDataSnapshot*)snap;
-(NSDictionary*)getMediaInfo;
-(NSString*)getMediaInfoKey;


-(FIRDataSnapshot*)getFirebaseSnapShot;
-(BOOL)isEventPoster;
-(NSUInteger)getNoOfBounceSnapShots;
-(EmberSnapShot*)getBounceSnapShotAtIndex:(NSUInteger)index;
-(void)removeSnapShotAtIndex: (NSUInteger)index;
-(void)removeAllSnapShots;
-(void)replaceMediaLinks:(NSArray*)mediaLinks;
-(NSDictionary*)getPostDetails;
-(NSDictionary*)getData;

-(void)reverseBounceSnapShots;
-(void)resetPrefsLastIndex;

@end
