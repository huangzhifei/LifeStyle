//
//  LSNearbySearchController.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/15.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSNearbySearchController.h"
#import "LSProductCollectionViewCell.h"
#import "LSProductHeaderCell.h"
#import "LSProductItem.h"
#import "LSProductSection.h"
#import "LSCategory.h"
#import "LSNearbyMetaDataTool.h"
#import "LSTGDealListController.h"

#define kLifeSectionNum 6
#define kShopSectionNum 7
#define kHappySectionNum 9

@interface LSNearbySearchController ()

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation LSNearbySearchController

static NSString * reuseIdentifier = @"LSProductCollectionViewCell";
static NSString * reuseHeaderIdentifier = @"LSProductHeaderCell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(80, 80);

    layout.minimumInteritemSpacing = 0;

    layout.minimumLineSpacing = 10;
    
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    layout.headerReferenceSize = CGSizeMake(0, 50);
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"附近";
    
    self.collectionView.backgroundColor = kCollectionHeaderColor;
    
    [self registerCells];
    
    [self addSectionLife];
    
    [self addSectionShop];
    
    [self addSectionHappy];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCells
{
    // 注册内容cell
    UINib *nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    // 注册headercell
    nib = [UINib nibWithNibName:reuseHeaderIdentifier bundle:nil];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];

}

- (void)addSectionLife
{
    LSProductSection *section = [LSProductSection section];
    section.headerTitle = @"生活";
    
    for(NSInteger index = 0; index < kLifeSectionNum; ++ index)
    {
        LSCategory *category = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].totalCategories[index];
        [section.items addObject:[LSProductItem itemWithTitle:category.category_name
                                                         icon:category.icon
                                                  controlVCClass:[LSTGDealListController class]]];
    }
    [self.sections addObject:section];
}

- (void)addSectionShop
{
    LSProductSection *section = [LSProductSection section];
    section.headerTitle = @"购物";
    
    for(NSInteger index = kLifeSectionNum; index < kShopSectionNum; ++ index)
    {
        LSCategory *category = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].totalCategories[index];
        [section.items addObject:[LSProductItem itemWithTitle:category.category_name
                                                         icon:category.icon
                                               controlVCClass:[LSTGDealListController class]]];
    }
    [self.sections addObject:section];
}

- (void)addSectionHappy
{
    LSProductSection *section = [LSProductSection section];
    section.headerTitle = @"娱乐";
    
    for(NSInteger index = kShopSectionNum; index < kHappySectionNum; ++ index)
    {
        LSCategory *category = [LSNearbyMetaDataTool sharedLSNearbyMetaDataTool].totalCategories[index];
        [section.items addObject:[LSProductItem itemWithTitle:category.category_name
                                                         icon:category.icon
                                               controlVCClass:[LSTGDealListController class]]];
    }
    [self.sections addObject:section];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    LSProductSection *sections = self.sections[section];
    
    return sections.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    LSProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                  forIndexPath:indexPath];

    LSProductSection *productSection = self.sections[indexPath.section];
    
    cell.proudctItem = productSection.items[indexPath.item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if( [kind isEqualToString:UICollectionElementKindSectionHeader] )
    {
        LSProductSection *sections = self.sections[indexPath.section];
        
        LSProductHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
        
        cell.headerTitle.text = sections.headerTitle;
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSProductSection *section = self.sections[indexPath.section];
    LSProductItem *item = section.items[indexPath.row];
    
    if (item.controlClass)
    {
        UIViewController *VC = [[item.controlClass alloc] init];
        VC.title = item.title;
        [self.navigationController pushViewController:VC animated:YES];
    }

}

#pragma mark - getter

- (NSMutableArray *)sections
{
    if (_sections == nil)
    {
        _sections = [NSMutableArray array];
    }
    return _sections;
}


@end
