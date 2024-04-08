using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors/NamedColors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using {/Verse.org/Assets}
using { /Verse.org/Colors }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level

spawner := class(tag){}

sentries := class(tag){}

TextForUI< localizes>(InText : string, Agent : agent) : message = "{Agent}'s Lifetime Kills: {InText}"

TextForUI2< localizes>(InText : string) : message = "Goal For \n Next Rank: {InText}"

TextForUI3< localizes>(InText : string) : message = "Rank:"
TextForCode< localizes>(InText : string) : message = "7660-0494-1977"

TextForRank< localizes>(InText : string) : message = "{InText}"

TextForUIRank< localizes>(InText1 : string, InText2 : string) : message = "{InText1}/{InText2}"

TextForUIChamp< localizes>(InText1 : string) : message = "{InText1}"

TextForRoundPoints< localizes>(InText1 : string) : message = "{InText1}"

TextForPlacementReach< localizes>(InText1 : string) : message = "REACH TOP {InText1}"
TextForPlacementPoints< localizes>(InText1 : string) : message = "+{InText1} POINTS"

TextForElimPoints< localizes>(InText : string) : message = "+2 Elim Points"

RankDeviceManager := class(creative_device):


    BronzeI : texture = Bronze1
    BronzeII : texture = Bronze2
    BronzeIII : texture = Bronze1

    Silver1 : texture = Silver_I
    Silver2 : texture = Silver_II
    Silver3 : texture = Silver_III

    Gold1 : texture = GoldI
    Gold2 : texture = GoldII
    Gold3 : texture = GoldIII

    Platinum1 : texture = PlatinumI
    Platinum2 : texture = PlatinumII
    Platinum3 : texture = PlatinumIII

    Diamond1 : texture = DiamondFixed
    Diamond2 : texture = DiamondII
    Diamond3 : texture = DiamondIII

    EliteRank : texture = Elite
    ChampionRank : texture = Champion
    UnrealRank : texture = Unreal

    RoundIcon : texture = dawd2



    var Count : int = 0
    var PlayerMap : [player]RankDeviceManager = map{}

    @editable Tracker : tracker_device = tracker_device{}
    @editable RankTracker : tracker_device = tracker_device{}
    @editable RoundTracker : tracker_device = tracker_device{}

    @editable
    RoundSettings : round_settings_device = round_settings_device{}


    
    @editable
    ScoreManagerElim:score_manager_device = score_manager_device{}
    @editable
    ScoreManagerPlacement:score_manager_device = score_manager_device{}

    @editable
    ElimManager:elimination_manager_device = elimination_manager_device{}




    InitSpawners():void =
        Spawners := GetCreativeObjectsWithTag(spawner{})

        for (Obj : Spawners):
            if (Spawner := player_spawner_device[Obj]):
                Spawner.SpawnedEvent.Subscribe(OnPlayerAdded)


    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void=
        # TODO: Replace this with your code

        InitSpawners()
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)
        ElimManager.EliminationEvent.Subscribe(OnElimination)
        ScoreManagerElim.SetScoreAward(2)
        ElimManager.EliminatedEvent.Subscribe(OnPlayerEliminated)
        
    
    

    OnPlayerEliminated(Agent: agent):void=
        spawn{CheckForLastTeam()}
        Print("Player Eliminated")
        
    
    CheckForLastTeam()< suspends>:void =
        Sleep(0.6)
        TeamCollection := GetPlayspace().GetTeamCollection()
        TeamsArray := TeamCollection.GetTeams()
        #Loop through teams, if the teamagents array length is more than 0, +1 team count

        var Teamcount : int = 0

        for (PlayerTeam : TeamCollection.GetTeams()):
            if(TeamAgents := TeamCollection.GetAgents[PlayerTeam]):
                if(TeamAgents.Length > 0):
                    set Teamcount += 1
        Print("The Team Count is {Teamcount}")
        if (Teamcount = 1):
            for (Player : GetPlayspace().GetPlayers(), FortCharacter := Player.GetFortCharacter[], FortCharacter.IsActive[]):
                if(PlayerTeam := GetPlayspace().GetTeamCollection().GetTeam[Player] ):
                    if(TeamAgents := TeamCollection.GetAgents[PlayerTeam]):
                        for (TeamMember : TeamAgents):
                            RoundSettings.EndRound(TeamMember)
                    

        

    
                                                    
    



                

        

    OnElimination(NewPlayer : ?agent):void =
        TeamCollection := GetPlayspace().GetTeamCollection()

        #not including Validagent(not ValidAgent)
        

        #get the player count here
        if (ValidAgent := NewPlayer?):
            if (PlayerObj := player[ValidAgent]):
                if (PlayerExists := PlayerMap[NewPlayer]):
    
                else:
                    if (set PlayerMap[PlayerObj] = RankDeviceManager{}):
                        if(PlayerUI := GetPlayerUI[PlayerObj]):
                            var TextBlockElimPoints : text_block = text_block{DefaultTextColor := White,DefaultShadowColor := Black, DefaultShadowOffset:= {option{vector2{X := -2.0,Y := 2.0}}}}
                                TextBlockElimPoints.SetShadowOpacity(1.0)
                                ElimCanvas := canvas:
                                    Slots := array:
                                        canvas_slot:
                                            Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                            Offsets := margin{Top := 300.0, Left := 35.0, Right := 0.0, Bottom := 0.0}
                                            Alignment := vector2{X := 0.3, Y := 1.2}
                                            SizeToContent := true
                                            Widget := TextBlockElimPoints

                            spawn{ElimUI(ValidAgent, ElimCanvas, PlayerObj, TextBlockElimPoints)}
            
            
            
            
            
            
            if (PlayerObj := player[ValidAgent]):
                if (PlayerExists := PlayerMap[NewPlayer]):
    
                else:
                    if (set PlayerMap[PlayerObj] = RankDeviceManager{}):
                        if(PlayerUI := GetPlayerUI[PlayerObj]):

                            var PointsBorder : color_block = color_block{DefaultColor := SandyBrown, DefaultDesiredSize:= vector2{X := 200.0, Y := 40.0 }}
                            PointsBorder.SetOpacity(1.0)
                            var UpdateIcon : texture_block = texture_block{DefaultImage := RoundIcon, DefaultDesiredSize:= vector2{X:=175.0, Y:=175.0}}

                            var TextBlockReach : text_block = text_block{DefaultTextColor := White }
                            var TextBlockPoints : text_block = text_block{DefaultTextColor := Gold,DefaultShadowColor := DarkGoldenrod, DefaultShadowOffset:= {option{vector2{X := -2.0,Y := 2.0}}}}
                            TextBlockPoints.SetShadowOpacity(1.0)

                            MyPointsCanvas := canvas:
                                Slots := array:
                                    canvas_slot:
                                        Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                                        Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                        Alignment := vector2{X := 0.0, Y := 3.0}
                                        SizeToContent := true
                                        Widget := PointsBorder
                                    canvas_slot:
                                        Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                                        Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                        Alignment := vector2{X := 0.3, Y := 1.2}
                                        SizeToContent := true
                                        Widget := UpdateIcon
                                    canvas_slot:
                                        Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                        Offsets := margin{Top := 30.0, Left := 16.0, Right := 0.0, Bottom := 0.0}
                                        Alignment := vector2{X := 0.3, Y := 1.2}
                                        SizeToContent := true
                                        Widget := TextBlockReach
                                    canvas_slot:
                                        Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                        Offsets := margin{Top := 97.0, Left := 35.0, Right := 0.0, Bottom := 0.0}
                                        Alignment := vector2{X := 0.3, Y := 1.2}
                                        SizeToContent := true
                                        Widget := TextBlockPoints

                            ScoreManagerElim.Activate(ValidAgent)
                            Print("+2 elimination points", ?Color:=NamedColors.Gold)
                                                            
                            if(PlayerTeam := GetPlayspace().GetTeamCollection().GetTeam[ValidAgent] ):
                            var Teamcount : int = 0
                            for (Player : GetPlayspace().GetPlayers(), FortCharacter := Player.GetFortCharacter[]):
                                
                                #FIX LOGIC FOR TEAMCOUNT HERE: LOOP THROUGH EACH TEAM AND CHECK IF AT LEAST ONE PLAYER IS ACTIVE, IF THEY ARE, COUNT += 1
                                #CHECK TO SEE IF THIS LOGIC IS CORRECT
                                
                                # use sleep functions and is active maybe

                                if (FortCharacter.IsActive[]):
                                    set Teamcount += 1

                            for (PlayerCheck : GetPlayspace().GetPlayers(), FortCharacter := PlayerCheck.GetFortCharacter[]):
                                    if(PlayerTeam := GetPlayspace().GetTeamCollection().GetTeam[PlayerCheck] ):
                                        #loop through players on the team and check if they are active, if active, awardPlacementpoints
                                        if (TeamCollection.IsOnTeam[PlayerCheck, PlayerTeam]):
                                            #Get players from team and give them points
                                            if(TeamAgents := TeamCollection.GetAgents[PlayerTeam]):
                                                if(TeamAgents.Length = 2):
                                                    for (TeamMember : TeamAgents):
                                                        if (Teamcount = 0):
                                                            Print("No More Players Alive", ?Color:=NamedColors.Gold)
                                                        else if (Teamcount = 1):
                                                            Print("+2 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(4)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("1"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("9"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                            spawn{OnTimerEnd(TeamMember)}
                                                            #end game
                                                        else if (Teamcount = 2):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("2"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 3):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("3"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 4):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("4"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 5):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(1)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("5"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 6):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(1)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("6"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 7):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(1)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("7"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 8):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(1)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("8"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 9):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(1)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("9"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 10):
                                                            Print("+1 twice Placement Points", ?Color:=NamedColors.Gold)
                                                            ScoreManagerPlacement.SetScoreAward(1)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("10"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        
                                                else if(TeamAgents.Length = 1):
                                                    
                                                    for (TeamMember : TeamAgents):
                                                        if (Teamcount = 0):
                                                            Print("No More Players Alive", ?Color:=NamedColors.Blue)
                                                        else if (Teamcount = 1):
                                                            Print("+9 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(9)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("1"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("9"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                            spawn{OnTimerEnd(TeamMember)}
                                                        else if (Teamcount = 2):
                                                            Print("+4 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(4)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("2"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 3):
                                                            Print("+4 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(4)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("3"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 4):
                                                            Print("+4 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(4)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("4"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 5):
                                                            Print("+4 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(4)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("5"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("4"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 6):
                                                            Print("+2 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("6"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 7):
                                                            Print("+2 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("7"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 8):
                                                            Print("+2 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("8"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 9):
                                                            Print("+2 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("9"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                                        else if (Teamcount = 10):
                                                            Print("+2 Placement Points", ?Color:=NamedColors.Blue)
                                                            ScoreManagerPlacement.SetScoreAward(2)
                                                            ScoreManagerPlacement.Activate(TeamMember)
                                                            TextBlockReach.SetText(TextForPlacementReach("10"))
                                                            TextBlockPoints.SetText(TextForPlacementPoints("2"))
                                                            #spawn{PlacementUI(PlayerObj, MyPointsCanvas,TextBlockReach, TeamMember)}
                                            spawn{CheckForLastTeam()}
    

    
    PlacementUI(Player : player, PointsCanvas : canvas, ReachTop : text_block, Agent : agent)< suspends>:void =
        if(PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(PointsCanvas)
            Sleep(3.0)
            PlayerUI.RemoveWidget(PointsCanvas)

    OnTimerEnd(NewPlayer : agent)< suspends>:void =
        Sleep(0.6)
        RoundSettings.EndRound(NewPlayer)


    ElimUI(Agent : agent, ElimsCanvas : canvas, Player : player, TextBlockElim : text_block)< suspends>:void =
        Print("Inside PlayerUI")
        if(PlayerUI := GetPlayerUI[Player]):
            TextBlockElim.SetText(TextForElimPoints("+2 Elim Points"))
            PlayerUI.AddWidget(ElimsCanvas)
            Sleep(0.6)
            PlayerUI.RemoveWidget(ElimsCanvas)

    
    KillSpawnLoop(Player : player, TextBlock : text_block, ElimCanvas : canvas, Agent : agent)< suspends>:void =
        loop: 
            Sleep(0.1)
            if (AgentStats := PlayerMap[Player]):
                TextBlock.SetText(TextForUI("{Tracker.GetValue(Player)}", Agent))


        

    RankSpawnLoop(Player : player, TextBlock : text_block, TextRank : text_block, RankImage : texture_block, TextRoundRank : text_block, Agent : agent)< suspends>:void =
        
        loop:
            Sleep(0.1)
            if (PlayerUi := GetPlayerUI[Player]):
                if (RoundTracker.GetValue(Player) = 0):
                    TextRoundRank.SetText(TextForRoundPoints(""))
                else:
                    TextRoundRank.SetText(TextForRoundPoints("{RoundTracker.GetValue(Player)}"))
                
                if (RankTracker.GetValue(Player) < 50):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","50"))
                    TextRank.SetText(TextForRank("Bronze I"))
                    RankImage.SetImage(Bronze1)
                else if (RankTracker.GetValue(Player) > 49 and RankTracker.GetValue(Player) < 100):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","100"))
                    TextRank.SetText(TextForRank("Bronze II"))
                    RankImage.SetImage(Bronze2)
                else if (RankTracker.GetValue(Player) > 99 and RankTracker.GetValue(Player) < 150):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","150"))
                    TextRank.SetText(TextForRank("Bronze III"))
                    RankImage.SetImage(BronzeRank)
                else if (RankTracker.GetValue(Player) > 149 and RankTracker.GetValue(Player) < 200):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","200"))
                    TextRank.SetText(TextForRank("Silver I"))
                    TextRank.SetTextColor(Silver)
                    RankImage.SetImage(Silver1)
                else if (RankTracker.GetValue(Player) > 199 and RankTracker.GetValue(Player) < 250):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","250"))
                    TextRank.SetText(TextForRank("Silver II"))
                    TextRank.SetTextColor(Silver)
                    RankImage.SetImage(Silver2)
                else if (RankTracker.GetValue(Player) > 249 and RankTracker.GetValue(Player) < 300):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","300"))
                    TextRank.SetText(TextForRank("Silver III"))
                    TextRank.SetTextColor(Silver)
                    RankImage.SetImage(Silver3)
                else if (RankTracker.GetValue(Player) > 299 and RankTracker.GetValue(Player) < 350):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","350"))
                    TextRank.SetText(TextForRank("Gold I"))
                    TextRank.SetTextColor(Gold)
                    RankImage.SetImage(Gold1)
                else if (RankTracker.GetValue(Player) > 349 and RankTracker.GetValue(Player) < 400):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","400"))
                    TextRank.SetText(TextForRank("Gold II"))
                    TextRank.SetTextColor(Gold)
                    RankImage.SetImage(Gold2)
                else if (RankTracker.GetValue(Player) > 399 and RankTracker.GetValue(Player) < 450):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","450"))
                    TextRank.SetText(TextForRank("Gold III"))
                    TextRank.SetTextColor(Gold)
                    RankImage.SetImage(Gold3)
                else if (RankTracker.GetValue(Player) > 449 and RankTracker.GetValue(Player) < 500):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","500"))
                    TextRank.SetText(TextForRank("Platinum I"))
                    TextRank.SetTextColor(NamedColors.CadetBlue)
                    RankImage.SetImage(Platinum1)
                else if (RankTracker.GetValue(Player) > 499 and RankTracker.GetValue(Player) < 550):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","550"))
                    TextRank.SetText(TextForRank("Platinum II"))
                    TextRank.SetTextColor(NamedColors.CadetBlue)
                    RankImage.SetImage(Platinum2)
                else if (RankTracker.GetValue(Player) > 549 and RankTracker.GetValue(Player) < 600):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","600"))
                    TextRank.SetText(TextForRank("Platinum III"))
                    TextRank.SetTextColor(NamedColors.CadetBlue)
                    RankImage.SetImage(Platinum3)
                else if (RankTracker.GetValue(Player) > 599 and RankTracker.GetValue(Player) < 650):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","650"))
                    TextRank.SetText(TextForRank("Diamond I"))
                    TextRank.SetTextColor(NamedColors.CornflowerBlue)
                    RankImage.SetImage(Diamond1)
                else if (RankTracker.GetValue(Player) > 649 and RankTracker.GetValue(Player) < 700):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","700"))
                    TextRank.SetText(TextForRank("Diamond II"))
                    TextRank.SetTextColor(NamedColors.CornflowerBlue)
                    RankImage.SetImage(Diamond2)
                else if (RankTracker.GetValue(Player) > 699 and RankTracker.GetValue(Player) < 750):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","750"))
                    TextRank.SetText(TextForRank("Diamond III"))
                    TextRank.SetTextColor(NamedColors.CornflowerBlue)
                    RankImage.SetImage(Diamond3)
                else if (RankTracker.GetValue(Player) > 749 and RankTracker.GetValue(Player) < 800):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","800"))
                    TextRank.SetText(TextForRank("Elite"))
                    TextRank.SetTextColor(NamedColors.DarkGrey)
                    RankImage.SetImage(EliteRank)
                else if (RankTracker.GetValue(Player) > 799 and RankTracker.GetValue(Player) < 850):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","850"))
                    TextRank.SetText(TextForRank("Champion"))
                    TextRank.SetTextColor(NamedColors.OrangeRed)
                    RankImage.SetImage(ChampionRank)
                else if (RankTracker.GetValue(Player) > 849 and RankTracker.GetValue(Player) < 99999999):
                    TextBlock.SetText(TextForUIRank("{RankTracker.GetValue(Player)}","850"))
                    TextRank.SetText(TextForRank("Elite"))
                    TextRank.SetTextColor(NamedColors.DarkGrey)
                    RankImage.SetImage(EliteRank)


                    
    

    OnPlayerAdded(NewPlayer : agent):void =
        Print("Player Added")
        if (PlayerObj := player[NewPlayer]):
            if (PlayerExists := PlayerMap[NewPlayer]):

            else:
                if (set PlayerMap[PlayerObj] = RankDeviceManager{}):
                    if(PlayerUI := GetPlayerUI[PlayerObj]):

                        var Border1 : color_block = color_block{DefaultColor := Blue, DefaultDesiredSize:= vector2{X := 800.0, Y := 60.0 }}
                        Border1.SetOpacity(0.35)
                        var Border2 : color_block = color_block{DefaultColor := Blue, DefaultDesiredSize:= vector2{X := 270.0, Y := 100.0 }}
                        Border2.SetOpacity(0.35)
                        var TextBlock3 : text_block = text_block{DefaultTextColor := White, DefaultShadowColor := Black, DefaultShadowOffset:= {option{vector2{X := 3.0,Y := 3.0}}}}
                        TextBlock3.SetShadowOpacity(1.0)
                        var TextBlockCode : text_block = text_block{DefaultTextColor := White, DefaultShadowColor := Black, DefaultShadowOffset:= {option{vector2{X := 2.0,Y := 2.0}}}}
                        TextBlockCode.SetShadowOpacity(1.0)

                       

                        MyCanvas3 := canvas:
                            Slots := array:
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.05}, Maximum := vector2{X := 0.5, Y := 0.05}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := 0.5, Y := 0.15}
                                    SizeToContent := true
                                    Widget := Border1
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := 0.0, Y := -1.0}
                                    SizeToContent := true
                                    Widget := Border2
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := -0.10, Y := -3.78}
                                    SizeToContent := true
                                    Widget := TextBlock3
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.015}, Maximum := vector2{X := 0.5, Y := 0.015}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := 0.5, Y := 0.15}
                                    SizeToContent := true
                                    Widget := TextBlockCode


                        Print("Ui should be added")
                        PlayerUI.AddWidget(MyCanvas3)
                        TextBlock3.SetText(TextForUI3("Rank:"))
                        TextBlockCode.SetText(TextForCode("7660-0494-1977"))
                        

                        var TextBlock2 : text_block = text_block{DefaultTextColor := White, DefaultShadowColor := Black, DefaultShadowOffset:= {option{vector2{X := 3.0,Y := 3.0}}}}
                        TextBlock2.SetShadowOpacity(1.0)


                        RankToString := "{RankTracker.GetValue(NewPlayer)}"
                        RoundRankToString := "{RoundTracker.GetValue(NewPlayer)}"

                        
                        MyCanvas1 := canvas:
                                Slots := array:
                                    canvas_slot:
                                        Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                        Offsets := margin{Top := 140.0, Left := 160.0, Right := 0.0, Bottom := 0.0}
                                        Alignment := vector2{X := 0.5, Y := 0.5}
                                        SizeToContent := true
                                        Widget := TextBlock2

                        if (RankTracker.GetValue(PlayerObj) < 50):
                            
                            Print("Ui should be added")
                            PlayerUI.AddWidget(MyCanvas1)
                            TextBlock2.SetText(TextForUIRank(RankToString,"50"))



                        var TextBlockRank : text_block = text_block{DefaultTextColor := NamedColors.SaddleBrown, DefaultShadowColor := Black, DefaultShadowOffset:= {option{vector2{X := 3.0,Y := 3.0}}}}
                        TextBlockRank.SetShadowOpacity(1.0)
                        var RankIcon : texture_block = texture_block{DefaultImage := Bronze1, DefaultDesiredSize:= vector2{X:=50.0, Y:=50.0}}
                        MyCanvas2 := canvas:
                            Slots := array:
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                    Offsets := margin{Top := 185.0, Left := 100.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := 0.0, Y := 0.5}
                                    SizeToContent := true
                                    Widget := TextBlockRank

                        MyCanvas4 := canvas:
                            Slots := array:
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.025, Y := 0.35}, Maximum := vector2{X := 0.025, Y := 0.35}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := -0.2, Y := -2.3}
                                    SizeToContent := true
                                    Widget := RankIcon
                        
                        PlayerUI.AddWidget(MyCanvas1)
                        PlayerUI.AddWidget(MyCanvas2)
                        PlayerUI.AddWidget(MyCanvas4)

                        if (RankTracker.GetValue(NewPlayer) < 50):
                            Print("Ui should be added")
                            TextBlock2.SetText(TextForUIRank(RankToString,"50"))
                            TextBlockRank.SetText(TextForRank("Bronze I"))
                            RankIcon.SetImage(Bronze1)
                        else if (RankTracker.GetValue(NewPlayer) > 49 and RankTracker.GetValue(NewPlayer) < 100):
                            TextBlock2.SetText(TextForUIRank(RankToString,"100"))
                            TextBlockRank.SetText(TextForRank("Bronze II"))
                            RankIcon.SetImage(Bronze2)
                        else if (RankTracker.GetValue(NewPlayer) > 99 and RankTracker.GetValue(NewPlayer) < 150):
                            TextBlock2.SetText(TextForUIRank(RankToString,"150"))
                            TextBlockRank.SetText(TextForRank("Bronze III"))
                            RankIcon.SetImage(BronzeRank)
                        else if (RankTracker.GetValue(NewPlayer) > 149 and RankTracker.GetValue(NewPlayer) < 200):
                            TextBlock2.SetText(TextForUIRank(RankToString,"200"))
                            TextBlockRank.SetText(TextForRank("Silver I"))
                            TextBlockRank.SetTextColor(Silver)
                            RankIcon.SetImage(Silver1)
                        else if (RankTracker.GetValue(NewPlayer) > 199 and RankTracker.GetValue(NewPlayer) < 250):
                            TextBlock2.SetText(TextForUIRank(RankToString,"250"))
                            TextBlockRank.SetText(TextForRank("Silver II"))
                            TextBlockRank.SetTextColor(Silver)
                            RankIcon.SetImage(Silver2)
                        else if (RankTracker.GetValue(NewPlayer) > 249 and RankTracker.GetValue(NewPlayer) < 300):
                            TextBlock2.SetText(TextForUIRank(RankToString,"300"))
                            TextBlockRank.SetText(TextForRank("Silver III"))
                            TextBlockRank.SetTextColor(Silver)
                            RankIcon.SetImage(Silver3)
                        else if (RankTracker.GetValue(NewPlayer) > 299 and RankTracker.GetValue(NewPlayer) < 350):
                            TextBlock2.SetText(TextForUIRank(RankToString,"350"))
                            TextBlockRank.SetText(TextForRank("Gold I"))
                            TextBlockRank.SetTextColor(Gold)
                            RankIcon.SetImage(Gold1)
                        else if (RankTracker.GetValue(NewPlayer) > 349 and RankTracker.GetValue(NewPlayer) < 400):
                            TextBlock2.SetText(TextForUIRank(RankToString,"400"))
                            TextBlockRank.SetText(TextForRank("Gold II"))
                            TextBlockRank.SetTextColor(Gold)
                            RankIcon.SetImage(Gold2)
                        else if (RankTracker.GetValue(NewPlayer) > 399 and RankTracker.GetValue(NewPlayer) < 450):
                            TextBlock2.SetText(TextForUIRank(RankToString,"450"))
                            TextBlockRank.SetText(TextForRank("Gold III"))
                            TextBlockRank.SetTextColor(Gold)
                            RankIcon.SetImage(Gold3)
                        else if (RankTracker.GetValue(NewPlayer) > 449 and RankTracker.GetValue(NewPlayer) < 500):
                            TextBlock2.SetText(TextForUIRank(RankToString,"500"))
                            TextBlockRank.SetText(TextForRank("Platinum I"))
                            TextBlockRank.SetTextColor(NamedColors.CadetBlue)
                            RankIcon.SetImage(Platinum1)
                        else if (RankTracker.GetValue(NewPlayer) > 499 and RankTracker.GetValue(NewPlayer) < 550):
                            TextBlock2.SetText(TextForUIRank(RankToString,"550"))
                            TextBlockRank.SetText(TextForRank("Platinum II"))
                            TextBlockRank.SetTextColor(NamedColors.CadetBlue)
                            RankIcon.SetImage(Platinum2)
                        else if (RankTracker.GetValue(NewPlayer) > 549 and RankTracker.GetValue(NewPlayer) < 600):
                            TextBlock2.SetText(TextForUIRank(RankToString,"600"))
                            TextBlockRank.SetText(TextForRank("Platinum III"))
                            TextBlockRank.SetTextColor(NamedColors.CadetBlue)
                            RankIcon.SetImage(Platinum3)
                        else if (RankTracker.GetValue(NewPlayer) > 599 and RankTracker.GetValue(NewPlayer) < 650):
                            TextBlock2.SetText(TextForUIRank(RankToString,"650"))
                            TextBlockRank.SetText(TextForRank("Diamond I"))
                            TextBlockRank.SetTextColor(NamedColors.CornflowerBlue)
                            RankIcon.SetImage(Diamond1)
                        else if (RankTracker.GetValue(NewPlayer) > 649 and RankTracker.GetValue(NewPlayer) < 700):
                            TextBlock2.SetText(TextForUIRank(RankToString,"700"))
                            TextBlockRank.SetText(TextForRank("Diamond II"))
                            TextBlockRank.SetTextColor(NamedColors.CornflowerBlue)
                            RankIcon.SetImage(Diamond2)
                        else if (RankTracker.GetValue(NewPlayer) > 699 and RankTracker.GetValue(NewPlayer) < 750):
                            TextBlock2.SetText(TextForUIRank(RankToString,"750"))
                            TextBlockRank.SetText(TextForRank("Diamond III"))
                            TextBlockRank.SetTextColor(NamedColors.CornflowerBlue)
                            RankIcon.SetImage(Diamond3)
                        else if (RankTracker.GetValue(NewPlayer) > 749 and RankTracker.GetValue(NewPlayer) < 800):
                            TextBlock2.SetText(TextForUIRank(RankToString,"800"))
                            TextBlockRank.SetText(TextForRank("Elite"))
                            TextBlockRank.SetTextColor(NamedColors.DarkGrey)
                            RankIcon.SetImage(EliteRank)
                        else if (RankTracker.GetValue(NewPlayer) > 799 and RankTracker.GetValue(NewPlayer) < 850):
                            TextBlock2.SetText(TextForUIRank(RankToString,"850"))
                            TextBlockRank.SetText(TextForRank("Champion"))
                            TextBlockRank.SetTextColor(NamedColors.OrangeRed)
                            RankIcon.SetImage(ChampionRank)
                        else if (RankTracker.GetValue(NewPlayer) > 849 and RankTracker.GetValue(NewPlayer) < 999999):
                            TextBlock2.SetText(TextForUIRank(RankToString,"850"))
                            TextBlockRank.SetText(TextForRank("Elite"))
                            TextBlockRank.SetTextColor(NamedColors.DarkGrey)
                            RankIcon.SetImage(EliteRank)
                        
                        
    

                        
                        #Kell tracker
                        var TextBlock : text_block = text_block{DefaultTextColor := White, DefaultShadowColor := Black, DefaultShadowOffset:= {option{vector2{X := 3.0,Y := 3.0}}}}
                        TextBlock.SetShadowOpacity(1.0)
                        

                        MyCanvas := canvas:
                            Slots := array:
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.05}, Maximum := vector2{X := 0.5, Y := 0.05}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := 0.5, Y := -0.10}
                                    SizeToContent := true
                                    Widget := TextBlock
                        Print("Ui should be added")
                        PlayerUI.AddWidget(MyCanvas)

                        var TextBlockRound : text_block = text_block{DefaultTextColor := Gold,DefaultShadowColor := Orange, DefaultShadowOffset:= {option{vector2{X := -2.0,Y := 2.0}}}}
                        TextBlockRound.SetShadowOpacity(1.0)
                        var RoundIconBlock : texture_block = texture_block{DefaultImage := RoundIcon, DefaultDesiredSize:= vector2{X:=190.0, Y:=190.0}}


                        RoundCanvas := canvas:
                            Slots := array:
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.407, Y := 0.92}, Maximum := vector2{X := 0.407, Y := 0.92}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := 0.3, Y := 1.72}
                                    SizeToContent := true
                                    Widget := TextBlockRound
                                canvas_slot:
                                    Anchors := anchors{Minimum := vector2{X := 0.4, Y := 0.95}, Maximum := vector2{X := 0.4, Y := 0.95}}
                                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                                    Alignment := vector2{X := 0.4, Y := 0.95}
                                    SizeToContent := true
                                    Widget := RoundIconBlock

                        Print("Ui should be added")
                        PlayerUI.AddWidget(RoundCanvas)

                        spawn{KillSpawnLoop(PlayerObj, TextBlock, MyCanvas, NewPlayer)}

                        spawn{RankSpawnLoop(PlayerObj, TextBlock2, TextBlockRank, RankIcon, TextBlockRound, NewPlayer)}


                        

    OnPlayerRemoved(PlayerLeaving : player):void =
        if (ActualPlayer := PlayerMap[PlayerLeaving]):
            var TempPlayerMap:[player]RankDeviceManager = map{}
            for (Key -> Value : PlayerMap, Key <> PlayerLeaving):
                set TempPlayerMap = ConcatenateMaps(TempPlayerMap, map{Key => Value})

            set PlayerMap = TempPlayerMap
