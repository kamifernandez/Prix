//
//  RequestUrl.h
//  Tomapp
//
//  Created by Christian Fernandez on 20/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUrl : NSObject

+(NSMutableDictionary *)obtenerToken;

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)recuperarContrasena:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)crearUsuario:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)actualizarUsuario:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)registrarToken:(NSMutableDictionary *)datos;

+(NSMutableArray *)obtenerCategorias:(NSMutableDictionary *)datos;

+(NSMutableArray *)obtenerListadoCategorias:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)accionFavoritos:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)detalleComercio:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)calificarComercio:(NSMutableDictionary *)datos;

+(NSMutableArray *)miTopCinco:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)contactenos:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)actualizarContrasena:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)filtro:(NSMutableDictionary *)datos;

@end
