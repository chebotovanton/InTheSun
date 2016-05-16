#import "AMAlbumInfoItemsManager.h"
#import "AMAlbumInfoItem.h"
#import "IDMPhoto.h"

@implementation AMAlbumInfoItemsManager

- (id)init
{
    self = [super init];
    if (self) {
        self.items = [AMAlbumInfoItemsManager createItems];
    }
    return self;
}

- (NSArray <IDMPhoto *> *)allPhotos
{
    NSMutableArray *result = [NSMutableArray new];
    for (AMAlbumInfoItem *item in self.items) {
        UIImage *image = [UIImage imageNamed:item.imageName];
        if (image) {
            IDMPhoto *photo = [IDMPhoto photoWithImage:image];
            [result addObject:photo];
        }
    }
    
    return result;
}

+ (NSArray <AMAlbumInfoItem *> *)createItems
{
    NSMutableArray *result = [NSMutableArray new];

    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_SHAV")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_SHAV")
                                imageName:@"shaveinikov.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_BOND")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_BOND")
                                imageName:@"bondarik.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_PARF")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_PARF")
                                imageName:@"parfenov.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_RUBA")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_RUBA")
                                imageName:@"rubanov.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_KOLO")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_KOLO")
                                imageName:@"kolovski.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_OZER")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_OZER")
                                imageName:@"ozersky.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_VOLK")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_VOLK")
                                imageName:@"volkov.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_FEDO")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_FEDO")
                                imageName:@"fedorov.jpg"]];
    
    [result addObject:[self itemWithTitle:LS(@"LOC_ALBUM_INFO_NAME_GARK")
                                 subtitle:LS(@"LOC_ALBUM_INFO_ROLE_GARK")
                                imageName:@"garkusha.jpg"]];

    return result;
}

+ (AMAlbumInfoItem *)itemWithTitle:(NSString *)title
                          subtitle:(NSString *)subtitle
                         imageName:(NSString *)imageName
{
    AMAlbumInfoItem *item = [AMAlbumInfoItem new];
    item.title = title;
    item.subtitle = subtitle;
    item.imageName = imageName;
    
    return item;
}

@end
