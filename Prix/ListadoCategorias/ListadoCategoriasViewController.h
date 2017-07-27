//
//  ListadoCategoriasViewController.h
//  Prix
//
//  Created by Christian Fernandez on 25/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@protocol filtroDelegate <NSObject>
@optional
-(void)filtrar:(NSMutableDictionary *)filtros;
@end

@interface ListadoCategoriasViewController : UIViewController<filtroDelegate>{
    int tagCategoria;
    int tagFavoritos;
}

@property (nonatomic, strong) id <filtroDelegate> delegate;

@property(nonatomic,weak)IBOutlet UITableView * tblListaCategorias;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property(nonatomic,strong)NSMutableArray * dataComercio;
@property(nonatomic,strong)NSMutableArray * dataFavoritos;
@property(nonatomic,strong)NSMutableArray * dataDetalleCategorias;

@property(nonatomic,strong)NSString * tituloComercio;

@property(nonatomic,strong)NSString * idCategoria;

@property(nonatomic,weak)IBOutlet UILabel * lblTitulo;

@property(nonatomic,strong)NSMutableArray * filteredArray;

// Celda
@property(nonatomic,strong)IBOutlet UIImageView * imgIconoCategoria;

@property(nonatomic,strong)IBOutlet UIButton * btnFavoritos;

@property(nonatomic,strong)IBOutlet UIImageView * imgCalificaion;

@property(nonatomic,strong)IBOutlet UILabel * lblComercio;

@property(nonatomic,strong)IBOutlet UILabel * lblCalificacion;

@property(nonatomic,strong)IBOutlet UILabel * lblDescripcionComercio;

@property(nonatomic,strong)IBOutlet UIActivityIndicatorView * indicadorCell;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

// Filtro

@property(nonatomic,strong)NSString * favoritos;
@property(nonatomic,strong)NSString * puntos;
@property(nonatomic,strong)NSString * textoBusqueda;

@end