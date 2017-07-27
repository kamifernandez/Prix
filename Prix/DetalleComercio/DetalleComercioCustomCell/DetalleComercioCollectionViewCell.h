//
//  DetalleComercioCollectionViewCell.h
//  Prix
//
//  Created by Christian Fernandez on 26/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetalleComercioCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UIImageView * imgComercio;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthImage;

@end
