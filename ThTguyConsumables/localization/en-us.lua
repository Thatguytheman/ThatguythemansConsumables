return {
    descriptions = {
        Runes = {
            c_TGTM_blank = {
                name = "Blank",
                text = {"Spawn a {C:purple}rune{}", "{C:red}#2# in #3# chance to not get destroyed when used{}", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_blankC = {
                name = "Blank?",
                text = {"Spawn a {C:purple}rune{}", "{C:red}DOES NOT GET DESTROYED WHEN USED{}", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_laguz = {
                name = "Laguz",
                text = {"Gain {C:red}#1#{} discard"}
            },
            c_TGTM_laguzC = {
                name = "Laguz?",
                text = {"Gain {C:red}#1#{} discards", "{C:attention}+#2#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_dagaz = {
                name = "Dagaz",
                text = {"{C:red}Disable{} boss blind", "{C:attention}No reward money from blind{} "}
            },
            c_TGTM_dagazC = {
                name = "Dagaz?",
                text = {"{C:red}Disable{} boss blind", "{C:attention}+#1#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_othala = {
                name = "Othala",
                text = {"Earn {C:attention}interest cap * #2#{} Dollars {C:inactive}($#1#){}", "{C:red}-#3#%{} of Interest cap"}
            },
            c_TGTM_othalaC = {
                name = "Othala?",
                text = {"Earn {C:attention}interest cap * #2#{} Dollars {C:inactive}($#1#){}", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_inguz = {
                name = "Inguz",
                text = {"{C:red}Set money to 0", "{C:attention}+#3#{} Interest per {C:attention}#2#${} lost {C:inactive}(+#1#){}"}
            },
            c_TGTM_inguzC = {
                name = "Inguz?",
                text = {"{C:attention}+#3#{} Interest per {C:attention}#2#${} {C:inactive}(+#1#){}", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_mannaz = {
                name = "Mannaz",
                text = {"Scored face cards give {X:mult,C:white}#1#x{} mult", "{C:attention}#2#{} chips, {C:attention}#3#{} more per face card","Only for this round","When used, becomes a negative Joker"}
            },
            c_TGTM_mannazC = {
                name = "Mannaz?",
                text = {"Scored face cards give {X:mult,C:white}#1#x{} mult", "Only for this round", "When used, becomes a negative Joker", "{C:attention}+#4#%{} chance for {C:purple}cursed{} cards"}
            },
            c_TGTM_ehwaz = {
                name = "Ehwaz",
                text = {"{C:attention}#1# ante{}", "Break a random non-negative joker"}
            },
            c_TGTM_ehwazC = {
                name = "Ehwaz?",
                text = {"{C:attention}#1# ante{}", "{C:attention}+#2#%{} chance for {C:purple}cursed{} cards"}
            }

        },
        Joker = {
            j_TGTM_mannazJoker = {
                name = "Mannaz",
                text = {"Scored face cards give {X:mult,C:white}#1#x{} mult", "{C:attention}#2#{} chips, {C:attention}#3#{} more per face card","Destroyed after round"}
            },
            j_TGTM_mannazJokerC = {
                name = "Mannaz?",
                text = {"Scored face cards give {X:mult,C:white}#1#x{} mult", "Destroyed after round"}
            },
        }
    }
}