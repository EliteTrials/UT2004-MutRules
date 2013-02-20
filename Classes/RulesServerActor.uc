//==============================================================================
//	RulesServerActor.uc (C) 2011 Eliot All Rights Reserved
//
//	Coded by Eliot Van Uytfanghe
//	Updated @ 20/08/2011
//==============================================================================
class RulesServerActor extends Info;

event PreBeginPlay()
{
	Level.Game.AddMutator( string(class'MutRules'), true );
	Destroy();
}
