--==================================================================--|
------------------------ ARROWS & BALLONS ------ ver. 3.0 ------------|
--==================================================================--|
--                                                 >> 11/11/2015 << --|
-- create by: Lucas Albuquerque                                     --|
--==================================================================--|

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local graphics = require("graphics")
local physycs = require( "physics")
physics.start( )
--physics.setScale(25)
--physics.setDrawMode( "hybrid" ) 

-- Variáveis globais da classe.
local somJogo = audio.loadStream( "audio/jogoSong.ogg" )
local somFlecha = audio.loadStream( "audio/shoot.ogg" )
local somBalao = audio.loadStream( "audio/estouroBalao.ogg" )
somNivel = audio.loadStream( "audio/nivel.ogg" )
local btnSom, btnInicio, btnFire, btnCod
local placaNivelUp, pressione
local balaoAzul, balaoAmarelo, balaoVermelho, balaoVerde, balaoRosa, balaoLaranja
local baloes = {}
local teto = -10
local piso
local txtPontuacao, txtNivel, txtFlechas
local fontePlacar = "fontes/SIGNBOAR.TTF"
local nuvens = { n1, n2, n3, n4, n5 }
local jogadorImagem
local flecha
local controle = false
local cod = 0
pontosForGameOver = 0
nivelForGameOver = 1
numFlechas = 10

-- Funções de Chamada de Cena.
------------------------------------------------------------------------
function scene:create( event )

   local sceneGroup = self.view
   
   audio.play( somJogo , {loops = -1, channel = 2} )

   removeCenas()
   configuraBackground()
   configuraMonte()
   criaNuvens()
   
   configuraJogador()
   configuraBalaoAzul()
   configuraBalaoAmarelo()
   configuraBalaoVermelho()
   configuraBalaoVerde()
   configuraBalaoRosa()
   configuraBalaoLaranja()
   configuraPontuacao()
   configuraBotoes()
   nivelUp()
   pressioneAqui()

   --print("Pontos: " .. numPontos)
   --print("Multiplicador: " .. numPontos)
   

end

function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   
   removeCenas()
   
   
   if ( phase == "will" ) then
     
   elseif ( phase == "did" ) then
    
    pressione:play()
    btnCod:addEventListener( "tap", codigos )
    btnSom:addEventListener( "tap", pausaSom )
    
    Runtime:addEventListener( "enterFrame", configuraNuvens )
    Runtime:addEventListener( "enterFrame", movimentaBalaoAzul)
    Runtime:addEventListener( "enterFrame", movimentaBalaoAmarelo)
    Runtime:addEventListener( "enterFrame", movimentaBalaoVermelho)
    Runtime:addEventListener( "enterFrame", movimentaBalaoVerde)
    Runtime:addEventListener( "enterFrame", movimentaBalaoRosa)
    Runtime:addEventListener( "enterFrame", movimentaBalaoLaranja)
    Runtime:addEventListener( "collision", acertaBalao )
    btnInicio:addEventListener( "tap", telaMenu )
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
   
   local imagemFundo = display.newImage("graficos/backgrounds/bgJogo.png", centroX, centroY)
         imagemFundo.xScale = .7
         imagemFundo.yScale = .7
         scene.view:insert(imagemFundo)
    end

function configuraBotoes()
   
   btnSom = display.newImage("graficos/botoes/btnSoundOn.png", 600, metadeCentroY2Quad)
   btnSom.xScale = .7
   btnSom.yScale = .7
   scene.view:insert(btnSom)

   btnInicio = display.newImage("graficos/botoes/btnSair.png", 600, metadeCentroY2Quad + 50) -- Pocisao original 105
   btnInicio.xScale = .7
   btnInicio.yScale = .7
   scene.view:insert(btnInicio)

   btnCod = display.newCircle( 610, 25, 20)
   btnCod.alpha = 0.01
   scene.view:insert(btnCod)

   function atirar( event )
      if ( "ended" == event.phase ) then
        jogadorImagem:play()
        audio.play( somFlecha , {loops = 0, channel = 7} )
        atiraFlecha()
      end
   end

   btnFire = widget.newButton( {

    width = 50,
    height = 50,  
    defaultFile = "graficos/botoes/btnFireOn.png",
    overFile = "graficos/botoes/btnFireOff.png",
    onRelease = atirar
    } )

    btnFire.x = metadeCentroX - 90
    btnFire.y = metadeCentroY2Quad + 50
    scene.view:insert(btnFire)
end

function configuraPontuacao()
    
    local qtdPontuacao = display.newImage( "graficos/componentes/placPontos.png" )
         qtdPontuacao.xScale = .6
         qtdPontuacao.yScale = .6
         qtdPontuacao.x = metadeCentroX - 42
         qtdPontuacao.y = 35
         scene.view:insert(qtdPontuacao)

         txtPontuacao = display.newText( "0", metadeCentroX - 42, 48, fontePlacar,  20)
         txtPontuacao:setFillColor( 255, 0, 0 )
         scene.view:insert(txtPontuacao)

    local qtdNivel = display.newImage( "graficos/componentes/placNivel.png" )
         qtdNivel.xScale = .6
         qtdNivel.yScale = .6
         qtdNivel.x = centroX
         qtdNivel.y = 33
         scene.view:insert(qtdNivel)

         txtNivel = display.newText( "01", centroX, 48, fontePlacar,  20)
         txtNivel:setFillColor( 255, 0, 0 )
         scene.view:insert(txtNivel)

   local qtdFlechas = display.newImage( "graficos/componentes/placFlechas.png" )
         qtdFlechas.xScale = .6
         qtdFlechas.yScale = .6
         qtdFlechas.x = metadeCentroX2Quad + 42
         qtdFlechas.y = 35
         scene.view:insert(qtdFlechas)

         txtFlechas = display.newText( "10", metadeCentroX2Quad + 42, 48, fontePlacar,  20)
         txtFlechas:setFillColor( 255, 0, 0 )
         scene.view:insert(txtFlechas)
end

function pressioneAqui()
  
  local tamanho = {

    frames = {
    
        { x=1, y=1, width=294, height=79 }, -- p1
        { x=297, y=1, width=294, height=79 }, -- p2
        { x=593, y=1, width=294, height=79 }, -- p3
        { x=889, y=1, width=294, height=79 }, -- p4
        { x = 1, y = 1, width = 294, height = 79 }, -- p5
    },
    
    sheetContentWidth = 1184,
    sheetContentHeight = 81
  }

    local imagemSprite = graphics.newImageSheet( "graficos/sprites/pressione.png", tamanho )
    local configImagem = {

      name = "pressionneAqui",
      start = 1,
      count = 5,
      time = 1000,
      loopDirection = "forward",
      loopCount = 50
    }

    pressione = display.newSprite( imagemSprite, configImagem )
    pressione.xScale = .50
    pressione.yScale = .50
    pressione.x = metadeCentroX + 20
    pressione.y = metadeCentroY2Quad + 10
    pressione.name = "pressione"
    scene.view:insert(pressione)
end

function nivelUp()
  
  local tamanho = {

    frames = {
    
        { x = 585, y = 1, width = 290, height = 66 }, -- img1
        { x = 877, y = 1, width = 290, height = 66 }, -- img2
        { x = 1, y = 1, width = 290, height = 67 }, -- img3
        { x = 293, y = 1, width = 290, height = 67 }, -- img4
        { x = 585, y = 1, width = 290, height = 66 }, -- img5
    },
    
    sheetContentWidth = 1168,
    sheetContentHeight = 69
  }

    local imagemSprite = graphics.newImageSheet( "graficos/sprites/nivelUp.png", tamanho )
    local configImagem = {

      name = "nivelUp",
      start = 1,
      count = 5,
      time = 800,
      loopDirection = "forward",
      loopCount = 3
    }

    placaNivelUp = display.newSprite( imagemSprite, configImagem )
    placaNivelUp.xScale = .50
    placaNivelUp.yScale = .50
    placaNivelUp.x = centroX
    placaNivelUp.y = centroY - 50
    placaNivelUp.name = "placNivelUp"
    scene.view:insert(placaNivelUp)
    --placaNivelUp:play()
  
end

function setaFlechas()
   
   numFlechas = numFlechas - 1
   txtFlechas.text = string.format( "%d" , numFlechas )
end

function setaNivel()

   placaNivelUp:play()
   numNivel = numNivel + 1
   txtNivel.text = string.format( "%d" , numNivel )     
end

function somaPontos(multiplicador)
   
   numPontos = numPontos + multiplicador
   txtPontuacao.text = string.format( "%d" , numPontos )
   print("Num Pontos: " .. numPontos)

   if (numPontos >= 50) then
      telaVitoria()
   end
end

function subtraiPontos(multiplicador)
   
   numPontos = numPontos - multiplicador
   txtPontuacao.text = string.format( "%d" , numPontos )

   print("Num Pontos: " .. numPontos)

   if (numPontos >= 50) then
      telaVitoria()
   end
end

function anulaPontos(multiplicador)
   
   numPontos = multiplicador 
   txtPontuacao.text = string.format( "%d" , numPontos )
end

function setaPontos( tipo, multiplicador, pontos)


  if (tipo == 1) then

      somaPontos(multiplicador)
   elseif (tipo == 2) then

      subtraiPontos(multiplicador)
   elseif (tipo == 3) then

      anulaPontos(multiplicador)
   end

  if (numPontos >= pontos) then

    audio.play( somNivel , {loops = 0, channel = 9} )
    txtPontuacao.text = "0"
    numPontos = 0
    setaNivel()
    txtFlechas.text = "10"
    numFlechas = 10
  end  
end

function verificaNivelPontuacao( tipo, multiplicador )
  
  if (numNivel >= 0 and numNivel == 1) then
         setaPontos( tipo, multiplicador, 6 )
      elseif (numNivel == 2) then
         setaPontos( tipo, multiplicador, 8 )
      elseif (numNivel == 3) then
         setaPontos( tipo, multiplicador, 10 )
      elseif (numNivel == 4) then
         setaPontos( tipo, multiplicador, 12 )
      elseif (numNivel == 5) then
         setaPontos( tipo, multiplicador, 16 )
      elseif (numNivel == 6) then
         setaPontos( tipo, multiplicador, 18 )
      elseif (numNivel == 7) then
         setaPontos( tipo, multiplicador, 20 )
      elseif (numNivel == 8) then
         setaPontos( tipo, multiplicador, 22)
      elseif (numNivel == 9) then
         setaPontos( tipo, multiplicador, 24)
      elseif (numNivel == 10) then
         setaPontos( tipo, multiplicador, 30)
      elseif (numNivel == 11) then
         setaPontos( tipo, multiplicador, 36)
      elseif (numNivel == 12) then
         setaPontos( tipo, multiplicador, 50)
      --elseif (numNivel == 13) then
          --telaVitoria()      
  end
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

function configuraMonte()
    
    local monte = display.newImage( "graficos/componentes/monte.png", metadeCentroX - 165, metadeCentroY2Quad + 30)
        monte.xScale = .50
        monte.yScale = .50
        scene.view:insert(monte)
end

function configuraFlecha()
  
  flecha = display.newImage( "graficos/componentes/flecha5.png", centroX - 250, centroY - 2)
  flecha.name = "flecha"
  physics.addBody( flecha, {density = 1, friction = 0})
  flecha.rotation = -8
  flecha.isFixedRotation = false
  flecha.isbullet = true
  flecha:applyLinearImpulse( 0, -2, flecha.x - 1, flecha.y )
  scene.view:insert(flecha)
end

function atiraFlecha()
  
  pressione:setFrame( 1 )
  pressione:pause( )
  setaFlechas()

  if (numFlechas >= 0) then
    configuraFlecha()
    
    transition.to( flecha, { time=1000, x= 700 } )
  else
    telaGameOver()
  end
end

function configuraJogador()
  
  local tamanhoImagem = {
        
    frames = {
    
      { x = 958, y = 1, width = 475, height = 792 }, -- jogador1
      { x = 1, y = 1, width = 477, height = 792 }, -- jogador2
      { x = 480, y = 1, width = 476, height = 792 }, -- jogador3
      { x = 958, y = 1, width = 475, height = 792 } -- jogador4
    },
    
    sheetContentWidth = 1434,
    sheetContentHeight = 794
  }
    
    local imagemSprite = graphics.newImageSheet( "graficos/componentes/jogador.png", tamanhoImagem )
    local configImagem = {
        
        name = "jogador",
        start = 1,
        count = 4,
        time = 500,
        loopDirection = "forward",
        loopCount = 1 
    }
  
   jogadorImagem = display.newSprite( imagemSprite, configImagem )
   jogadorImagem.xScale = .20
   jogadorImagem.yScale = .20
   jogadorImagem.x = metadeCentroX - 80
   jogadorImagem.y = centroY + 20
   jogadorImagem.name = "iJogador"
   scene.view:insert(jogadorImagem)
end

function configuraBalaoAzul()

  local tamanho = {

    frames = {

        { x = 1, y = 1, width = 30, height = 45 }, -- balaoAzul
        { x = 33, y = 1, width = 35, height = 35 }, -- fumaca1
        { x = 70, y = 1, width = 35, height = 33, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca2
        { x = 70, y = 36, width = 35, height = 27, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca3
        { x = 33, y = 36, width = 35, height = 33 } -- sem fumaca
    },

    sheetContentWidth = 106,
    sheetContentHeight = 64
  }

  local balaoAzulSprite = graphics.newImageSheet( "graficos/baloes/balaoAzul.png", tamanho )
  local configBAzulSprite = {
      
      name = "bbAzul",
      start = 1,
      count = 5,
      time = 800,
      loopDirection = "forward",
      loopCount = 1 
  }

  balaoAzul = display.newSprite( balaoAzulSprite, configBAzulSprite )

  baloes[1] = balaoAzul
  baloes[1].x = math.random( metadeCentroX + 60, largura - 20 )
  baloes[1].y = 390
  baloes[1].name = "bAzul"
  
  physics.addBody( baloes[1], "kinematic")
  baloes[1].isSensor = true
  scene.view:insert(baloes[1])
end

function movimentaBalaoAzul()

  baloes[1].y = baloes[1].y - 1

  if (baloes[1].y < -10) then
    --print("chegou ao topo")
    --Runtime:removeEventListener("enterFrames", movimentaBalaoAzul)
    baloes[1].x = math.random( metadeCentroX + 60, largura - 20 )
    baloes[1].y = 390
    baloes[1]:setFrame( 1 )
  end
end

function configuraBalaoAmarelo()
  
  local tamanho = {

    frames = {

        { x = 1, y = 1, width = 30, height = 45 }, -- balaoAzul
        { x = 33, y = 1, width = 35, height = 35 }, -- fumaca1
        { x = 70, y = 1, width = 35, height = 33, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca2
        { x = 70, y = 36, width = 35, height = 27, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca3
        { x = 33, y = 36, width = 35, height = 33 } -- sem fumaca
    },

    sheetContentWidth = 106,
    sheetContentHeight = 64
  }

  local balaoAmareloSprite = graphics.newImageSheet( "graficos/baloes/balaoAmarelo.png", tamanho )
  local configBAmareloSprite = {
      
      name = "bbAmarelo",
      start = 1,
      count = 5,
      time = 800,
      loopDirection = "forward",
      loopCount = 1 
  }

  balaoAmarelo = display.newSprite( balaoAmareloSprite, configBAmareloSprite )

  baloes[2] = balaoAmarelo
  baloes[2].x = math.random( metadeCentroX + 60, largura - 20 )
  baloes[2].y = 390
  baloes[2].name = "bAmarelo"
  
  physics.addBody( baloes[2], "kinematic" )
  baloes[2].isSensor = true
  scene.view:insert(baloes[2])
end

function movimentaBalaoAmarelo()
  
  baloes[2].y = baloes[2].y - 1.5

  if(baloes[2].y < -10) then

    --Runtime:removeEventListener("enterFrame", movimentaBalaoAmarelo)
    baloes[2].x = math.random( metadeCentroX + 60, largura - 20 )
    baloes[2].y = 390
    baloes[2]:setFrame( 1 )
  end
end

function configuraBalaoVermelho()
  
  local tamanho = {

    frames = {

        { x = 1, y = 1, width = 30, height = 45 }, -- balaoAzul
        { x = 33, y = 1, width = 35, height = 35 }, -- fumaca1
        { x = 70, y = 1, width = 35, height = 33, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca2
        { x = 70, y = 36, width = 35, height = 27, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca3
        { x = 33, y = 36, width = 35, height = 33 } -- sem fumaca
    },

    sheetContentWidth = 106,
    sheetContentHeight = 64
  }

  local balaoVermelhoSprite = graphics.newImageSheet( "graficos/baloes/balaoVermelho.png", tamanho )
  local configBVermelhoSprite = {
      
      name = "bbVermelho",
      start = 1,
      count = 5,
      time = 800,
      loopDirection = "forward",
      loopCount = 1 
  }

  balaoVermelho = display.newSprite( balaoVermelhoSprite, configBVermelhoSprite )

  baloes[3] = balaoVermelho
  baloes[3].x = math.random( metadeCentroX + 60, largura - 20 )
  baloes[3].y = 390
  baloes[3].name = "bVermelho"
  
  physics.addBody( baloes[3], "kinematic" )
  baloes[3].isSensor = true
  scene.view:insert(baloes[3])
end

function movimentaBalaoVermelho()
  
  baloes[3].y = baloes[3].y - 1.8

  if(baloes[3].y < -10) then

    --Runtime:removeEventListener("enterFrame", movimentaBalaoAmarelo)
    baloes[3].x = math.random( metadeCentroX + 60, largura - 20 )
    baloes[3].y = 390
    baloes[3]:setFrame( 1 )
  end
end

function configuraBalaoVerde()
  
  local tamanho = {

    frames = {

        { x = 1, y = 1, width = 30, height = 45 }, -- balaoAzul
        { x = 33, y = 1, width = 35, height = 35 }, -- fumaca1
        { x = 70, y = 1, width = 35, height = 33, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca2
        { x = 70, y = 36, width = 35, height = 27, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca3
        { x = 33, y = 36, width = 35, height = 33 } -- sem fumaca
    },

    sheetContentWidth = 106,
    sheetContentHeight = 64
  }

  local balaoVerdeSprite = graphics.newImageSheet( "graficos/baloes/balaoVerde.png", tamanho )
  local configBVerdeSprite = {
      
      name = "bbVerde",
      start = 1,
      count = 5,
      time = 800,
      loopDirection = "forward",
      loopCount = 1 
  }

  balaoVerde = display.newSprite( balaoVerdeSprite, configBVerdeSprite )

  baloes[4] = balaoVerde
  baloes[4].x = math.random( metadeCentroX + 60, largura - 20 )
  baloes[4].y = 390
  baloes[4].name = "bVerde"
  
  physics.addBody( baloes[4], "kinematic" )
  baloes[4].isSensor = true
  scene.view:insert(baloes[4])
end

function movimentaBalaoVerde()
  
  baloes[4].y = baloes[4].y - 2

  if(baloes[4].y < -10) then

    --Runtime:removeEventListener("enterFrame", movimentaBalaoAmarelo)
    baloes[4].x = math.random( metadeCentroX + 60, largura - 20 )
    baloes[4].y = 390
    baloes[4]:setFrame( 1 )
  end
end

function configuraBalaoRosa()
  
  local tamanho = {

    frames = {

        { x = 1, y = 1, width = 30, height = 45 }, -- balaoAzul
        { x = 33, y = 1, width = 35, height = 35 }, -- fumaca1
        { x = 70, y = 1, width = 35, height = 33, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca2
        { x = 70, y = 36, width = 35, height = 27, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca3
        { x = 33, y = 36, width = 35, height = 33 } -- sem fumaca
    },

    sheetContentWidth = 106,
    sheetContentHeight = 64
  }

  local balaoRosaSprite = graphics.newImageSheet( "graficos/baloes/balaoRosa.png", tamanho )
  local configBRosaSprite = {
      
      name = "bbRosa",
      start = 1,
      count = 5,
      time = 800,
      loopDirection = "forward",
      loopCount = 1 
  }

  balaoRosa = display.newSprite( balaoRosaSprite, configBRosaSprite )

  baloes[5] = balaoRosa
  baloes[5].x = math.random( metadeCentroX + 60, largura - 20 )
  baloes[5].y = 390
  baloes[5].name = "bRosa"
  
  physics.addBody( baloes[5], "kinematic" )
  baloes[5].isSensor = true
  scene.view:insert(baloes[5])
end

function movimentaBalaoRosa()
  
  baloes[5].y = baloes[5].y - 2.4

  if(baloes[5].y < -10) then

    --Runtime:removeEventListener("enterFrame", movimentaBalaoAmarelo)
    baloes[5].x = math.random( metadeCentroX + 60, largura - 20 )
    baloes[5].y = 390
    baloes[5]:setFrame( 1 )
  end
end

function configuraBalaoLaranja()
  
  local tamanho = {

    frames = {

        { x = 1, y = 1, width = 30, height = 45 }, -- balaoAzul
        { x = 33, y = 1, width = 35, height = 35 }, -- fumaca1
        { x = 70, y = 1, width = 35, height = 33, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca2
        { x = 70, y = 36, width = 35, height = 27, sourceX = 0, sourceY = 0, sourceWidth = 35, sourceHeight = 35 }, -- fumaca3
        { x = 33, y = 36, width = 35, height = 33 } -- sem fumaca
    },

    sheetContentWidth = 106,
    sheetContentHeight = 64
  }

  local balaoRosaSprite = graphics.newImageSheet( "graficos/baloes/balaoLaranja.png", tamanho )
  local configBRosaSprite = {
      
      name = "bbLaranja",
      start = 1,
      count = 5,
      time = 800,
      loopDirection = "forward",
      loopCount = 1 
  }

  balaoLaranja = display.newSprite( balaoRosaSprite, configBRosaSprite )

  baloes[6] = balaoLaranja
  baloes[6].x = math.random( metadeCentroX + 60, largura - 20 )
  baloes[6].y = 390
  baloes[6].name = "bLaranja"
  
  physics.addBody( baloes[6], "kinematic" )
  baloes[6].isSensor = true
  scene.view:insert(baloes[6])
end

function movimentaBalaoLaranja()
  
  baloes[6].y = baloes[6].y - 1.3

  if(baloes[6].y < -10) then

    --Runtime:removeEventListener("enterFrame", movimentaBalaoAmarelo)
    baloes[6].x = math.random( metadeCentroX + 60, largura - 20 )
    baloes[6].y = 390
    baloes[6]:setFrame( 1 )
  end
end

function acertaBalao(event)
  
  if(event.phase == "began" and event.object1.name == "bAzul") then
      print("colidiu com " .. event.object1.name)
      
      verificaNivelPontuacao( 1, 2 )
      audio.play( somBalao , {loops = 0, channel = 8} )
      baloes[1]:play()
  end

  if(event.phase == "began" and event.object1.name == "bAmarelo") then
      print("colidiu com " .. event.object1.name)
      
      verificaNivelPontuacao( 1, 1 )
      audio.play( somBalao , {loops = 0, channel = 8} )
      baloes[2]:play()
  end

  if(event.phase == "began" and event.object1.name == "bVermelho") then
      print("colidiu com " .. event.object1.name)
      
      verificaNivelPontuacao( 3, 0 )
      audio.play( somBalao , {loops = 0, channel = 8} )
      baloes[3]:play()
  end

  if(event.phase == "began" and event.object1.name == "bVerde") then
      print("colidiu com " .. event.object1.name)
      
      verificaNivelPontuacao( 1, 5 )
      audio.play( somBalao , {loops = 0, channel = 8} )
      baloes[4]:play()
  end

  if(event.phase == "began" and event.object1.name == "bRosa") then
      print("colidiu com " .. event.object1.name)
      
      verificaNivelPontuacao( 2, 2 )
      audio.play( somBalao , {loops = 0, channel = 8} )
      baloes[5]:play()
  end

  if(event.phase == "began" and event.object1.name == "bLaranja") then
      print("colidiu com " .. event.object1.name)
      
      verificaNivelPontuacao( 2, 8 )
      audio.play( somBalao , {loops = 0, channel = 8} )
      baloes[6]:play()
  end
end

function telaVitoria()
  
   audio.stop( 2 )
   audio.stop( 7 )
   audio.stop( 8 )
   audio.stop( 9 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoAzul )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoAmarelo )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoVermelho )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoVerde )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoRosa )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoLaranja )
   Runtime:removeEventListener( "collision", acertaBalao )
   numNivel = 1
   numPontos = 0
   multiplicador = 0
   pontosForGameOver = 0
   nivelForGameOver = 1
   cod = 0

   --guardaValor[1] = baloes[1]
   --physics.stop( )
   --physics.removeBody( baloes[1] )
   composer.removeScene( "jogo" )
   composer.gotoScene( "vitoria", transicaoPadrao )
end

function telaMenu()
   
   audio.stop( 2 )
   audio.stop( 7 )
   audio.stop( 8 )
   audio.stop( 9 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoAzul )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoAmarelo )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoVermelho )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoVerde )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoRosa )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoLaranja )
   Runtime:removeEventListener( "collision", acertaBalao )
   numNivel = 1
   numPontos = 0
   multiplicador = 0
   pontosForGameOver = 0
   nivelForGameOver = 1
   cod = 0

   --guardaValor[1] = baloes[1]
   physics.stop( )
   composer.removeScene( "jogo" )
   composer.gotoScene( "menu", transicaoPadrao )   
end

function telaGameOver()
    
    
   pontosForGameOver = numPontos
   nivelForGameOver = numNivel
   numNivel = 1
   numPontos = 0
   multiplicador = 0
   cod = 0
   audio.stop( 2 )
   audio.stop( 7 )
   audio.stop( 8 )
   audio.stop( 9 )
   Runtime:removeEventListener( "enterFrame", configuraNuvens )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoAzul )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoAmarelo )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoVermelho )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoVerde )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoRosa )
   Runtime:removeEventListener( "enterFrame", movimentaBalaoLaranja )
   Runtime:removeEventListener( "collision", acertaBalao )

   physics.stop( )
   --physics.removeBody( baloes[1] )

   composer.removeScene( "jogo" )
   composer.gotoScene( "gameOver", transicaoPadrao )   
end

function pausaSom()
    
    if (controle == false) then
        
        btnSom = display.newImage("graficos/botoes/btnSoundOff.png", 600, metadeCentroY2Quad)
        btnSom.xScale = .7
        btnSom.yScale = .7
        scene.view:insert(btnSom)
        audio.pause( 2 )
        controle = true
    else
        display.remove(btnSom)
        btnSom = nil
        audio.resume( 2 )
        controle = false
    end
end

function codigos()

  cod = cod + 1

  if (cod == 10) then

    numPontos = 0
    txtPontuacao.text = string.format( "%d" , numPontos )  


    somaPontos(49)
    placaNivelUp:play()
    audio.play( somNivel , {loops = 0, channel = 9} )
    numNivel = 12
    txtNivel.text = string.format( "%d" , numNivel )
    btnCod:removeEventListener( "tap", codigos )
  end

  print(cod)
  print("Numero de Pontos: " .. numPontos)
end

function removeCenas()
   
   composer.removeScene( "menu" )
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