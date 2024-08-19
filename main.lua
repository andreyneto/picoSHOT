-- Tabela de estados
states = {
    menu = menu,
    select_character = select_character,
    title_screen = title_screen,
    how_to_play = how_to_play,
    shots = shots,
    classification = classification,
    game_over = game_over,
    results = results,
}
global = {
    game_state = "menu"
}

fade_anim=0
fade_out=false
fading=false
fade_func=nil

function fade(inout, f)
	fade_anim=0
	fading=true
    fade_out=inout
	fade_func=f
end

function draw_fade(t, dir)
    local max_r = 12
    local size = 16
    
    if dir == "right" then
        local wipe_x = (1 - t) * 256
        wipe_x -= 128
        
        for i = 0, 8 do
            for j = 0, 8 do
                local r = (i * size) - wipe_x
                r *= 0.2
                r = flr(mid(0, r, max_r))
                
                if (r > 0) rectfill(i * size - r, j * size - r, i * size + r, j * size + r, 9)
            end
        end
    else
        local wipe_x = t * 256
        wipe_x -= 128
        
        for i = 0, 8 do
            for j = 0, 8 do
                local r = wipe_x - (i * size)
                r *= 0.2
                r = flr(mid(0, r, max_r))
                
                if (r > 0) rectfill(i * size - r, j * size - r, i * size + r, j * size + r, 9)
            end 
        end
    end
end

function sfxok()
    sfx(2)
end

function sfxtick()
    sfx(3)
end

function sfxback()
    sfx(6)
end

-- Configurações iniciais
function _init()
    menu.init()
end

-- Atualização do jogo
function _update60()
	--update fade
	if fading then
		fade_anim +=1
		
		if fade_anim==32 then
			fade_func()
		end
		
		if fade_anim==65 then
			fading=false
			fade_anim=0
		end
	else
        states[global.game_state].update()
    end
end

-- Desenho do jogo
function _draw()

    states[global.game_state].draw()

	if fading then
		
		camera(0,0)
		
		--draw fade
		if fade_anim <= 32 then
			draw_fade(fade_anim/32, fade_out and "left" or "right")
		else
			draw_fade((64-fade_anim)/32, fade_out and "right" or "left")
		end
		
	end
end

-- print centered
function printc(str,y,clr)
	local x=64-(#str*4)/2
	print(str,x+1,y,clr)
end

-- print shadow
function prints(str,x,y,clr)
	print(str,x+1,y+1,0)
	print(str,x,y,clr)
end

-- Função de interpolação linear
function lerp(a, b, t)
    return a + (b - a) * t
end

function title(title, color)
    printc(title, 12, color or 7)
end

function actions(confirm, back, offset)
    offset = offset or 0
    if(confirm) print("ok🅾️", 109, 115, btn(🅾️) and 7 or 1)
    if(back) print("❎voltar", 4 + offset, 115, btn(❎) and 7 or 1)
end

function bg(y, h)
    y = y or 39
    h = h or 53

    pal(9,129,1)
    pal(14,140,1)
    rectfill(0,0,127,127,9)
    -- Linha superior externa
    line(0, y-12, 128, y-12, 14)
    
    -- Linha inferior externa
    line(0, y+h+12, 128, y+h+12, 14)
    
    -- Retângulo central externo
    rectfill(0, y-10, 127, y+h+10, 14)
    
    -- Linha superior interna
    line(0, y-2, 128, y-2, 12)
    
    -- Linha inferior interna
    line(0, y+h+2, 128, y+h+2, 12)
    
    -- Retângulo central interno
    rectfill(0, y, 127, y+h, 12)
end