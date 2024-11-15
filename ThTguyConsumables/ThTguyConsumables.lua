--- STEAMODDED HEADER
--- MOD_NAME: TGTM's Consumables
--- MOD_ID: TGTMConsumables
--- MOD_AUTHOR: [Thatguytheman]
--- MOD_DESCRIPTION: runes and stuff (and a few random jokers)
--- PREFIX: TGTM

--[[to do:
Add runes (negative tarots temporary gain, long term downsides)

Add cursed tarots (only gotten from blank rune)
Add Jokers (balance top 10% chips + mult, transfer 5% of mult to chips, chip multiplier, set mult to 100, reduce mult by 10% and award 1$ per 10 mult)

thank you to cryptid mod because i copied a bunch of stuff from it to learn

]]


--[[
Runes and meanings:
	Laguz (Water) : +1 discard for round
	Dagaz (Dawn) : disable boss blind, no boss reward
	OTHALA (Inheritance) : gain intrest cap * 5, lower intrest cap by 20%


	Blank : Spawn a rune, 50% chance to not get destroyed when used, +5% chance for cursed cards
]]
local IntrestAmt = 0

--Globals
local startRef = Game.start_run
function Game:start_run(args)
    startRef(self, args)
    G.GAME.TGTMchangeHandSize = 0
    IntrestAmt = G.GAME.interest_cap
    G.GAME.TGTMLastRune = nil
    G.GAME.TGTMCurseChance = 0
end

SMODS.Enhancement{
    key = "Locked",
    atlas = "Tatatro",
    pos = {x = 4, y = 2},
    unlocked = true,
    discovered = true,
    no_suit = true,
    no_rank = true,
    replace_base_card = true,
    bonus = 0,
    bonus_chips = 0,
    loc_txt = {
        name = "Locked",
        text = {"Scores 0 chips", "No rank or suit"}
    }
    
}

SMODS.Edition{
    key = "Cursed",
    shader = false,
    loc_txt = {
        name = "Cursed!",
        label = "Cursed!",
        text = {"{X:mult,C:white} X0.75{} mult"}
    },
    unlocked = true,
    discovered = true,
    config = {
        x_mult = 0.75
    }
}

SMODS.Atlas{
    key = "Tatatro",
	px = 71,
	py = 95,
	path = "Tarots.png"
}

SMODS.Atlas{
    key = "runes",
	px = 71,
	py = 95,
	path = "Runes.png"
}

SMODS.ConsumableType{

    key = "Runes",
    primary_colour = HEX("480049"),
    secondary_colour = HEX("890062"),
    collection_rows = { 5, 2 }, -- 3 pages for all runes
    shop_rate = 2,
    loc_txt = {
        name = "Runes",
        collection = "Runes"
    },
    can_stack = true,
    can_divide = true

}



--[[
base for cards


SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_txt = {
        name = "NAME",
        text = {"DESC"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-NAME",
    key = "name",
    pos = {x = 0, y = 0},
    config = {},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        CONDITION FOR USING
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            ON USE
        return true end }))
    end,
}


]]

SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_txt = {
        name = "Blank",
        text = {"Spawn a rune", "50% chance to not get destroyed when used", "+5% chance for {C:purple}cursed{} cards"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-blank",
    key = "blank",
    pos = {x = 0, y = 0},
    config = {},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            
            G.GAME.TGTMCurseChance = 1



        return true end }))
    end,
}

--Laguz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_txt = {
        name = "Laguz",
        text = {"Gain {C:attention}1{} discard for this round"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-laguz",
    key = "laguz",
    pos = {x = 1, y = 0},
    config = {},
    cost = 4,
    order = 21,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            ease_discard(1)
            
            --G.GAME.TGTMchangeHandSize = G.GAME.TGTMchangeHandSize - 1

        return true end }))
    end,
}

--Dagaz
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_txt = {
        name = "Dagaz",
        text = {"{C:red}Disable{} boss blind", "{C:attention}No reward money from blind{} "}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-daguz",
    key = "daguz",
    pos = {x = 2, y = 0},
    config = {},
    cost = 4,
    order = 24,
    can_use = function(self, card)
        return (G.STATE == G.STATES.SELECTING_HAND and G.GAME.blind:get_type() == 'Boss')
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.GAME.blind:disable()
            G.GAME.blind.dollars = 0
            G.GAME.current_round.dollars_to_be_earned = ''
        return true end }))
    end,
}

--Othala
SMODS.Consumable{
    set_ability = function(self, card, initial, delay_sprites)
        card:set_edition("e_negative")
    end,
	unlocked = true,
	discovered = true,
    loc_vars = function(self, info_queue, card)
		return { vars = {G.GAME and G.GAME.interest_cap or '???'}}
	end,
    loc_txt = {
        name = "Othala",
        text = {"Earn {C:attention}interest cap * 5{} Dollars {C:inactive}($#1#){}", "{C:red}-20%{} of Interest cap"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-othala",
    key = "othala",
    pos = {x = 3, y = 0},
    config = {},
    cost = 4,
    order = 23,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            ease_dollars(G.GAME.interest_cap)
            
            
            print(G.GAME.interest_cap)
            if G.GAME.interest_cap > 5 then
                G.GAME.interest_cap = math.floor((G.GAME.interest_cap/5) * 0.8) * 5
            end

            print(G.GAME.interest_cap)



        return true end }))
    end,
}

--Taking control of round end to change stuff
local endroundref = end_round
function end_round()
  endroundref()
  G.hand:change_size(G.GAME.TGTMchangeHandSize)
  G.GAME.TGTMchangeHandSize = 0
end
--
local ATDref = Card.add_to_deck
function Card:add_to_deck(args)
    ATDref(self, args)
    print(self.ability.set)
    print(pseudorandom(pseudoseed("Curse")))
    print(G.GAME.TGTMCurseChance)
    if (G.GAME.TGTMCurseChance > 0) and (self.ability.set == 'Joker') and (pseudorandom(pseudoseed("Curse")) < G.GAME.TGTMCurseChance) then
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()

            self:set_edition("e_TGTM_Cursed")
            card_eval_status_text(self,"extra",nil,nil,nil,{message = "Cursed!", colour = G.C.PURPLE})

        return true end }))
    end
end

local UseRef = Card.use_consumeable
function Card:use_consumeable(args)
    stop_use()
    if not copier then set_consumeable_usage(self) end
    if self.debuff then return nil end
    local used_tarot = copier or self

    if (G.GAME.TGTMCurseChance > 0) and (self.ability.set == 'Tarot') and (pseudorandom(pseudoseed("Curse")) < G.GAME.TGTMCurseChance) then

        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            card_eval_status_text(self,"extra",nil,nil,nil,{message = "Cursed!", colour = G.C.PURPLE})
        return true end }))

        if G.hand and #G.hand.highlighted == 0 then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                

                
                local front = pseudorandom_element(G.P_CARDS, pseudoseed('CurseLockedFront'))
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local cardLoc = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_TGTM_Locked, {playing_card = G.playing_card})
                cardLoc:start_materialize({G.C.SECONDARY_SET.Enhanced})
                table.insert(G.playing_cards, cardLoc)
                card_eval_status_text(cardLoc,"extra",nil,nil,nil,{message = "Locked!", colour = G.C.PURPLE})
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    print(cardLoc)
                    G.hand:emplace(cardLoc, nil, false)
                return true end }))
            return true end }))

        elseif G.hand then
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                    local CardRef = G.hand.highlighted[i]
                    card_eval_status_text(CardRef,"extra",nil,nil,nil,{message = "Locked!", colour = G.C.PURPLE})
                    G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_TGTM_Locked"])
                    G.hand.highlighted[i]:flip()
                return true end }))
            end
        else 
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                card_eval_status_text(self,"extra",nil,nil,nil,{message = "Locked!", colour = G.C.PURPLE})
                local LockedSpawn = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_TGTM_Locked, {playing_card = G.playing_card})
                LockedSpawn:add_to_deck()
            return true end }))
        end


        
    elseif (G.GAME.TGTMCurseChance > 0) and (self.ability.set == 'Planet') and (pseudorandom(pseudoseed("Curse")) < G.GAME.TGTMCurseChance) then
        

        
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3,func = function()
                card_eval_status_text(self,"extra",nil,nil,nil,{message = "Cursed!", colour = G.C.PURPLE})
            return true end }))
            local handname = self.ability.consumeable.hand_type
            print("HANDNAME:", handname)
            if G.GAME.hands[handname].level > 1 then
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(self.ability.consumeable.hand_type, 'poker_hands'),chips = G.GAME.hands[self.ability.consumeable.hand_type].chips, mult = G.GAME.hands[self.ability.consumeable.hand_type].mult, level=G.GAME.hands[self.ability.consumeable.hand_type].level})
                self.triggered = true
                level_up_hand(self.children.animatedSprite, handname, nil, -1)mmmmm
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
            end 
        return true end }))
        
    else
        UseRef(self,args) 
    end

end
