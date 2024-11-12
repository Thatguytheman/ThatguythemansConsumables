--- STEAMODDED HEADER
--- MOD_NAME: InstantRestart
--- MOD_ID: InstRestart
--- MOD_AUTHOR: [Thatguytheman]
--- MOD_DESCRIPTION: Press T to instantly restart!

SMODS.Keybind{
	key = "InstRestart",
	key_pressed = "t",
	
	action = function(controller)
	
		if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
            G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
        end
        G:save_settings()
        G.SETTINGS.current_setup = 'New Run'
        G.GAME.viewed_back = nil
        G.run_setup_seed = G.GAME.seeded
        G.challenge_tab = G.GAME and G.GAME.challenge and G.GAME.challenge_tab or nil
        G.forced_seed, G.setup_seed = nil, nil
        if G.GAME.seeded then G.forced_seed = G.GAME.pseudorandom.seed end
        G.forced_stake = G.GAME.stake
        if G.STAGE == G.STAGES.RUN then G.FUNCS.start_setup_run() end
        G.forced_stake = nil
        G.challenge_tab = nil
        G.forced_seed = nil
	end,
}

