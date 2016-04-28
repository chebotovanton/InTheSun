#import <Foundation/Foundation.h>

@class AMAlbumInfoItem;
@class IDMPhoto;

@interface AMAlbumInfoItemsManager : NSObject

@property (nonatomic, strong) NSArray <AMAlbumInfoItem *> *items;
- (NSArray <IDMPhoto *> *)allPhotos;

@end
