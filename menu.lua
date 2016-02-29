--==================================================================--|
------------------------ ARROWS & BALLONS ------ ver. 3.0 ------------|
--==================================================================--|
--                                                 >> 11/11/2015 << --|
-- create by: Lucas Albuquerque                                     --|
--==================================================================--|

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local native = require ("native")

-- Variáveis globais da classe.
local somMenu = audio.loadStream( "audio/menuSong.ogg" )
local btnJogar, btnRegras, btnCreditos, btnSom, btnSair
local nuvens = { n1, n2, n3, n4, n5 }
local controle = false

-- Funções de Chamada de Cena.
------------------------------------------------------------------------
function scene:create( event )

   local sceneGroup = self.view
   
   audio.play( somMenu, {loops = -1, channel = 1} )

   removeCenas()
   configuraBackground()
   criaNuvens()
   configuraLogo()
   numPontos = 0
   multiplicador = 0
   print("-------------------------")
   print("No MENU:")
   print("Pontos: " .. numPontos)
   print("Multiplicador: " .. multiplicador)
end

function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   removeCenas()
   configuraBotoes()

   if ( phase == "will" ) then
     
   elseif ( phase == "did" ) then
      
      btnSom:addEventListener( "tap", pausaSom )
      btnSair:addEventListener( "tap", sair )
      btnJogar:addEventListener( "tap", telaJogo )
      btnRegras:addEventListener( "tap", telaRegras )
      btnCreditos:addEventListener( "tap", telaCreditos )
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
   
   local imagemFundo = display.newImage("graficos/backgrounds/bgMenu.png", centroX, centroY)
         imagemFundo.xScale = .7
         imagemFundo.yScale = .7
         scene.view:insert(imagemFundo)
end

function configuraBotoes()
   
   btnSom = display.newImage("graficos/botoes/btnSoundOn.png", 50, metadeCentroY2Quad + 50)
   btnSom.xScale = .7
   btnSom.yScale = .7
   scene.view:insert(btnSom)

   btnSair = display.newImage("graficos/botoes/btnSair.png", 105, metadeCentroY2Quad + 50)
   btnSair.xScale = .7
   btnSair.yScale = .7
   scene.view:insert(btnSair)

   btnJogar = display.newImage("graficos/botoes/btnJogar.png")
   btnJogar.xScale = .7
   btnJogar.yScale = .7
   btnJogar.x = largura - 70
   btnJogar.y = altura - 158
   scene.view:insert(btnJogar)

   btnRegras = display.newImage("graficos/botoes/btnRegras.png")
   btnRegras.xScale = .7
   btnRegras.yScale = .7
   btnRegras.x = largura - 70
   btnRegras.y = altura - 110
   scene.view:insert(btnRegras)

   btnCreditos = display.newImage("graficos/botoes/btnCreditos.png")
   btnCreditos.xScale = .7
   btnCreditos.yScale = .7
   btnCreditos.x = largura - 70
   btnCreditos.y = altura - 60 
   scene.view:insert(btnCreditos)
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
   nuvens[3].x = largura - 30
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
   
   local grupoBaloes = display.newImage("graficos/baloes/grupoBaloes.png")
         grupoBaloes.xScale = .5
         grupoBaloes.yScale = .5
         grupoBaloes.x = 250
         grupoBaloes.y = 400 -- ponto final
         scene.view:insert(grupoBaloes)

   local logo = display.newImage("graficos/componentes/logo.png")
         logo.xScale = .7
         logo.yScale = .7
         logo.x = 250 -- ponto final 250
         logo.y = 500 -- ponto final 100
         scene.view:insert(logo)

   transition.to( grupoBaloes, { time=6200, y= display.contentCenterY - 300 } )
   transition.to( logo, { time=5000, y=100 } )   
end

function telaJogo()
   
   audio.stop( 1 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   composer.removeScene( "menu" )
   composer.gotoScene( "jogo", transicaoPadrao )   
end

function telaRegras()

   audio.stop( 1 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   composer.removeScene( "menu" )
   composer.gotoScene( "regras1" , transicaoParaDireita )   
end

function telaCreditos()

   audio.stop( 1 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   composer.removeScene( "menu" )
   composer.gotoScene( "creditos" , transicaoParaDireita )   
end

function pausaSom()
    
    if (controle == false) then
        
        btnSom = display.newImage("graficos/botoes/btnSoundOff.png", 50, metadeCentroY2Quad + 50)
        btnSom.xScale = .7
        btnSom.yScale = .7
        scene.view:insert(btnSom)
        audio.pause( 1 )
        controle = true
    else
        display.remove(btnSom)
        btnSom = nil
        audio.resume( 1 )
        controle = false
    end
end

function removeCenas()
   
   composer.removeScene( "jogo" )
   composer.removeScene( "creditos" )
   composer.removeScene( "regras1" )
   composer.removeScene( "regras2" )
   composer.removeScene( "regras3" )
   composer.removeScene( "gameOver" )
   composer.removeScene( "vitoria" )
end

------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene