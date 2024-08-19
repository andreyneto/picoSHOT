-- Tabela para armazenar confetes
local confetes = {}

-- Função para inicializar confetes
function init_confetti()
    confetes = {}
    for i = 1, 50 do
        add(confetes, {
            x = flr(rnd(128)),  -- Posição X aleatória
            y = flr(rnd(64)),   -- Posição Y aleatória (começa na parte superior)
            speed = rnd(2) + 0.5, -- Velocidade de queda aleatória
            color = flr(rnd(16)) -- Cor aleatória
        })
    end
end

-- Função para atualizar confetes
function update_confetti()
    for conf in all(confetes) do
        conf.y += conf.speed  -- Atualiza a posição Y
        if conf.y > 128 then
            conf.y = 0  -- Reinicia o confete no topo se sair da tela
            conf.x = flr(rnd(128))  -- Nova posição X aleatória
        end
    end
end

-- Função para desenhar confetes
function draw_confetti()
    for conf in all(confetes) do
        rectfill(conf.x, conf.y, conf.x + 1, conf.y + 1, conf.color)  -- Desenha um pequeno quadrado
    end
end

game_over = {
    init = function ()
        global.game_state = "game_over"
        init_confetti()  -- Inicializa os confetes
    end,
    update = function()
        update_confetti()  -- Atualiza os confetes
        if btnp(4) then
            fade(false, function ()
                results.reset()
                menu.init()
            end)
        end
    end,
    draw = function()
        cls()
        pal()
        bg()
        palt(4,false)
        local posicao = #results.players + 1
        if(posicao <= 3) then
            local ttl
            if(posicao == 3) then
                ttl = "medalha de bronze"
                pal(4, 2, 1)
                pal(5, 136, 1)
                pal(10, 8, 1)
                pal(15, 14, 1)
                pal(11, 15, 1)
            elseif (posicao == 2) then
                pal(4, 5, 1)
                pal(5,13, 1)
                pal(10, 6, 1)
                pal(15, 7, 1)
                pal(11, 15, 1)
                ttl = "medalha de prata"
            elseif (posicao == 1) then
                pal(4, 137, 1)
                pal(5, 9, 1)
                pal(10, 10, 1)
                pal(15, 15, 1)
                pal(11, 7, 1)
                ttl = "medalha de ouro"
            end
            spr(13,52,48,3,4)
            title(ttl, flr(rnd(16)))
            draw_confetti()  -- Desenha os confetes
        else
            title("game over")
            printc(posicao.." COLOCADO", 52, 7)
            printc("vOCE FOI ELIMINADO.", 62, 7)
            printc("tENTE NOVAMENTE!", 72, 7)
        end
        actions(true)
    end
}