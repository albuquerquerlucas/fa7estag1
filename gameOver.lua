--==================================================================--|
------------------------ ARROWS & BALLONS ------ ver. 3.0 ------------|
--==================================================================--|
--                                                 >> 11/11/2015 << --|
-- create by: Lucas Albuquerque                                     --|
--==================================================================--|

local composer = require( "composer" )
local scene = composer.newScene()

-- Variáveis globais da classe.
somGameOver = audio.loadStream( "audio/gameOver.ogg" )
local btnInicio, btnSom, btnSair
local txtPontuacao, txtNivel
local fontePlacar = "fontes/SIGNBOAR.TTF"
local nuvens = { n1, n2, n3, n4, n5 }
local controle = false
-- Funções de Chamada de Cena.
------------------------------------------------------------------------
function scene:create( event )

   local sceneGroup = self.view

   audio.play( somGameOver , {loops = -1, channel = 5} )

   configuraBackground()
   criaNuvens()
   configuraLogo()
   configuraPainel()
   configuraPontuacao()
   configuraBotoes()
end

function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
     
   elseif ( phase == "did" ) then

      btnSom:addEventListener( "tap", pausaSom )
        btnSair:addEventListener( "tap", sair )
        btnInicio:addEventListener( "tap", telaMenu )
        Runtime:addEventListener( "enterFrame", configuraNuvens )
   end
end

function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then

   elseif ( phase == "did" ) then
     
   end
end

function scene:destroy( event )

   local sceneGroup = self.view

end

-- Funções de Configuração.
------------------------------------------------------------------------
function configuraBackground()
   
   local imagemFundo = display.newImage( "graficos/backgrounds/bgMenu.png", centroX, centroY)
         imagemFundo.xScale = .68
         imagemFundo.yScale = .7
         scene.view:insert(imagemFundo)
end

function configuraBotoes()

   btnInicio = display.newImage("graficos/botoes/btnInicio.png")
    btnInicio.xScale = .7
    btnInicio.yScale = .7
    btnInicio.x = largura - 80
    btnInicio.y = altura - 145
    scene.view:insert(btnInicio)

   btnSom = display.newImage("graficos/botoes/btnSoundOn.png", 50, metadeCentroY2Quad + 50)
   btnSom.xScale = .7
   btnSom.yScale = .7
   scene.view:insert(btnSom)

   btnSair = display.newImage("graficos/botoes/btnSair.png", 105, metadeCentroY2Quad + 50)
   btnSair.xScale = .7
   btnSair.yScale = .7
   scene.view:insert(btnSair)
end

function criaNuvens()
   
   nuvens[1] = display.newImage("graficos/nuvens/nuvem1.png")
   nuvens[1].x = centroX
   nuvens[1].y = centroY - 60
   scene.view:insert(nuvens[1])

   nuvens[2] = display.newImage("graficos/nuvens/nuvem2.png")
   nuvens[2].x = centroX + 60
   nuvens[2].y = centroY - 125
   scene.view:insert(nuvens[2])

   nuvens[3] = display.newImage("graficos/nuvens/nuvem3.png")
   nuvens[3].x = largura + 100
   nuvens[3].y = centroY - 110
   scene.view:insert(nuvens[3])

   nuvens[4] = display.newImage("graficos/nuvens/nuvem4.png")
   nuvens[4].xScale = .45
   nuvens[4].yScale = .45
   nuvens[4].x = 150
   nuvens[4].y = metadeCentroY - 80
   scene.view:insert(nuvens[4])

   nuvens[5] = display.newImage("graficos/nuvens/nuvem5.png")
   nuvens[5].xScale = .25
   nuvens[5].yScale = .25
   nuvens[5].x = largura - 80
   nuvens[5].y = centroY - 60
   scene.view:insert(nuvens[5])
end

function configuraNuvens(event)
   
   nuvens[1].x = nuvens[1].x - 0.8
   nuvens[2].x = nuvens[2].x - 0.8
   nuvens[3].x = nuvens[3].x - 0.7
   nuvens[4].x = nuvens[4].x - 0.5
   nuvens[5].x = nuvens[5].x - 0.3

   if (nuvens[1].x + nuvens[1].contentWidth) < 0 then
      nuvens[1]:translate( largura * 3, 0 )
   end

   if (nuvens[2].x + nuvens[2].contentWidth) < 0 then
      nuvens[2]:translate( largura * 3, 0 )
   end

   if (nuvens[3].x + nuvens[3].contentWidth) < 0 then
      nuvens[3]:translate( largura * 3, 0 )
   end

   if (nuvens[4].x + nuvens[4].contentWidth) < 0 then
      nuvens[4]:translate( largura * 3, 0 )
   end

   if (nuvens[5].x + nuvens[5].contentWidth) < 0 then
      nuvens[5]:translate( largura * 3, 0 )
   end
end

function configuraLogo()
   
   local logo = display.newImage("graficos/componentes/logo.png")
         logo.xScale = .2
         logo.yScale = .2
         logo.x = metadeCentroX2Quad + 100
         logo.y = metadeCentroY - 60
         scene.view:insert(logo)
end

function configuraPainel()
    
    local painel = display.newImage( "graficos/componentes/painelGameOver.png", centroX - 90, centroY - 30)
        painel.xScale = .60
        painel.yScale = .55
        scene.view:insert(painel)
end

function configuraPontuacao()

         txtNivel = display.newText( "01", centroX - 210, centroY - 29, fontePlacar,  20)
         txtNivel:setFillColor( 255, 0, 0 )
         scene.view:insert(txtNivel)

         txtPontuacao = display.newText( "00", centroX - 110, centroY + 4, fontePlacar,  20)
         txtPontuacao:setFillColor( 255, 0, 0 )
         scene.view:insert(txtPontuacao)

         exibePontos()
end

function exibePontos()
  
    txtNivel.text = string.format( "%d" , nivelForGameOver )
    txtPontuacao.text = string.format( "%d" , pontosForGameOver)
end

function telaMenu()
   
   nivelForGameOver = 1
   pontosForGameOver = 0
   numPontos = 0
   numNivel = 1
   numFlechas = 10
   multiplicador = 0
   audio.stop( 5 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   composer.removeScene( "gameOver" )
   composer.gotoScene( "menu", transicaoPadrao )   
end

function pausaSom()
    
    if (controle == false) then
        
        btnSom = display.newImage("graficos/botoes/btnSoundOff.png", 50, metadeCentroY2Quad + 50)
        btnSom.xScale = .7
        btnSom.yScale = .7
        scene.view:insert(btnSom)
        audio.pause( 5 )
        controle = true
    else
        display.remove(btnSom)
        audio.resume( 5 )
        controle = false
    end
end

function telaMenu()
   
   audio.stop( 5 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   composer.removeScene( "gameOver" )
   composer.gotoScene( "menu", transicaoPadrao )   
end

function removeCenas()
   
   composer.removeScene( "jogo" )
   composer.removeScene( "regras1" )
   composer.removeScene( "regras2" )
   composer.removeScene( "regras3" )
   composer.removeScene( "menu" )
   composer.removeScene( "creditos" )
   composer.removeScene( "vitoria" )
   composer.removeScene( "splash" )
end

------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene