--require "CiderDebugger";
--==================================================================--|
------------------------ ARROWS & BALLONS ----------------------------|
--==================================================================--|
--                                                 >> 11/11/2015 << --|
-- Disciplina: Estágio Supervisionado I                             --|
-- Coordenador: Eduardo Mendes                                      --|
-- Aplicativio: Arrows & Ballons                                    --|
-- Versão: 3.0                                                      --|
-- Autor: Lucas Rodrigues Albuquerque                               --|
-- Contato: albuquerque.r.lucas@gmail.com                           --|
-- Phone: +55 85 9 9840-9203                                        --|
--==================================================================--|

-- Inclui o composer.
-----------------------------------------------------------------------
local composer = require( "composer" )

-- Variáveis Globais
-----------------------------------------------------------------------
numPontos = 0
numNivel = 1
numFlechas = 10
multiplicador = 0

pontosForGameOver = 0
nivelForGameOver = 1

-- Posicionamento em tela.
-----------------------------------------------------------------------
altura = display.contentHeight
largura = display.contentWidth
centroX = display.contentCenterX
centroY = display.contentCenterY
metadeCentroX = centroX / 2
metadeCentroY = centroY / 2
metadeCentroX2Quad = centroX + metadeCentroX
metadeCentroY2Quad = centroY + metadeCentroY

print( "Altura: " .. altura )
print( "Largura: " .. largura )

-- Audio.
-----------------------------------------------------------------------


-- Transição padrão de tela.
-----------------------------------------------------------------------
transicaoPadrao = { effect = "fade", time = 500 }
transicaoParaDireita = { effect = "fromRight", time = 1000 }
transicaoParaEsquerda = { effect = "fromLeft", time = 1000 }

-- Encerrar a aplicação.
-----------------------------------------------------------------------
function sair()
   
   native.requestExit( )
end

-- Carrega tela de Splash.
-----------------------------------------------------------------------
composer.gotoScene( "splash", transicaoPadrao )

