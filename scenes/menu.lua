menu = {
    options = {"nOVO JOGO", "cOMO JOGAR"},
    selected = 1,
    rect_y = 72, -- Posição inicial do retângulo

    init = function()
        palt(0, true)
        global.game_state = "menu"
        menu.selected = 1
        menu.rect_y = 88 -- Inicializa a posição do retângulo
    end,

    update = function()
        -- Navega pelas opções do menu
        if btnp(2) then -- Cima
            sfxtick()
            menu.selected = menu.selected - 1
            if menu.selected < 1 then
                menu.selected = #menu.options
            end
        elseif btnp(3) then -- Baixo
            sfxtick()
            menu.selected = menu.selected + 1
            if menu.selected > #menu.options then
                menu.selected = 1
            end
        end

        -- Calcula a posição alvo do retângulo
        local target_y = 88 + (menu.selected - 1) * 10
        menu.rect_y = menu.rect_y + (target_y - menu.rect_y) * 0.2

        -- Seleciona a opção do menu
        if btnp(4) then -- Botão Z
            sfxok()
            if menu.selected == 1 then
                fade(true, function ()
                   global.game_state = "select_character" 
                end)
            elseif menu.selected == 2 then
                fade(true, function ()
                    how_to_play.init()
                end)
            end
        end
    end,

    draw = function()
        cls()
        local logoy = 20
        bg(logoy, 45)
        spr(0,13,logoy+5,13,4)
        line(25,logoy+4,25,logoy+4,7)

        for i, option in ipairs(menu.options) do
            if i == menu.selected then
                -- Calcula a posição x para centralizar o retângulo
                local text_width = #option * 4
                local x_position = 64 - text_width / 2
                -- Desenha o retângulo preto atrás da opção selecionada
                rectfill(x_position - 4, menu.rect_y, x_position + text_width + 2, menu.rect_y + 6, 8)
            end
        end
        for i, option in ipairs(menu.options) do
            local y_position = 88 + (i - 1) * 10
            printc(option, y_position, 7)
        end
        actions(true)
    end
}