//
//  FiltroListadoComercioViewController.m
//  Prix
//
//  Created by Christian Fernandez on 25/01/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "FiltroListadoComercioViewController.h"
#import "RequestUrl.h"

@interface FiltroListadoComercioViewController (){
    
}

@end

@implementation FiltroListadoComercioViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cerrarVista)
                                                 name:@"cerrarFiltro"
                                               object:nil];
    
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    self.favoritos = @"0";
    self.puntos = @"0";
    self.textoBusqueda = @"";
}

-(void)cerrarVista{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [self.view setFrame:CGRectMake(0, -216, self.view.frame.size.width, self.view.frame.size.height)];
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtBusqueda isEqual:textField]){
        [self.view endEditing:TRUE];
        if (self.view.frame.origin.y != 0) {
            [UIView animateWithDuration:0.5f
                             animations:^{
                                 [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 
                             }
             ];
        }
    }
    return true;
}

#pragma mark IBActions

-(IBAction)volver:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)seleccionarFavoritos:(id)sender{
    if ([self.favoritos isEqualToString:@"0"]) {
        self.favoritos = @"1";
    }else{
        self.favoritos = @"0";
    }
}

-(IBAction)seleccionarPuntos:(id)sender{
    if ([self.puntos isEqualToString:@"0"]) {
        self.puntos = @"1";
    }else{
        self.puntos = @"0";
    }
}

-(IBAction)btnFiltrar:(id)sender{
    self.textoBusqueda = self.txtBusqueda.text;
    if ([self.favoritos isEqualToString:@"1"] || [self.puntos isEqualToString:@"1"] || ![self.textoBusqueda isEqualToString:@""]) {
        NSMutableDictionary * temp = [[NSMutableDictionary alloc] init];
        [temp setObject:self.favoritos forKey:@"favoritos"];
        [temp setObject:self.puntos forKey:@"puntos"];
        [temp setObject:self.textoBusqueda forKey:@"textoBusqueda"];
        [_delegate filtrar:temp];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Para filtrar es necesario seleccionar alguno de los valores" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
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
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

@end
