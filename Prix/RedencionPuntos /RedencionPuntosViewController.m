//
//  RedencionPuntosViewController.m
//  Prix
//
//  Created by Christian Fernandez on 27/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "RedencionPuntosViewController.h"
#import "DetalleComercioCollectionViewCell.h"
#import "RequestUrl.h"
#import "MensajeComercioViewController.h"

@interface RedencionPuntosViewController ()

@end

@implementation RedencionPuntosViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    
    NSString * favorito = [NSString stringWithFormat:@"%@",[[_data objectAtIndex:0] objectForKey:@"Favorito"]];
    if ([favorito isEqualToString:@"0"]) {
        [self.btnFavoritos setImage:[UIImage imageNamed:@"corazon-linea.png"] forState:UIControlStateNormal];
    }else{
        [self.btnFavoritos setImage:[UIImage imageNamed:@"corazon.png"] forState:UIControlStateNormal];
    }
    
    self.progressView.layer.cornerRadius = 5.0;
    self.progressView.layer.borderWidth = 0.3;
    self.progressView.layer.borderColor = [[UIColor colorWithRed:130.0/255.0 green:201/255.0 blue:215/255.0 alpha:1.0] CGColor];
    _progressView.clipsToBounds = YES;
    
    self.lblPuntos.text = [NSString stringWithFormat:@"%@ Puntos",[[_data objectAtIndex:0] objectForKey:@"Consumos"]];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    self.lblNombreUsuario.text = [NSString stringWithFormat:@"%@ %@",[_defaults objectForKey:@"nombre"],[_defaults objectForKey:@"apellidos"]];
    
    int consumo = [[[_data objectAtIndex:0] objectForKey:@"Consumos"] intValue];
    int meta = [[[_data objectAtIndex:0] objectForKey:@"Meta"] intValue];
    
    int totalFaltantes = meta - consumo;
    
    if (totalFaltantes == 0) {
        self.lblPuntosFaltantes.text = @"!No dudes en reclamar tu premio ahora mismo¡";
    }else
        self.lblPuntosFaltantes.text = [NSString stringWithFormat:@"Sigue acumulando, te faltan %i puntos para redimir el premio de esta campaña.",totalFaltantes];
    
    self.lblTitulos.text = [[_data objectAtIndex:0] objectForKey:@"NombreCampania"];
    self.txvComents.text = [[_data objectAtIndex:0] objectForKey:@"Mensaje"];
    
    [self.pageCollection setNumberOfPages:[self.data count]];
    
    /*if ([[UIScreen mainScreen] bounds].size.height == 480) {
        self.bottomHeigthView.constant = 170;
    }else if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.bottomHeigthView.constant = 180;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.bottomHeigthView.constant = 350;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.bottomHeigthView.constant = 500;
    }
    [self.view layoutIfNeeded];*/
    [self ponerEstrellas];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vistaCollection attribute: NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:185.0]];
    }else if ([[UIScreen mainScreen] bounds].size.height == 568) {
        //self.bottomHeigthView.constant = 280;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.bottomHeigthView.constant = 350;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.bottomHeigthView.constant = 400;
    }
    
    [self.scroll setContentSize:CGSizeMake(0, self.viewBack.frame.origin.y + self.viewBack.frame.size.height)];
}

-(void)ponerEstrellas{
    if ([[[_data objectAtIndex:0] objectForKey:@"Calificacion"] isEqualToString:@"1"]) {
        [self.imgFirstStar setImage:[UIImage imageNamed:@"estrella.png"]];
    }else if ([[[_data objectAtIndex:0] objectForKey:@"calificacion"] isEqualToString:@"2"]) {
        [self.imgFirstStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgSecondtStar setImage:[UIImage imageNamed:@"estrella.png"]];
    }else if ([[[_data objectAtIndex:0] objectForKey:@"Calificacion"] isEqualToString:@"3"]){
        
        [self.imgFirstStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgSecondtStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgthirdtStar setImage:[UIImage imageNamed:@"estrella.png"]];
    }else if ([[[_data objectAtIndex:0] objectForKey:@"Calificacion"] isEqualToString:@"4"]){
        
        [self.imgFirstStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgSecondtStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgthirdtStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgFourStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
    }else if ([[[_data objectAtIndex:0] objectForKey:@"Calificacion"] isEqualToString:@"5"]){
        
        [self.imgFirstStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgSecondtStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgthirdtStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgFourStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
        [self.imgFiveStar setImage:[UIImage imageNamed:@"estrella.png"]];
        
    }else{
        [self.imgFirstStar setImage:[UIImage imageNamed:@"estrella-linea.png"]];
        
        [self.imgSecondtStar setImage:[UIImage imageNamed:@"estrella-linea.png"]];
        
        [self.imgthirdtStar setImage:[UIImage imageNamed:@"estrella-linea.png"]];
        
        [self.imgFourStar setImage:[UIImage imageNamed:@"estrella-linea.png"]];
        
        [self.imgFiveStar setImage:[UIImage imageNamed:@"estrella-linea.png"]];
    }
}

#pragma mark - IBActions

-(IBAction)compartir:(id)sender{
    
    NSString *URLString=[[self.data objectAtIndex:0]objectForKey:@"imagen"];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error)
         {
             NSLog(@"Process error");
         }
         else if (result.isCancelled)
         {
             NSLog(@"Cancelled");
         }
         else
         {
             FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
             [content setContentTitle:@""];
             [content setContentDescription:[NSString stringWithFormat:@"whatsapp://send?text=%@",[NSString stringWithFormat:@"Hey, estoy en %@ con la campaña %@",[[_data objectAtIndex:0] objectForKey:@"NombreCormercio"],[[_data objectAtIndex:0] objectForKey:@"NombreCampania"]]]];
             content.contentURL = [NSURL URLWithString:URLString];
             [FBSDKShareDialog showFromViewController:self
                                          withContent:content
                                             delegate:nil];
         }
     }];
    
}

-(IBAction)compartirWhatsapp:(id)sender{
    NSString * textoCompartir = [NSString stringWithFormat:@"whatsapp://send?text=%@",[NSString stringWithFormat:@"Hey, estoy en %@ con la campaña %@",[[_data objectAtIndex:0] objectForKey:@"NombreCormercio"],[[_data objectAtIndex:0] objectForKey:@"NombreCampania"]]];
    textoCompartir=[NSString stringWithFormat:@"%@",[textoCompartir stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *whatsappURL = [NSURL URLWithString:textoCompartir];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No encontramos WhatsApp instalado, ¿Quieres descárgarlo?" forKey:@"Message"];
        [msgDict setValue:@"SI" forKey:@"Aceptar"];
        [msgDict setValue:@"NO" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(IBAction)btnFavoritos:(id)sender{
    [self requestServerFavoritos];
}

-(IBAction)volver:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)btnMensajeComercio:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MensajeComercioViewController *mensajeComercioViewController = [story instantiateViewControllerWithIdentifier:@"MensajeComercioViewController"];
    mensajeComercioViewController.dataDetalleCategorias = self.data;
    [self.navigationController pushViewController:mensajeComercioViewController animated:YES];
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
    
    [data setObject:[NSString stringWithFormat:@"%@",[[self.data objectAtIndex:0] objectForKey:@"idCormercio"]] forKey:@"idCormercio"];
    
    NSString * favorito = [NSString stringWithFormat:@"%@",[[self.data objectAtIndex:0] objectForKey:@"Favorito"]];
    if ([favorito isEqualToString:@"0"]) {
        [data setObject:@"1" forKey:@"favoritos"];
    }else{
        [data setObject:@"0" forKey:@"favoritos"];
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
            NSMutableDictionary * temp = [self.data objectAtIndex:0];
            NSString * favorito = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Favorito"]];
            if ([favorito isEqualToString:@"0"]) {
                [temp setObject:@"1" forKey:@"Favorito"];
                [self.btnFavoritos setImage:[UIImage imageNamed:@"corazon.png"] forState:UIControlStateNormal];
            }else{
                [temp setObject:@"0" forKey:@"Favorito"];
                [self.btnFavoritos setImage:[UIImage imageNamed:@"corazon-linea.png"] forState:UIControlStateNormal];
            }
        }
        [self mostrarCargando];
    }
}

#pragma mark - CollectionView Delegates


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return [self.data count];
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DetalleComercioCollectionViewCell";
    
    DetalleComercioCollectionViewCell *cell = (DetalleComercioCollectionViewCell *)[self.collection dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString * urlEnvio = [[self.data objectAtIndex:0]objectForKey:@"imagen"];
    if ([urlEnvio isEqualToString:@""]) {
        [cell.imgComercio setFrame:CGRectMake(cell.imgComercio.frame.origin.x, cell.imgComercio.frame.origin.y - 15, cell.imgComercio.frame.size.width, cell.imgComercio.frame.size.height)];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [urlEnvio MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            //UIImage *image = [UIImage imageWithData:data];
            UIImage *image = [UIImage imageNamed:@"imagen-detalle@3x.png"];
            cell.imgComercio.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                //UIImage *image = [UIImage imageWithData:data];
                UIImage *image = [UIImage imageNamed:@"imagen-detalle@3x.png"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.imgComercio.image = image;
                });
            });
        }
    }
    
    //cell.imgComerce.image = [UIImage imageNamed:[[self.data objectAtIndex:indexPath.row] objectForKey: @"imagen"]];
    
    //cell.imgComercio.contentMode = UIViewContentModeScaleAspectFill;
    
    //[cell.imgComercio.layer setMasksToBounds:YES];
    
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int heigth = 200;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        heigth = 220;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        heigth = 350;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        heigth = 400;
    }
    return CGSizeMake(self.collection.frame.size.width, heigth);
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
