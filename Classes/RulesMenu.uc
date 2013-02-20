//==============================================================================
//	RulesMenu.uc (C) 2011 Eliot All Rights Reserved
//
//	Coded by Eliot Van Uytfanghe
//	Updated @ 20/08/2011
//==============================================================================
class RulesMenu extends MidGamePanel;

const MAXPIECES = 5;

var automated GUIScrollTextBox eb_Desc;

function InitComponent( GUIController InController, GUIComponent InOwner )
{
	local int i;
	local MutRules rulesActor;
	local string bigString;

	super.InitComponent( InController,InOwner );

	foreach PlayerOwner().DynamicActors( class'MutRules', rulesActor )
		break;

	if( rulesActor == none )
	{
		Warn( "Couldn't find any MutRules instance" );
		return;
	}

	for( i = 0; i < MAXPIECES; ++ i )
	{
		bigString $= rulesActor.ReplicatedRulesText[i];
	}

	eb_Desc.MyScrollText.SetContent( bigString );

	eb_Desc.MyScrollBar.AlignThumb();
	eb_Desc.MyScrollBar.UpdateGripPosition( 0 );
}

defaultproperties
{
	Begin Object Class=GUIScrollTextBox Name=Desc
		WinWidth	=	0.98
		WinHeight	=	0.98
		WinLeft		=	0.01
		WinTop		=	0.01
		bBoundToParent=False
		bScaleToParent=False
		StyleName="NoBackground"
		bNoTeletype=true
		bNeverFocus=true
	End Object
	eb_Desc=Desc
}
