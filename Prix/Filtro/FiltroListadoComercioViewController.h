//
//  FiltroListadoComercioViewController.h
//  Prix
//
//  Created by Christian Fernandez on 25/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListadoCategoriasViewController.h"

@interface FiltroListadoComercioViewController : UIViewController

@property(nonatomic,strong)NSString * favoritos;
@property(nonatomic,strong)NSString * puntos;
@property(nonatomic,strong)NSString * textoBusqueda;


@property(nonatomic,weak)IBOutlet UITextField *txtBusqueda;

@property(nonatomic,strong)NSMutableArray * data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@property (nonatomic, strong) id <filtroDelegate> delegate;

@end
