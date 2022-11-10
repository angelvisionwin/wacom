#include 'FiveWin.Ch'

#define EncodingMode_Raw        0x00
#define EncodingMode_16bit_565  0x02

CLASS TWacom 

    EXPORTED:   

        DATA lConnected         AS Logical  INIT .f.
        DATA cTextAceptar       AS String   INIT 'Aceptar'
        DATA cTextBorrar        AS String   INIT 'Borrar'
        DATA cTextCancelar      AS String   INIT 'Cancelar'

        METHOD New()
        METHOD Connect()
        METHOD ClearScreen()
        METHOD ShowDialog()
        METHOD Disconnect()

    PROTECTED: 

        METHOD Init()
        METHOD CanUseColor()
        METHOD SetEncodingMode()
        METHOD PaintButtons()
        METHOD SaveAsImage( cFileName )
        METHOD SendImageToTablet( cFileName )
        

        DATA oUsbDevice         AS Object   INIT nil
        DATA oTablet            AS Object   INIT nil
        DATA oProtocolHelper    AS Object   INIT nil
        DATA oCapability        AS Object   INIT nil
        DATA oInformation       AS Object   INIT nil

        DATA lUseColor          AS Logical  INIT .f.

        DATA oDialog            AS Object   INIT nil


END CLASS

METHOD New() CLASS TWacom

    ::Init()

Return( Self )    


METHOD Connect() CLASS TWacom

    Local oUsbDevices

    ::lConnected := .f.

    TRY
     
        oUsbDevices = CreateObject( 'WacomGSS.STU.UsbDevices' )

    CATCH oError

        MsgAlert( 'No se encuentran los controladores de la tableta de firma', 'Atención' )
        return( .f. )

    END

    if oUsbDevices:Count <= 0

        MsgAlert( 'No se encuentran dispositivos conectados', 'Atención' )
        return( .f. )

    endif
    
    ::oUsbDevice      := oUsbDevices:Item( 0 )
    ::oTablet         := CreateObject( 'WacomGSS.STU.Tablet' )
        
    if ::oTablet:usbConnect( ::oUsbDevice, 0 ) != 0

        MsgAlert( 'Ha habido un problema conectando con la tablet', 'Atención' )
        return( .f. )

    endif

    ::oProtocolHelper := CreateObject ('WacomGSS.STU.ProtocolHelper')

    ::oCapability  := ::oTablet:getCapability()
    ::oInformation := ::oTablet:getInformation()

    ::CanUseColor()
    ::SetEncodingMode()

    ::lConnected := .t.


Return( ::lConnected )    


METHOD ClearScreen() CLASS TWacom

    ::oTablet:setClearScreen()

Return( nil )    

METHOD ShowDialog() CLASS TWacom

    Local oThis := Self

    DEFINE DIALOG ::oDialog FROM 0, 0 to ::oCapability:screenHeight, ::oCapability:screenWidth ;
                            COLOR CLR_BLACK, CLR_WHITE ;
                            PIXEL 
                            //STYLE nOr( WS_POPUP )

    
    ACTIVATE DIALOG ::oDialog CENTERED ON INIT oThis:PaintButtons()

Return( nil )


METHOD Disconnect() CLASS TWacom

    ::oTablet:disconnect()

Return( nil )    


METHOD Init() CLASS TWacom

Return( Self )    


METHOD CanUseColor() CLASS TWacom

    // Si no es la STU-520A (color) siempre en b/n
    // Si no está el driver de la STU-520 tambíen desactiva el color
    // El proceso es más rápido
            
    ::lUseColor := DecToHex( ::oUsbDevice:idProduct ) == 'A3' 
    ::lUseColor := ::lUseColor .and. ::oTablet:supportsWrite()

Return( ::lUseColor )    


METHOD SetEncodingMode() CLASS TWacom

    if ::lUseColor

        ::nEncodingMode := nOr( EncodingMode_16bit_565, EncodingMode_Raw )

    else

        ::nEncodingMode := EncodingMode_Raw;

    endif

Return( nil )


METHOD PaintButtons() CLASS TWacom

    Local nWidth    AS Numeric := 0
    Local nPosX     AS Numeric := 0
    Local nPosY     AS Numeric := 0
    Local nHeight   AS Numeric := 0

    // Para todos los modelos excepto la STU-300 ( A2 )
    // los botones van abajo, la STU-300 tiene poco altura, 
    // por lo que se ponen en un lateral
    
    if DecToHex( ::oUsbDevice:idProduct ) != 'A2' 

        nWidth  := Int( ::oCapability:screenWidth / 3 )
        nPosY   := Int( ::oCapability:screenHeight * 6 / 7 )
        nHeight := ::oCapability:screenHeight - nPosY

        TButton():New( nPosY, 0         , ::cTextAceptar,   ::oDialog, {|| ::SaveAsImage() }, nWidth, nHeight, , , , .t. )
        TButton():New( nPosY, nWidth    , ::cTextBorrar,    ::oDialog, {|| ::ClearScreen() }, nWidth, nHeight, , , , .t. )
        TButton():New( nPosY, nWidth * 2, ::cTextCancelar,  ::oDialog, {|| ::oDialog:End() }, nWidth, nHeight, , , , .t. )

    else

        nPosX   := Int( ::oCapability:screenWidth * 3 / 4 )
        nWidth  := ::oCapability:screenWidth - nPosX
        nHeight := Int( ::oCapability:screenHeight / 3 )

        TButton():New( 0          , nPosX, ::cTextAceptar,   ::oDialog, {|| .t. }, nWidth, nHeight, , , , .t. )
        TButton():New( nHeight    , nPosX, ::cTextBorrar,    ::oDialog, {|| ::ClearScreen() }, nWidth, nHeight, , , , .t. )
        TButton():New( nHeight * 2, nPosX, ::cTextCancelar,  ::oDialog, {|| ::oDialog:End() }, nWidth, nHeight, , , , .t. )

    endif

return( nil )    

METHOD SaveAsImage( cFileName ) CLASS TWacom

    hb_default( @cFileName, 'screen.png')

    ::oDialog:SaveAsImage( cFileName )

return( nil )    


METHOD SendImageToTablet( cFileName ) CLASS TWacom

    

return( nil )


Function main()

    Local oWacom

    WITH OBJECT oWacom := TWacom():New()

        if :Connect()

            :ClearScreen()
            :ShowDialog()
            :Disconnect()

        endif

    END WITH

Return ( 0 )

