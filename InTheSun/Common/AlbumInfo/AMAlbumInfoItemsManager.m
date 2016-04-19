#import "AMAlbumInfoItemsManager.h"
#import "AMAlbumInfoItem.h"

@implementation AMAlbumInfoItemsManager

+ (NSArray <AMAlbumInfoItem *> *)createItems
{
    NSMutableArray *result = [NSMutableArray new];

    [result addObject:[self itemWithTitle:@"Борис Шавейников"
                                 subtitle:@"Барабаны, перкуссия"
                                imageName:nil]];
    
    [result addObject:[self itemWithTitle:@"Виктор Бондарик"
                                 subtitle:@"Бас-гитара"
                                imageName:nil]];
    
    [result addObject:[self itemWithTitle:@"Юрий Парфёнов"
                                 subtitle:@"Труба, флюгельгорн, мянкелефинский кларнет, флейта"
                                imageName:nil]];
    
    [result addObject:[self itemWithTitle:@"Николай Рубанов"
                                 subtitle:@"Тенор саксофон, баритон саксофон, сопрано саксофон, бас кларнет, клавишные"
                                imageName:nil]];
    
    [result addObject:[self itemWithTitle:@"Михаил Коловский"
                                 subtitle:@"Туба, диджириду"
                                imageName:nil]];
    
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
