//
//  InicioViewController.m
//  Prix
//
//  Created by Christian Fernandez on 24/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "InicioViewController.h"
#import "RequestUrl.h"
#import "ListadoCategoriasViewController.h"
#import "AcumulacionComercioViewController.h"
#import "RedencionPuntosViewController.h"

@interface InicioViewController ()

@end

@implementation InicioViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    if (primeraVez) {
        [self requestServerCategorias];
        primeraVez = NO;
    }
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults setObject:@"0" forKey:@"tabitem"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *selectedImage0 = [UIImage imageNamed:@"inicio.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    
    [item0 setSelectedImage:[selectedImage0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    primeraVez = YES;
    //NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [self requestServerToken];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestServerDetalleComercio)
                                                 name:@"puntosComercioInicio"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestServerRedencionComercio)
                                                 name:@"puntosComercioRedencionInicio"
                                               object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        self.tblCategorias.backgroundView = self.refreshControl;
    }
    else
    {
        self.tblCategorias.refreshControl = self.refreshControl;
    }
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

-(void)pasarListadoCategorias{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListadoCategoriasViewController *listadoCategoriasViewController = [story instantiateViewControllerWithIdentifier:@"ListadoCategoriasViewController"];
    listadoCategoriasViewController.dataComercio = self.dataListadoCategorias;
    listadoCategoriasViewController.tituloComercio = [[self.dataCategorias objectAtIndex:tagCategoria] objectForKey:@"NombreCategoria"];
    listadoCategoriasViewController.idCategoria = [[self.dataCategorias objectAtIndex:tagCategoria] objectForKey:@"idCategoria"];
    [self.navigationController pushViewController:listadoCategoriasViewController animated:YES];
}

#pragma mark - WebServices

#pragma mark - RequestServer Token

-(void)requestServerToken{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerToken) object:nil];
        [queue1 addOperation:operation];
    }else{
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

-(void)envioServerToken{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    [data setObject:[_defaults objectForKey:@"token"] forKey:@"token"];
    _data = [RequestUrl registrarToken:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoToken) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoToken{
    if ([_data count]>0) {
        NSMutableDictionary * temp = [_data objectForKey:@"REGISTAR_DISPOSITIVOSResult"];
        NSString * codigo = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Codigo"]];
        if ([codigo isEqualToString:@"1"]) {
            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
            [_defaults setObject:@"YES" forKey:@"registrotoken"];
        }else{
            [self requestServerToken];
        }
    }else{
        //[self requestServerToken];
    }
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
        [self.tblCategorias reloadData];
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
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    NSMutableArray * temp = [RequestUrl obtenerCategorias:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoCategorias:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoCategorias:(NSMutableDictionary *)data{
    if ([data count]>0) {
        self.dataCategorias = [[data objectForKey:@"CATEGORIASResult"] copy];
        if ([self.dataCategorias count]>0) {
            [self.tblCategorias reloadData];
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

#pragma mark - RequestServer Listado Categorias

-(void)requestServerListadoCategorias{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerListadoCategorias) object:nil];
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

-(void)envioServerListadoCategorias{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    if (self.filteredArray != nil) {
        [data setObject:[[self.filteredArray objectAtIndex:tagCategoria] objectForKey:@"idCategoria"] forKey:@"idCategoria"];
    }else{
        [data setObject:[[self.dataCategorias objectAtIndex:tagCategoria] objectForKey:@"idCategoria"] forKey:@"idCategoria"];
    }
    NSMutableArray * temp = [RequestUrl obtenerListadoCategorias:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoListadoCategorias:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoListadoCategorias:(NSMutableDictionary *)data{
    if ([data count]>0) {
        self.dataListadoCategorias = [[data objectForKey:@"DETALLE_CATEGORIASResult"] copy];
        if ([self.dataListadoCategorias count]>0) {
            [self pasarListadoCategorias];
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
    return [_dataCategorias count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"CategoriasTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CategoriasTableViewCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    UIImageView * imgCategoria = [cell viewWithTag:1];
    if (self.filteredArray == nil) {
        NSString * urlIcon = [[self.dataCategorias objectAtIndex:indexPath.row] objectForKey:@"Imagen"];
        if ([urlIcon isEqualToString:@""]) {
            [self.indicador stopAnimating];
        }else{
            NSURL *imageURL = [NSURL URLWithString:urlIcon];
            NSString *key = [urlIcon MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                [self.indicador stopAnimating];
                UIImage *image = [UIImage imageWithData:data];
                imgCategoria.image = image;
            } else {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.indicador stopAnimating];
                        imgCategoria.image = image;
                    });
                });
            }
        }
        
        
        [self.lblCategoria setText:[[self.dataCategorias objectAtIndex:indexPath.row] objectForKey:@"NombreCategoria"]];
    }else{
        NSString * urlIcon = [[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"Imagen"];
        if ([urlIcon isEqualToString:@""]) {
            [self.indicador stopAnimating];
        }else{
            NSURL *imageURL = [NSURL URLWithString:urlIcon];
            NSString *key = [urlIcon MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                [self.indicador stopAnimating];
                UIImage *image = [UIImage imageWithData:data];
                imgCategoria.image = image;
            } else {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    [FTWCache setObject:data forKey:key];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.indicador stopAnimating];
                        imgCategoria.image = image;
                    });
                });
            }
        }
        
        
        [self.lblCategoria setText:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"NombreCategoria"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tagCategoria = (int)indexPath.row;
    [self requestServerListadoCategorias];
    /*UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ListadoCategoriasViewController *listadoCategoriasViewController = [story instantiateViewControllerWithIdentifier:@"ListadoCategoriasViewController"];
    if (self.filteredArray != 0) {
        listadoCategoriasViewController.dataComercio = [self.filteredArray objectAtIndex:indexPath.row];
    }else{
        listadoCategoriasViewController.dataComercio = [self.dataCategorias objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:listadoCategoriasViewController animated:YES];*/
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SearchController Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel Button");
    [searchBar setShowsCancelButton:NO animated:YES];
    self.filteredArray = nil;
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    [self.tblCategorias reloadData];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"List Button");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"List Button");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length]>0) {
        self.filteredArray = nil;
        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"NombreCategoria", searchText];//keySelected is NSString itself
        NSLog(@"predicate %@",predicateString);
        self.filteredArray = [NSMutableArray arrayWithArray:[self.dataCategorias filteredArrayUsingPredicate:predicateString]];
        
        [self.tblCategorias reloadData];
        NSLog(@"%@",self.filteredArray);
        
    }else{
        self.filteredArray = nil;
        [self.tblCategorias reloadData];
    }
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
            
            [_indicadorLoad startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

#pragma mark - Metodos PushNotification

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
    
    //[data setObject:[[self.dataComercio objectAtIndex:tagCategoria] objectForKey:@"idCormercio"] forKey:@"idCormercio"];
    
    [data setObject:@"1" forKey:@"idCormercio"];
    
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

-(void)pasarDetalleComercio{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AcumulacionComercioViewController *acumulacionComercioViewController = [story instantiateViewControllerWithIdentifier:@"AcumulacionComercioViewController"];
    acumulacionComercioViewController.data = self.dataDetalleCategorias;
    [self.navigationController pushViewController:acumulacionComercioViewController animated:YES];
}

#pragma mark - RequestServer Redención putnos Comercio

-(void)requestServerRedencionComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerRedencionComercio) object:nil];
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

-(void)envioServerRedencionComercio{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:[_defaults objectForKey:@"IdCliente"] forKey:@"IdCliente"];
    [data setObject:[_defaults objectForKey:@"tokenweb"] forKey:@"tokenweb"];
    
    //[data setObject:[[self.dataComercio objectAtIndex:tagCategoria] objectForKey:@"idCormercio"] forKey:@"idCormercio"];
    
    [data setObject:@"1" forKey:@"idCormercio"];
    
    NSMutableDictionary * temp = [RequestUrl detalleComercio:data];
    data = nil;
    [self performSelectorOnMainThread:@selector(ocultarCargandoDetalleComercio:) withObject:temp waitUntilDone:YES];
}

-(void)ocultarCargandoRedencionComercio:(NSMutableDictionary *)data{
    if ([data count]>0) {
        self.dataDetalleCategorias = [[data objectForKey:@"DETALLE_COMERCIOResult"] copy];
        if ([self.dataDetalleCategorias count]>0) {
            NSLog(@"%@",[[self.dataDetalleCategorias objectAtIndex:0] objectForKey:@"imagen"]);
            [self pasarRedencionPuntos];
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

-(void)pasarRedencionPuntos{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RedencionPuntosViewController *redencionPuntosViewController = [story instantiateViewControllerWithIdentifier:@"redencionPuntosViewController"];
    redencionPuntosViewController.data = self.dataDetalleCategorias;
    [self.navigationController pushViewController:redencionPuntosViewController animated:YES];
}

@end
