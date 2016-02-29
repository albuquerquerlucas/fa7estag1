--==================================================================--|
------------------------ ARROWS & BALLONS ------ ver. 3.0 ------------|
--==================================================================--|
--                                                 >> 11/11/2015 << --|
-- create by: Lucas Albuquerque                                     --|
--==================================================================--|

local composer = require( "composer" )
local graphics = require( "graphics")
local scene = composer.newScene()

-- Variáveis globais da classe.
local bLoader, cLoader
local tempo = 155

-- Funções de Chamada de Cena.
------------------------------------------------------------------------
function scene:create( event )

   local sceneGroup = self.view

   configBgSplash()
end

function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase


   if ( phase == "will" ) then
     
   elseif ( phase == "did" ) then
      configBarraLoader()
      configCarregaLoader()
      Runtime:addEventListener( "enterFrame", controlaTempo )
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
function configBgSplash()

	local bgSplash = display.newImage( "graficos/backgrounds/bgSplash.png", centroX, centroY )
		scene.view:insert(bgSplash)
end

function configBarraLoader()
   
   local tamanhoFramesLoader = { 
      
      frames = {
        { x = 1, y = 1, width = 678, height = 55 }, -- load1
        { x = 1, y = 58, width = 678, height = 55 }, -- load2
        { x = 681, y = 1, width = 678, height = 55 }, -- load3
        { x = 1361, y = 1, width = 678, height = 55 }, -- load4
        { x = 681, y = 58, width = 678, height = 55 }, -- load5
        { x = 1361, y = 58, width = 678, height = 55 }, -- load6
      },
    
       sheetContentWidth = 2040,
       sheetContentHeight = 114
   }

   local barraLoaderSprite = graphics.newImageSheet( "graficos/sprites/barraLoader.png",  tamanhoFramesLoader)
   local configSequenciaLoader = {
      {
         name = "loader",
         start = 1,
         count = 6,
         time = 5000,
         loopDirection = "forward",
         loopCount = 1 
      }
   }

   bLoader = display.newSprite( barraLoaderSprite, configSequenciaLoader )
   bLoader.xScale = .70
   bLoader.yScale = .70
   bLoader.x = centroX
   bLoader.y = centroY
   bLoader.name = "barraLoader"
   bLoader.isFixedRotation = true
   --bLoader:setSequence( "loader" )
   bLoader:play()

   scene.view:insert(bLoader)
end

function configCarregaLoader()
   
   local tamanhoFramesCarrega = {
      frames = {
    
        { x = 703, y = 1, width = 214, height = 39 }, -- carregando1
        { x = 478, y = 1, width = 223, height = 39 },  -- carregando2
        { x = 244, y = 1, width = 232, height = 39 }, -- carregando3
        { x = 1, y = 1, width = 241, height = 39 }, -- carregando4
      },
    
       sheetContentWidth = 918,
       sheetContentHeight = 41
   }

   local carregaSprite = graphics.newImageSheet( "graficos/sprites/carregarLoader.png",  tamanhoFramesCarrega)
   local configSequenciaCarrega = {
      {
         name = "carrega",
         start = 1,
         count = 6,
         time = 1000,
         --loopDirection = "forward", --bounce
         loopCount = 5 
      }
   }

   cLoader = display.newSprite( carregaSprite, configSequenciaCarrega )
   cLoader.xScale = .70
   cLoader.yScale = .70
   cLoader.x = centroX
   cLoader.y = centroY + 50
   cLoader.name = "carrega"
   cLoader.isFixedRotation = true
   --bLoader:setSequence( "loader" )
   cLoader:play() 

   scene.view:insert(cLoader)
end

function telaMenu()
   Runtime:removeEventListener( "enterFrame", controlaTempo )
   composer.removeScene( "splash" )
   composer.gotoScene( "menu", transicaoPadrao)
end

function controlaTempo( event )
   
   tempo = tempo - 1
   --print( tempo )

   if (tempo == 0) then
      telaMenu()

   end
end
------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene