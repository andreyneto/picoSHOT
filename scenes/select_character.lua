select_character = {
    scroll_offset = 0,
    target_scroll_offset = 0,
    selected_index = 1,
    arrow_y_offset = 0,
    arrow_oscillation_speed = 1,
    arrow_oscillation_amplitude = 2,
    characters = {
        {
            name = "eMMA",
            nationality = "Canadense",
            flag = 191,
            spr = 70,
            sm = 124,
            precision = 50,
            oscillation_speed = 1,
            description = "A CALMA GLACIAL, EQUILIBRIO PERFEITO",
            adjust_speed = 1,
            precision_recovery_rate = 7.5,
            precision_decay_rate = 0.75,
            oscillation_deceleration = 0.975,
            randomness_factor = 1
        },
        {
            name = "vIKTOR",
            nationality = "Russo",
            flag = 79,
            spr = 64,
            sm = 76,
            precision = 75,
            oscillation_speed = 1,
            description = "O SNIPER DO GELO, FRIEZA E PRECISAO",
            adjust_speed = 1,
            precision_recovery_rate = 7.5,
            precision_decay_rate = 0.7,
            oscillation_deceleration = 0.975,
            randomness_factor = 0.8
        },
        {
            name = "aKIRA",
            nationality = "Japonês",
            flag = 95,
            spr = 160,
            sm = 172,
            precision = 25,
            oscillation_speed = 1,
            description = "O SAMURAI, VELOCIDADE E DISCIPLINA",
            adjust_speed = 1,
            precision_recovery_rate = 7.5,
            precision_decay_rate = 0.75,
            oscillation_deceleration = 0.975,
            randomness_factor = 1
        },
        {
            name = "hANS",
            nationality = "Alemão",
            flag = 111,
            spr = 166,
            sm = 220,
            precision = 90,
            oscillation_speed = 1,
            description = "O ENGENHEIRO, PRECISAO METICULOSA",
            adjust_speed = 1,
            precision_recovery_rate = 7.5,
            precision_decay_rate = 0.75,
            oscillation_deceleration = 0.975,
            randomness_factor = 0.2
        },
                -- {
        --     name = "sOPHIE",
        --     nationality = "Francesa",
        --     flag = 52,
        --     spr = 65,
        --     precision = 50,
        --     oscillation_speed = 1,
        --     description = "A ARTISTA,ELEGANCIA E PRECISAO",
        --     adjust_speed = 1,
        --     precision_recovery_rate = 5,
        --     precision_decay_rate = 0.75,
        --     oscillation_deceleration = 0.975,
        --     randomness_factor = 1
        -- },
        -- {
        --     name = "yE-JI",
        --     nationality = "Coreana",
        --     flag = 53,
        --     precision = 50,
        --     oscillation_speed = 1,
        --     description = "A FUTURISTA,TECNOLOGIA E PRECISAO",
        --     adjust_speed = 0.9,
        --     precision_recovery_rate = 5,
        --     precision_decay_rate = 0.75,
        --     oscillation_deceleration = 0.975,
        --     randomness_factor = 1
        -- },
        -- {
        --     name = "yUSUF",
        --     nationality = "Turco",
        --     flag = 54,
        --     precision = 50,
        --     oscillation_speed = 1,
        --     description = "O SIMPLES,EFICACIA E DETERMINACAO",
        --     adjust_speed = 1,
        --     precision_recovery_rate = 5,
        --     precision_decay_rate = 0.75,
        --     oscillation_deceleration = 0.975,
        --     randomness_factor = 1
        -- },
        -- {
        --     name = "nASCIMENTO",
        --     nationality = "Brasileiro",
        --     flag = 55,
        --     precision = 50,
        --     oscillation_speed = 1,
        --     description = "O CAPITAO,ESTRATEGIA E AUTORIDADE",
        --     adjust_speed = 1,
        --     precision_recovery_rate = 5,
        --     precision_decay_rate = 0.75,
        --     oscillation_deceleration = 0.975,
        --     randomness_factor = 1
        -- }
    },

    update = function()
        local total_characters = #select_character.characters
        if btnp(2) then  -- Cima
            if select_character.selected_index > 1 then
                select_character.selected_index -= 1
                select_character.target_scroll_offset = select_character.target_scroll_offset - 1
            end
        elseif btnp(3) then  -- Baixo
            if select_character.selected_index < total_characters then
                select_character.selected_index += 1
                select_character.target_scroll_offset = select_character.target_scroll_offset + 1
            end
        end

        -- Interpolação para efeito de rolagem suave
        select_character.scroll_offset += (select_character.target_scroll_offset - select_character.scroll_offset) * 0.1

        -- Atualiza a oscilação da seta
        select_character.arrow_y_offset = select_character.arrow_oscillation_amplitude * sin(time() * select_character.arrow_oscillation_speed)

        if btnp(4) then
            fade(true, function ()
                player = select_character.characters[select_character.selected_index]
                title_screen.init()
            end)
        end

        if btnp(❎) then
            fade(false, function ()
                menu.init()
            end)
        end
    end,

    draw = function()
        cls()
        palt(0, false)
        rectfill(0,0,127,127,9)
        rectfill(0,32,127,127-32,14)
        pal(9,129,1)
        pal(14,140,1)
        local list_start_x = 8
        local list_start_y = 40
        local sprite_w = 48
        local sprite_h = 48
        local spacing = 16

        for i, character in ipairs(select_character.characters) do
            -- Calcula a posição y do personagem, ajustada pelo scroll_offset
            local x = list_start_x
            local y = list_start_y + (i - 1 - select_character.scroll_offset) * (sprite_h + spacing)

            -- Desenhe o sprite do personagem
            spr(character.spr or 1, x, y, sprite_w/8, sprite_h/8)
            spr(character.sm or 1, x+12, y+12, 3, 3)

            -- Destaque o personagem selecionado
            if i == select_character.selected_index then
                rect(x, y, x + sprite_w - 1, y + sprite_h - 1, 7) -- Retângulo de destaque
            end
        end

        -- Informações do personagem selecionado
        local character = select_character.characters[select_character.selected_index]
        local x = list_start_x
        local y = list_start_y
        print(character.name, x + 52, y, 7)

        -- Dividir a descrição em linhas de até 15 caracteres
        local description_parts = split_description(character.description)
        for i, line in ipairs(description_parts) do
            print(line, x + 52, y + 15 + (i - (#description_parts > 3 and 2 or 1)) * 5, 7)
        end
        spr(character.flag, 112, y-2)
        select_character.draw_bar("VELOCIDADE", max(0, min(100, flr((character.oscillation_speed / 2) * 100))), 128-8-16-1, y+40, 16, 3)
        select_character.draw_bar("PRECISAO", character.precision, 128-8-16-1, y + 45, 16, 3)

        -- Desenhar a seta oscilante no canto inferior direito
        local arrow_x = 88
        local arrow_y = 26 + select_character.arrow_y_offset
        if(select_character.selected_index > 1) print("⬆️", arrow_x, arrow_y)
        arrow_y = 98 - select_character.arrow_y_offset
        if(select_character.selected_index < #select_character.characters) print("⬇️", arrow_x, arrow_y)

        print("ok🅾️", 105, 115, 7)
        print("❎voltar", 48 + 4 + 8, 115, 7)
    end,

    draw_bar = function(lbl, percentage, x, y, width, height)
        rect(x, y, x + width, y + height, 6)
        rectfill(x, y, x + (percentage/100) * width, y + height, 8)
        print(lbl, x-(#lbl*4), y-1, 7)
    end,
}

-- Função para dividir a descrição em linhas de até 15 caracteres, quebrando no espaço
function split_description(description)
    local max_chars_per_line = 14
    local lines = {}
    local current_line = ""

    for word in all(split(description, " ")) do
        if #current_line + #word <= max_chars_per_line then
            if #current_line > 0 then
                current_line = current_line .. " " .. word
            else
                current_line = word
            end
        else
            add(lines, current_line)
            current_line = word
        end
    end

    if #current_line > 0 then
        add(lines, current_line)
    end

    return lines
end