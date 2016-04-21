#import "AMAlbumInfoItemsManager.h"
#import "AMAlbumInfoItem.h"
#import "IDMPhoto.h"
#import "NYTPhoto.h"


@interface AMPhoto : NSObject <NYTPhoto>
@end


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

    [result addObject:[self itemWithTitle:@"Борис Шавейников"
                                 subtitle:@"Барабаны, перкуссия"
                                imageName:@"shaveinikov.jpg"]];
    
    [result addObject:[self itemWithTitle:@"Виктор Бондарик"
                                 subtitle:@"Бас-гитара"
                                imageName:@"bondarik.jpg"]];
    
    [result addObject:[self itemWithTitle:@"Юрий Парфёнов"
                                 subtitle:@"Труба, флюгельгорн, мянкелефинский кларнет, флейта"
                                imageName:@"parfenov.jpg"]];
    
    [result addObject:[self itemWithTitle:@"Николай Рубанов"
                                 subtitle:@"Тенор саксофон, баритон саксофон, сопрано саксофон, бас кларнет, клавишные"
                                imageName:@"rubanov.jpg"]];
    
    [result addObject:[self itemWithTitle:@"Михаил Коловский"
                                 subtitle:@"Туба, диджириду"
                                imageName:@"kolovski.jpg"]];
    
    [result addObject:[self itemWithTitle:@"Дмитрий Озерский"
                                 subtitle:@"Клавишные"
                                imageName:@"ozersky.jpg"]];
    
    [result addObject:[self itemWithTitle:@"Владимир Волков"
                                 subtitle:@"Контрабас, клавишные, виола да гамба, калимба, арфочка, перкуссия"
                                imageName:@"volkov.jpg"]];
    
    [result addObject:[self itemWithTitle:@"Леонид Фёдоров"
                                 subtitle:@"Гитара, вокал, перкуссия, клавишные"
                                imageName:@"fedorov.jpg"]];
    
    [result addObject:[self itemWithTitle:@"ОЛЕГ ГАРКУША"
                                 subtitle:@"Всегда с нами!!!"
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
