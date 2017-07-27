//
//  RequestUrl.m
//  Tomapp
//
//  Created by Christian Fernandez on 20/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import "RequestUrl.h"
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"

static NSString *domain = @"http://appmovil007.somasoft.com.co/JSONService.svc/";
/*static NSString *appKey = @"Basic cmVzdF90b21hcHA6MTIzNDU2Nzg5";
static NSString *x_CSRF_Token = @"";*/

static NSString *user = @"Dev";
static NSString *pass = @"Soma";

@implementation RequestUrl

+(NSMutableDictionary *)obtenerToken{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@AutencationSvr",domain];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"UsrSvr" value:user];
    [request addRequestHeader:@"PassSvr" value:pass];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * email = [datos objectForKey:@"email"];
    NSString * password = [datos objectForKey:@"password"];
    NSString * tipo = [datos objectForKey:@"tipo"];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@AUTENTICAR_USUARIO/%@/%@/%@",domain,email,password,tipo];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)crearUsuario:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * nombre = [datos objectForKey:@"nombre"];
    NSString * apellidos = [datos objectForKey:@"apellidos"];
    NSString * fecha = [datos objectForKey:@"fecha"];
    NSString * correo = [datos objectForKey:@"correo"];
    NSString * contrasena = [datos objectForKey:@"contrasena"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    
    NSString * metodo = [datos objectForKey:@"metodo"];
    
    NSString * urlSend = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",metodo,correo,nombre,apellidos,contrasena,fecha];
    
    if ([metodo isEqualToString:@"REGISTRO_USUARIOS_RS/"]) {
        NSString * red = [datos objectForKey:@"red"];
        urlSend = [NSString stringWithFormat:@"%@%@/%@/%@/%@",metodo,correo,nombre,apellidos,red];
    }
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",domain,urlSend];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)recuperarContrasena:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * email = [datos objectForKey:@"email"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@RECUPERAR_CONTARSENA/%@",domain,email];
    NSURL * url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)actualizarContrasena:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * correo = [datos objectForKey:@"email"];
    NSString * contrasena = [datos objectForKey:@"contrasena"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = [datos objectForKey:@"metodo"];
    
    NSString * urlSend = [NSString stringWithFormat:@"%@%@/%@/%@",metodo,correo,contrasena,@"3"];
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",domain,urlSend];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)actualizarUsuario:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * nombre = [datos objectForKey:@"nombre"];
    NSString * apellidos = [datos objectForKey:@"apellidos"];
    NSString * fecha = [datos objectForKey:@"fecha"];
    NSString * correo = [datos objectForKey:@"correo"];
    NSString * contrasena = [datos objectForKey:@"contrasena"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = [datos objectForKey:@"metodo"];
    
    NSString * urlSend = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",metodo,correo,nombre,apellidos,contrasena,fecha];
    
    if ([metodo isEqualToString:@"ACTUALIZAR_DATOS_RS/"]) {
        urlSend = [NSString stringWithFormat:@"%@%@/%@/%@/%@",metodo,correo,nombre,apellidos,fecha];
    }
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",domain,urlSend];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)registrarToken:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    
    NSString * IdCliente = [datos objectForKey:@"IdCliente"];
    NSString * token = [datos objectForKey:@"token"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = @"REGISTAR_DISPOSITIVOS";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@",domain,metodo,IdCliente,token];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)obtenerCategorias:(NSMutableDictionary *)datos{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];

    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = @"CATEGORIAS";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",domain,metodo,@"0"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)obtenerListadoCategorias:(NSMutableDictionary *)datos{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    
    //NSString * IdCliente = [datos objectForKey:@"IdCliente"];
    NSString * IdCliente = @"1";
    NSString * idCategoria = [datos objectForKey:@"idCategoria"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = @"DETALLE_CATEGORIAS";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@",domain,metodo,idCategoria,IdCliente,@"0"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)accionFavoritos:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * idCormercio = [datos objectForKey:@"idCormercio"];
    NSString * favoritos = [datos objectForKey:@"favoritos"];
    //NSString * IdCliente = [datos objectForKey:@"IdCliente"];
    NSString * IdCliente = @"1";
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = @"COMERCIO_FAVORITO_ACT";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@",domain,metodo,idCormercio,favoritos,IdCliente];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}


+(NSMutableDictionary *)detalleComercio:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * idCormercio = [datos objectForKey:@"idCormercio"];
    //NSString * IdCliente = [datos objectForKey:@"IdCliente"];
    NSString * IdCliente = @"1";
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = @"DETALLE_COMERCIO";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@",domain,metodo,idCormercio,IdCliente,@"0"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)calificarComercio:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * idCormercio = [datos objectForKey:@"idCormercio"];
    NSString * IdCliente = [datos objectForKey:@"IdCliente"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * calificacion = [datos objectForKey:@"calificacion"];
    NSString * comentario = [datos objectForKey:@"comentario"];
    NSString * metodo = @"CALIFICAR_COMERCIO";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",domain,metodo,idCormercio,IdCliente,calificacion,comentario];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableArray *)miTopCinco:(NSMutableDictionary *)datos{
    
    NSMutableArray *stringDictio = [[NSMutableArray alloc] init];
    
    //NSString * IdCliente = [datos objectForKey:@"IdCliente"];
    NSString * IdCliente = @"1";
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * metodo = @"TOP_CINCO";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@",domain,metodo,IdCliente];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)contactenos:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * asunto = [datos objectForKey:@"asunto"];
    NSString * mensaje = [datos objectForKey:@"mensaje"];
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * telefono = [datos objectForKey:@"telefono"];
    NSString * metodo = @"CONTACTENOS";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@",domain,metodo,asunto,mensaje,telefono];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

+(NSMutableDictionary *)filtro:(NSMutableDictionary *)datos{
    
    NSMutableDictionary *stringDictio = [[NSMutableDictionary alloc] init];
    
    NSString * tokenweb = [datos objectForKey:@"tokenweb"];
    NSString * IdCliente = [datos objectForKey:@"IdCliente"];
    NSString * favoritos = [datos objectForKey:@"favoritos"];
    NSString * puntos = [datos objectForKey:@"puntos"];
    NSString * categoria = [datos objectForKey:@"categoria"];
    NSString * metodo = @"COMERCIOS_FILTROS";
    
    NSError *error;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",domain,metodo,IdCliente,favoritos,puntos,categoria];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:urlString] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Token" value:tokenweb];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
        NSMutableDictionary * respuesta = [response JSONValue];
        if (respuesta != nil) {
            stringDictio = [respuesta mutableCopy];
        }
    }
    return stringDictio;
}

@end
