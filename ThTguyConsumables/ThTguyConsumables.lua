--- STEAMODDED HEADER
--- MOD_NAME: TGTM's Consumables
--- MOD_ID: ThTguyConsumables
--- MOD_AUTHOR: [Thatguytheman]
--- MOD_DESCRIPTION: runes and stuff (and a few random jokers)

--[[to do:
Add runes (negative tarots temporary gain, long term downsides)

Add Jokers (balance top 10% chips + mult, transfer 5% of mult to chips, chip multiplier, set mult to 100, reduce mult by 10% and award 1$ per 10 mult)

thank you to cryptid mod because i copied a bunch of stuff from it to learn

]]


--[[
    Runes and meanings:
    Laguz (Water) : +1 discard for round, maybe draw 4 cards less on initial draw, subsequent uses in same round reduces cards drawn by 5 then 6, so on and so forth
	Dagaz (Dawn) : disable boss blind, +1 ante 
	OTHALA (Inheritance) : gain x$, lower intrest cap by x
	
	Blank : Spawn last used rune

]]

SMODS.Atlas{
    key = "runes",
	px = 73,
	py = 103,
	path = "Runes.png"
}

SMODS.ConsumableType{

    key = "Runes",
    primary_colour = HEX("480049"),
    secondary_colour = HEX("890062"),
    collection_rows = { 5, 5 }, -- 1 pages for all runes
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
        ON USE
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
        name = "Laguz",
        text = {"Gain {C:attention}+1{} discard for this round"}
    },
	atlas = "runes",
    set = "Runes",
    name = "runes-laguz",
    key = "laguz",
    pos = {x = 1, y = 0},
    config = {},
    cost = 4,
    order = 1,
    can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            ease_discard(1)
        return true end }))
    end,
}


    
