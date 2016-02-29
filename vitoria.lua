--==================================================================--|
------------------------ ARROWS & BALLONS ------ ver. 3.0 ------------|
--==================================================================--|
--                                                 >> 11/11/2015 << --|
-- create by: Lucas Albuquerque                                     --|
--==================================================================--|

local composer = require( "composer" )
local scene = composer.newScene()

-- Variáveis globais da classe.
local somVitoria = audio.loadStream( "audio/final2.ogg" )
local btnMenu, btnSom, btnSair
local developer
local nuvens = { n1, n2, n3, n4, n5 }
local bal = {}
local controle = false

-- Funções de Chamada de Cena.
------------------------------------------------------------------------
function scene:create( event )

   local sceneGroup = self.view

   audio.play( somVitoria, {loops = -1, channel = 6} )
   audio.setVolume( 0.75, { channel=6 } )

   removeCenas()
   configuraBackground()
   criaNuvens()
    configuraBotoes()
    developed()
    configuraTodosBaloes()
   configuraLogo()

  


end

function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   developer:play()
   
   ---developer:setFrame( 4 )

   if ( phase == "will" ) then
     
   elseif ( phase == "did" ) then

      btnSom:addEventListener( "tap", pausaSom )
      btnSair:addEventListener( "tap", sair )
      Runtime:addEventListener( "enterFrame", configuraNuvens )
      Runtime:addEventListener( "enterFrame", movimentaTudo)
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
------------------------------------------------------------------------
function configuraBackground()
   
   local imagemFundo = display.newImage("graficos/backgrounds/bgVitoria.png", centroX, centroY)
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
   
   local grupoBaloes = display.newImage("graficos/baloes/grupoBaloes.png")
         grupoBaloes.xScale = .5
         grupoBaloes.yScale = .5
         grupoBaloes.x = 250
         grupoBaloes.y = 410 -- ponto final
         scene.view:insert(grupoBaloes)

   local logo = display.newImage("graficos/componentes/voceVenceu.png")
         logo.xScale = .5
         logo.yScale = .5
         logo.x = 250 -- ponto final 250
         logo.y = 500 -- ponto final 100
         scene.view:insert(logo)

   local logoJogo = display.newImage("graficos/componentes/logo.png")
         logoJogo.xScale = .2
         logoJogo.yScale = .2
         logoJogo.x = metadeCentroX2Quad + 100
         logoJogo.y = metadeCentroY - 60
         scene.view:insert(logoJogo)

   transition.to( grupoBaloes, { time=6280, y= display.contentCenterY - 300 } )
   transition.to( logo, { time=5000, y=100 } )   
end

function configuraTodosBaloes()
   
   bal[1] = display.newImage( "graficos/baloes/bsAzul.png" )
   bal[1].x = math.random( display.contentCenterX + 50, display.contentWidth )
   bal[1].y = 390
   scene.view:insert(bal[1])

   bal[2] = display.newImage( "graficos/baloes/bsVermelho.png" )
   bal[2].x = math.random( 10, display.contentWidth )
   bal[2].y = 390
   scene.view:insert(bal[2])

   bal[3] = display.newImage( "graficos/baloes/bsVerde.png" )
   bal[3].x = math.random( 15, display.contentWidth )
   bal[3].y = 390
   scene.view:insert(bal[3])

   bal[4] = display.newImage( "graficos/baloes/bsAmarelo.png" )
   bal[4].x = math.random( display.contentCenterX + 50, display.contentWidth )
   bal[4].y = 390
   scene.view:insert(bal[4])

   bal[5] = display.newImage( "graficos/baloes/bsRosa.png" )
   bal[5].x = math.random( display.contentCenterX + 50, display.contentWidth )
   bal[5].y = 390
   scene.view:insert(bal[5])

   bal[6] = display.newImage( "graficos/baloes/bsLaranja.png" )
   bal[6].x = math.random( display.contentCenterX + 50, display.contentWidth )
   bal[6].y = 390
   scene.view:insert(bal[6])

   --------------------------------------------------------------------------------

   bal[7] = display.newImage( "graficos/baloes/bsAzul.png" )
   bal[7].x = math.random( 20, display.contentWidth )
   bal[7].y = 380
   scene.view:insert(bal[7])

   bal[8] = display.newImage( "graficos/baloes/bsVermelho.png" )
   bal[8].x = math.random( 30, display.contentWidth )
   bal[8].y = 400
   scene.view:insert(bal[8])

   bal[9] = display.newImage( "graficos/baloes/bsVerde.png" )
   bal[9].x = math.random( 40, display.contentWidth )
   bal[9].y = 390
   scene.view:insert(bal[9])

   bal[10] = display.newImage( "graficos/baloes/bsAmarelo.png" )
   bal[10].x = math.random( 50 + 50, display.contentWidth )
   bal[10].y = 390
   scene.view:insert(bal[10])

   bal[11] = display.newImage( "graficos/baloes/bsRosa.png" )
   bal[11].x = math.random( 35 + 50, display.contentWidth )
   bal[11].y = 380
   scene.view:insert(bal[11])

   bal[12] = display.newImage( "graficos/baloes/bsLaranja.png" )
   bal[12].x = math.random( 55 + 50, display.contentWidth )
   bal[12].y = 400
   scene.view:insert(bal[12])
end

function movimentaTudo()
  
  bal[1].y = bal[1].y - 1
  bal[2].y = bal[2].y - 1.5
  bal[3].y = bal[3].y - 1.8
  bal[4].y = bal[4].y - 2
  bal[5].y = bal[5].y - 2.4
  bal[6].y = bal[6].y - 1.3
  bal[7].y = bal[7].y - 3
  bal[8].y = bal[8].y - 2.8
  bal[9].y = bal[9].y - 1.3
  bal[10].y = bal[10].y - 1
  bal[11].y = bal[11].y - 1.6
  bal[12].y = bal[11].y - 2.3

  if (bal[1].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[1].x = math.random( 15, largura - 20 )
    bal[1].y = 390
  end

  if (bal[2].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[2].x = math.random( 15, largura - 20 )
    bal[2].y = 390
  end  

  if (bal[3].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[3].x = math.random( 15, largura - 20 )
    bal[3].y = 390
  end  

  if (bal[4].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[4].x = math.random( 15, largura - 20 )
    bal[4].y = 390
  end  

  if (bal[5].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[5].x = math.random(15, largura - 20 )
    bal[5].y = 390
  end  

  if (bal[6].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[6].x = math.random( 15, largura - 20 )
    bal[6].y = 390
  end

  -------------------------------------------------------------------

  if (bal[7].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[7].x = math.random( metadeCentroX + 20, largura - 20 )
    bal[7].y = 390
  end

  if (bal[8].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[8].x = math.random( metadeCentroX + 20, largura - 20 )
    bal[8].y = 400
  end  

  if (bal[9].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[9].x = math.random( metadeCentroX + 20, largura - 20 )
    bal[9].y = 380
  end  

  if (bal[10].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[10].x = math.random( metadeCentroX + 20, largura - 20 )
    bal[10].y = 380
  end  

  if (bal[11].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[11].x = math.random( metadeCentroX + 20, largura - 20 )
    bal[11].y = 390
  end  

  if (bal[12].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    bal[12].x = math.random( metadeCentroX + 20, largura - 20 )
    bal[12].y = 400
  end      
end

function developed()
  
   local tamanho = {

    frames = {
    
        { x = 1, y = 1, width = 497, height = 110 }, -- dev1
        { x = 500, y = 1, width = 497, height = 110 }, -- dev2
        { x = 999, y = 1, width = 497, height = 110 }, -- dev3
        { x = 1498, y = 1, width = 497, height = 110 }, -- dev4
        { x = 1, y = 1, width = 497, height = 110 }, -- dev5
    },
    
    sheetContentWidth = 1996,
    sheetContentHeight = 112
  }

    local imagemSprite = graphics.newImageSheet( "graficos/sprites/developed.png", tamanho )
    local configImagem = {

      name = "dev",
      start = 1,
      count = 4,
      time = 20000,
      loopDirection = "forward",
      loopCount = 1
    }

    developer = display.newSprite( imagemSprite, configImagem )
    developer.xScale = .50
    developer.yScale = .50
    developer.x = metadeCentroX2Quad
    developer.y = metadeCentroY2Quad + 50
    developer.name = "desenvolvedor"
    scene.view:insert(developer)
    
end

function pausaSom()
    
    if (controle == false) then
        
        btnSom = display.newImage("graficos/botoes/btnSoundOff.png", 50, metadeCentroY2Quad + 50)
        btnSom.xScale = .7
        btnSom.yScale = .7
        scene.view:insert(btnSom)
        audio.pause( 6 )
        controle = true
    else
        display.remove(btnSom)
        audio.resume( 6 )
        controle = false
    end
end

function removeCenas()
   
   composer.removeScene( "jogos" )
   composer.removeScene( "menu" )
   composer.removeScene( "creditos" )
   composer.removeScene( "regras1" )
   composer.removeScene( "regras2" )
   composer.removeScene( "regras3" )
   composer.removeScene( "gameOver" )
   composer.removeScene( "splash" )
   --composer.removeScene( "vitoria" )
end

------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene