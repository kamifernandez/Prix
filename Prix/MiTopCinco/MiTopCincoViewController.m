//
//  MiTopCincoViewController.m
//  Prix
//
//  Created by Christian Fernandez on 30/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MiTopCincoViewController.h"
#import "DetalleComercioViewController.h"
#import "RequestUrl.h"

@interface MiTopCincoViewController ()

@end

@implementation MiTopCincoViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        self.tblListaCategorias.backgroundView = self.refreshControl;
    }
    else
    {
        self.tblListaCategorias.refreshControl = self.refreshControl;
    }
    
    [self.lblTitulo setText:self.tituloComercio];
    [self.tblListaCategorias reloadData];
    
    [self requestServerCategorias];
}

- (void)reloadData
{
    // Reload table data
    [self requestServerCategorias];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
}

#pragma mark - Own Methods

-(void)pasarDetalleComercio{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetalleComercioViewController *detalleComercioViewController = [story instantiateViewControllerWithIdentifier:@"DetalleComercioViewController"];
    detalleComercioViewController.data = self.dataDetalleCategorias;
    detalleComercioViewController.titulo = self.lblTitulo.text;
    [self.navigationController pushViewController:detalleComercioViewController animated:YES];
}

#pragma mark - IBAction

-(IBAction)btnFavoritos:(id)sender{
    tagFavoritos = (int)[sender tag];
    [self requestServerFavoritos];
}

-(IBAction)btnMensajes:(id)sender{
    
}

-(IBAction)btnFiltro:(id)sender{
    
}

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filteredArray != nil) {
        return [self.filteredArray count];
    }
    return [_dataComercio count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"ListaCategoriasTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ListaCategoriasTableViewCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    UIImageView * imgCategoria = [cell viewWithTag:1];
    if (self.filteredArray == nil) {
        NSString * urlIcon = [[self.dataComercio objectAtIndex:indexPath.row] objectForKey:@"imagen"];
        if ([urlIcon isEqualToString:@""]) {
            [self.indicadorCell stopAnimating];
        }else{
            NSURL *imageURL = [NSURL URLWithString:urlIcon];
            NSString *key = [urlIcon MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                [self.indicadorCell stopAnimating];
                UIImage *image = [UIImage imageWithData:data];
                //imgCategoria.image = image;
            } else {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.indicadorCell stopAnimating];
                        //imgCategoria.image = image;
                    });
                });
            }
        }
        
        
        [self.lblComercio setText:[[self.dataComercio objectAtIndex:indexPath.row] objectForKey:@"NombreCormercio"]];
        //[self.lblDescripcionComercio setText:[[self.dataComercio objectAtIndex:indexPath.row] objectForKey:@"NombreCategoria"]];
        
        [self.lblCalificacion setText:[[self.dataComercio objectAtIndex:indexPath.row] objectForKey:@"Calificacion"]];
        
        UIButton * btnFavoritos = (UIButton *)[cell viewWithTag:2];
        [btnFavoritos addTarget:self action:@selector(btnFavoritos:) forControlEvents:UIControlEventTouchUpInside];
        [btnFavoritos setTag:indexPath.row];
        
        NSString * favorito = [NSString stringWithFormat:@"%@",[[_dataComercio objectAtIndex:0] objectForKey:@"Favorito"]];
        if ([favorito isEqualToString:@"0"]) {
            [btnFavoritos setImage:[UIImage imageNamed:@"corazon-linea.png"] forState:UIControlStateNormal];
        }else{
            [btnFavoritos setImage:[UIImage imageNamed:@"corazon.png"] forState:UIControlStateNormal];
        }
        
    }else{
        NSString * urlIcon = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"imagen"];
        if ([urlIcon isEqualToString:@""]) {
            [self.indicadorCell stopAnimating];
        }else{
            NSURL *imageURL = [NSURL URLWithString:urlIcon];
            NSString *key = [urlIcon MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                [self.indicadorCell stopAnimating];
                UIImage *image = [UIImage imageWithData:data];
                imgCategoria.image = image;
            } else {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.indicadorCell stopAnimating];
                        imgCategoria.image = image;
                    });
                });
            }
        }
        
        
        [self.lblComercio setText:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"NombreCategoria"]];
        //[self.lblDescripcionComercio setText:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"NombreCategoria"]];
        
        [self.lblCalificacion setText:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Calificacion"]];
        UIButton * btnFavoritos = (UIButton *)[cell viewWithTag:2];
        [btnFavoritos addTarget:self action:@selector(btnFavoritos:) forControlEvents:UIControlEventTouchUpInside];
        [btnFavoritos setTag:indexPath.row];
        
        NSString * favorito = [NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Favorito"]];
        if ([favorito isEqualToString:@"0"]) {
            [btnFavoritos setBackgroundColor:[UIColor whiteColor]];
        }else{
            [btnFavoritos setBackgroundColor:[UIColor blueColor]];
        }
        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tagCategoria = (int)indexPath.row;
    [self requestServerDetalleComercio];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RequestServer Categorias

-(void)requestServerCategorias{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerCategorias) object:nil];
        [queue1 addOperation:operation];
    }else{
        [self.tblListaCategorias reloadData];
        [self.refreshControl endRefreshing];
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerCategorias{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    NSMutableArray * temp = [RequestUrl miTopCinco:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoCategorias:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoCategorias:(NSMutableDictionary *)data{
    if ([data count]>0) {
        self.dataComercio = [[data objectForKey:@"TOP_CINCOResult"] copy];
        if ([self.dataComercio count]>0) {
            [self.tblListaCategorias reloadData];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Top cinco sin categorias para mostrar" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"0" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No hay categorias para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"0" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self.refreshControl endRefreshing];
    [self mostrarCargando];
}

#pragma mark - RequestServer Favoritos

-(void)requestServerFavoritos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerFavoritos) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        //[msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerFavoritos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    if (self.filteredArray != nil) {
        [data setObject:[NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:tagFavoritos] objectForKey:@"idCormercio"]] forKey:@"idCormercio"];
        NSString * favorito = [NSString stringWithFormat:@"%@",[[self.filteredArray objectAtIndex:tagFavoritos] objectForKey:@"Favorito"]];
        if ([favorito isEqualToString:@"0"]) {
            [data setObject:@"1" forKey:@"favoritos"];
        }else{
            [data setObject:@"0" forKey:@"favoritos"];
        }
    }else{
        [data setObject:[NSString stringWithFormat:@"%@",[[self.dataComercio objectAtIndex:tagFavoritos] objectForKey:@"idCormercio"]] forKey:@"idCormercio"];
        
        NSString * favorito = [NSString stringWithFormat:@"%@",[[self.dataComercio objectAtIndex:tagFavoritos] objectForKey:@"Favorito"]];
        if ([favorito isEqualToString:@"0"]) {
            [data setObject:@"1" forKey:@"favoritos"];
        }else{
            [data setObject:@"0" forKey:@"favoritos"];
        }
    }
    NSMutableDictionary * temp = [RequestUrl accionFavoritos:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoFavoritos:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoFavoritos:(NSMutableDictionary *)data{
    if ([data count]>0) {
        NSMutableDictionary * temp = [data objectForKey:@"COMERCIO_FAVORITO_ACTResult"];
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"0"]) {
            if (self.filteredArray != nil) {
                NSMutableDictionary * temp = [self.filteredArray objectAtIndex:tagFavoritos];
                NSString * favorito = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Favorito"]];
                if ([favorito isEqualToString:@"0"]) {
                    [temp setObject:@"1" forKey:@"Favorito"];
                }else{
                    [temp setObject:@"0" forKey:@"Favorito"];
                }
            }else{
                NSMutableDictionary * temp = [self.dataComercio objectAtIndex:tagFavoritos];
                NSString * favorito = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Favorito"]];
                if ([favorito isEqualToString:@"0"]) {
                    [temp setObject:@"1" forKey:@"Favorito"];
                }else{
                    [temp setObject:@"0" forKey:@"Favorito"];
                }
            }
            [self.tblListaCategorias reloadData];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"No hay categorias para mostrar" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"0" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
        [self mostrarCargando];
    }
}

#pragma mark - RequestServer Detalle Comercio

-(void)requestServerDetalleComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerDetalleComercio) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        //[msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerDetalleComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    if (self.filteredArray != nil) {
        [data setObject:[[self.filteredArray objectAtIndex:tagCategoria] objectForKey:@"idCormercio"] forKey:@"idCormercio"];
    }else{
        [data setObject:[[self.dataComercio objectAtIndex:tagCategoria] objectForKey:@"idCormercio"] forKey:@"idCormercio"];
    }
    NSMutableDictionary * temp = [RequestUrl detalleComercio:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoDetalleComercio:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoDetalleComercio:(NSMutableDictionary *)data{
    if ([data count]>0) {
        self.dataDetalleCategorias = [[data objectForKey:@"DETALLE_COMERCIOResult"] copy];
        if ([self.dataDetalleCategorias count]>0) {
            NSLog(@"%@",[[self.dataDetalleCategorias objectAtIndex:0] objectForKey:@"imagen"]);
            [self pasarDetalleComercio];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"No hay detalle para mostrar" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"0" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No hay categorias para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"0" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - showAlert metodo

-(void)showAlert:(NSMutableDictionary *)msgDict
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[msgDict objectForKey:@"Title"]
                                 message:[msgDict objectForKey:@"Message"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([[msgDict objectForKey:@"Cancel"] length]>0) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

@end
