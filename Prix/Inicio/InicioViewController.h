//
//  InicioViewController.h
//  Prix
//
//  Created by Christian Fernandez on 24/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface InicioViewController : UIViewController{
    BOOL primeraVez;
    int tagCategoria;
}

@property(nonatomic,weak)IBOutlet UITableView * tblCategorias;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property(nonatomic,strong)NSMutableDictionary * data;
@property(nonatomic,strong)UIRefreshControl * refreshControl;

@property(nonatomic,strong)NSMutableArray * dataCategorias;
@property(nonatomic,strong)NSMutableArray * dataListadoCategorias;
@property(nonatomic,strong)NSMutableArray * filteredArray;
@property(nonatomic,strong)NSMutableArray * dataRedencion;

@property (nonatomic,retain) IBOutlet UISearchBar * search;

// Celda

//@property(nonatomic,strong)IBOutlet UIImageView * imgCategoria;

@property(nonatomic,strong)IBOutlet UIImageView * imgIconoCategoria;

@property(nonatomic,strong)IBOutlet UILabel * lblCategoria;

@property(nonatomic,strong)IBOutlet UIView * viewCategoriaBack;

@property(nonatomic,strong)IBOutlet UIActivityIndicatorView * indicador;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicadorLoad;

//Push

@property(nonatomic,strong)NSMutableArray * dataDetalleCategorias;

@end
