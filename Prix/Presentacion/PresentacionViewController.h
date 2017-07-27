//
//  PresentacionViewController.h
//  Prix
//
//  Created by Christian Fernandez on 17/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentacionViewController : UIViewController<UITabBarControllerDelegate>

@property(nonatomic,weak)IBOutlet UICollectionView * collection;

@property(nonatomic,weak)IBOutlet UIPageControl * pageCollection;

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,weak)IBOutlet UIButton * btnSaltarPresentacion;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCollection;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnNext;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPage;

@property(nonatomic,strong)NSMutableDictionary *tokenWeb;

@end
