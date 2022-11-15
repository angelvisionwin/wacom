#include 'FiveWin.Ch'

#define RGB_RED 1
#define RGB_GREEN 2
#define RGB_BLUE 3

CLASS TWacom 

    EXPORTED:   

        DATA cTextAceptar       AS String   INIT 'Aceptar'
        DATA cTextBorrar        AS String   INIT 'Borrar'
        DATA cTextCancelar      AS String   INIT 'Cancelar'
        DATA nDimensionX        AS Numeric  INIT 300
        DATA nDimensionY        AS Numeric  INIT 150
        DATA cMimeType          AS String   INIT 'image/png' // ( image/bmp image/tiff image/png )
        DATA nInkWidth          AS Numeric  INIT 0.5
        DATA aInkColor          AS Numeric  INIT { 0, 0, 255 } // RGB
        DATA aInkBackGround     AS Numeric  INIT { 255, 255, 255 } // RGB
        DATA nPaddingX          AS Numeric  INIT 0.0
        DATA nPaddingY          AS Numeric  INIT 0.0

        METHOD New()
        METHOD Capture()
        METHOD End()

    PROTECTED: 

        DATA cLicense   AS String INIT ''
        DATA aErrorCodes AS Array INIT { => }

        METHOD Init()
        METHOD RgbToOleColor( aRgbColor )

END CLASS

METHOD New() CLASS TWacom

    ::Init()

Return( Self )    


METHOD Capture( cFileName, cTextTop, cTextBottom ) CLASS TWacom

    Local oSigCtl AS Object := nil
    Local oDynCapt AS Object := nil
    Local nFlags AS Numeric := 0
    Local nResult AS Numeric := 0

    hb_default( @cFileName, 'sig.png' )
    hb_default( @cTextTop, ' ' )
    hb_default( @cTextBottom, ' ' )

    TRY
     
        oSigCtl := CreateObject( 'Florentis.SigCtl' )
        oDynCapt := CreateObject( 'Florentis.DynamicCapture' )

    CATCH oError

        MsgAlert( 'No están instalados los componentes de firma', 'Atención' )
        return( '' )

    END

    oSigCtl:Licence := ::cLicense 
    nResult := oDynCapt:Capture( oSigCtl, cTextTop, cTextBottom )

    if nResult == 0
        
        //SigObj.outputFilename | SigObj.color32BPP | SigObj.encodeData
        nFlags  := nOr( 0x1000,  0x80000 , 0x400000 )    
        nResult := oSigCtl:Signature:RenderBitmap( cFileName, ;   
                                                   ::nDimensionX, ;
                                                   ::nDimensionY, ;
                                                   ::cMimeType, ; 
                                                   ::nInkWidth, ;     
                                                   ::RgbToOleColor( ::aInkColor ), ; 
                                                   ::RgbToOleColor( ::aInkBackGround ), ;
                                                   ::nPaddingX, ; 
                                                   ::nPaddingY, ; 
                                                   nFlags )         

        return( cFileName )                                                   

    endif

    if aScan( { 1, 100, 101, 103 }, nResult ) != 0

        MsgAlert( ::aErrorCodes[ Alltrim( Str( nResult ) ) ], 'Firma no completada')
        Return( '' )

    endif

    MsgAlert( 'Error desconocido en captura, código de error : ' + Str( nResult ), 'Firma no completada' )

Return( '' )    


METHOD End() CLASS TWacom

Return( nil )


METHOD Init() CLASS TWacom

    // Licencia Lite gratuita
    ::cLicense    := 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3YmM5Y2IxYWIxMGE0NmUxODI2N2E5MTJkYTA2ZTI3NiIsImV4cCI6MjE0NzQ4MzY0NywiaWF0IjoxNTYwOTUwMjcyLCJyaWdodHMiOlsiU0lHX1NES19DT1JFIiwiU0lHQ0FQVFhfQUNDRVNTIl0sImRldmljZXMiOlsiV0FDT01fQU5ZIl0sInR5cGUiOiJwcm9kIiwibGljX25hbWUiOiJTaWduYXR1cmUgU0RLIiwid2Fjb21faWQiOiI3YmM5Y2IxYWIxMGE0NmUxODI2N2E5MTJkYTA2ZTI3NiIsImxpY191aWQiOiJiODUyM2ViYi0xOGI3LTQ3OGEtYTlkZS04NDlmZTIyNmIwMDIiLCJhcHBzX3dpbmRvd3MiOltdLCJhcHBzX2lvcyI6W10sImFwcHNfYW5kcm9pZCI6W10sIm1hY2hpbmVfaWRzIjpbXX0.ONy3iYQ7lC6rQhou7rz4iJT_OJ20087gWz7GtCgYX3uNtKjmnEaNuP3QkjgxOK_vgOrTdwzD-nm-ysiTDs2GcPlOdUPErSp_bcX8kFBZVmGLyJtmeInAW6HuSp2-57ngoGFivTH_l1kkQ1KMvzDKHJbRglsPpd4nVHhx9WkvqczXyogldygvl0LRidyPOsS5H2GYmaPiyIp9In6meqeNQ1n9zkxSHo7B11mp_WXJXl0k1pek7py8XYCedCNW5qnLi4UCNlfTd6Mk9qz31arsiWsesPeR9PN121LBJtiPi023yQU8mgb9piw_a-ccciviJuNsEuRDN3sGnqONG3dMSA'

    ::aErrorCodes[ '1' ]   := 'Se ha pulsado cancelar'
    ::aErrorCodes[ '100' ] := 'Error en captura 100: Dispositivo de firma no disponible'
    ::aErrorCodes[ '101' ] := 'Error en captura 101: Error en dispositivo'
    ::aErrorCodes[ '103' ] := 'Error en captura 103: Licencia inválida ó dispositivo desconectado'
         

Return( Self )    

METHOD RgbToOleColor( aRgbColor ) CLASS TWacom

    hb_Default( @aRgbColor, { 255, 255, 255 } )

    // OLE Conversion OLE = red + (green * 256) + (blue * 256 * 256)

    nOleColor := aRgbColor[ RGB_RED ] + ( aRgBColor[ RGB_GREEN ] * 256 ) + ( aRgbColor[ RGB_BLUE ] * 256 * 256 )

Return( nOleColor ) 


Function Main()

    Local oWacom
    Local cFileName := ''

    oWacom := TWacom():New()

    cFileName := oWacom:Capture( 'mifirma.png' )

    if cFileName != ''

        MsgInfo( 'Captura correcta' )

    endif

Return ( 0 )

