//==============================================================================
//	MutRules.uc (C) 2011 Eliot All Rights Reserved
//
//	Coded by Eliot Van Uytfanghe
//	Updated @ 20/08/2011
//==============================================================================
class MutRules extends Mutator
	config(Rules);

const MAXPIECES = 5;

var() globalconfig string RulesText;

// Because the max replicated chars of a string is 0xFF,
// we'll have to split the RulesText into MAXPIECES separated strings so 0xFF*MAXPIECES becomes the maximum length which is long enough!
var string ReplicatedRulesText[MAXPIECES];

replication
{
	reliable if( bNetInitial )
		ReplicatedRulesText;
}

event PreBeginPlay()
{
	local int numPieces, rulesLength;
	local int i;

	super.PreBeginPlay();

	if( RulesText == "" )
	{
		Warn( "RulesText is empty! Please specify some rules or remove this mutator!" );
		Destroy();
		return;
	}

	rulesLength = Len( RulesText );
	if( rulesLength > 0xFF * MAXPIECES )
	{
		Warn( "RulesText has more than" @ (0xFF * MAXPIECES) @ "characters! And won't all be replicated to the clients, please make your rules more concise." );
	}

	// Lets split the RulesText into 4 pieces if possible.
	numPieces = Min( rulesLength / 0xFF, MAXPIECES );

	if( rulesLength % 0xFF > 0 )
	{
		++ numPieces;
	}

	//Log( "numpieces<<<<<<<<<<:" $ numPieces, Name );
	ReplicatedRulesText[0] = Left( RulesText, 0xFF );
	//Log( "0<<<<<<<<<<<<:" $ ReplicatedRulesText[0], Name );
	for( i = 1; i < numPieces; ++ i )
	{
		ReplicatedRulesText[i] = Left( Mid( RulesText, 0xFF * i ), 0xFF );

		// DEBUG
		//Log( i $ "<<<<<<<<<<<<:" $ ReplicatedRulesText[i], Name );
	}
}

simulated event Tick( float DeltaTime )
{
	local PlayerController PC;

	local UT2K4PlayerLoginMenu Menu;
	local GUITabPanel Panel;

	if( Level.NetMode == NM_DedicatedServer )
	{
		Disable('Tick');
		return;
	}

	PC = Level.GetLocalPlayerController();
	if( PC == none )
		return;

  	// If you borrow this code, please give credit where due!
	Menu = UT2K4PlayerLoginMenu(GUIController(PC.Player.GUIController).FindPersistentMenuByName( UnrealPlayer(PC).LoginMenuClass ));
	if( Menu != none )
	{
		Panel = Menu.c_Main.AddTab( "Rules", string(class'RulesMenu'), ,"Rules of this server" );
		if( Panel != none )
		{
			Menu.c_Main.Controller.RegisterStyle( class'STY_RulesButton', true );
			Panel.MyButton.StyleName = "RulesButton";
			Panel.MyButton.Style = Menu.c_Main.Controller.GetStyle( "RulesButton", Panel.FontScale );
		}
		Disable( 'Tick' );
	}
}

defaultproperties
{
	bAddToServerPackages=true

	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true

	FriendlyName="Rules"
	Description="This mutator gives you a rules tab to inform people about your server's rules. Created by Eliot Van Uytfanghe @ 2011"
}
