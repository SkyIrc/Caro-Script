######## Caro - Help features #######
#                                   #
#####################################

# Bind Commands
global botnick

bind pub - "${prefix}help" help

proc help {nick host hand chan arg} {
    global botnick
    global prefix
	global settings
	global owner
	global admin
    switch -glob -- $arg {
    
        ### ChanUser COMMANDS ###
        "user" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help user\002"
            notice $nick "  ${prefix}version                    Shows the actual script version."
            notice $nick "  ${prefix}status                     Shows ${botnick}'s status info."
            notice $nick "  ${prefix}gethandle <nick>           Returns the username / handle of a nick, if there is one."
            notice $nick "  ${prefix}lookup                     Looks up the given Hostname/IP."
            notice $nick "  ${prefix}access \[nick\]              Shows your or other's channel and global access level."
			notice $nick "  ${prefix}greet \[message\]            Sets your greet message. No argument cleares the message."
			notice $nick "*** \002End Help\002 ***"
        }
        ### ChanVOP COMMANDS ###
        "vop" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help VOP\002"
            notice $nick "  All user commands included."
            notice $nick "  ${prefix}voice                      Voices you."
            notice $nick "  ${prefix}devoice                    Devoices you."
            notice $nick "  ${prefix}up                         Gives you voice/op."
            notice $nick "  ${prefix}down                       Takes you voice/op."
            notice $nick "  ${prefix}accesslist                 Shows all users of the channel with their access level."
            notice $nick "  ${prefix}invite <nick>              Invites the given user to the channel."
            notice $nick "  ${prefix}auto \{ on|off \}            En-/Disables voicing on join."
			notice $nick "*** \002End Help\002 ***"
        }
        ### ChanVOP COMMANDS ###
        "hop" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help HOP\002"
            notice $nick "  All VOP commands included."
            notice $nick "  ${prefix}voice \[nick\]               Voices you or another user."
            notice $nick "  ${prefix}devoice \[nick\]             Devoices you or another user."
            notice $nick "  ${prefix}op \[nick\]                  Ops you or another user."
            notice $nick "  ${prefix}deop \[nick\]                Deops you or another user."
            notice $nick "  ${prefix}topic <topic>              Sets the topic of the channel."
            notice $nick "  ${prefix}tappend <text>             Appends the given text to the channel topic."
            notice $nick "  ${prefix}mode <modes>               Changes channelmodes."
            notice $nick "  ${prefix}kick <nick> \[reason\]       Kicks the given user."
            notice $nick "  ${prefix}checkbans                  Synchronisizes channel bans and ${botnick}'s ban list."
            notice $nick "  ${prefix}auto \{ on|off \}            En-/Disables oping on join."
			notice $nick "*** \002End Help\002 ***"
        }
        ### ChanAOP COMMANDS ###
        "aop" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help AOP\002"
            notice $nick "  All HOP commands included."
            notice $nick "  ${prefix}vop \{ add|rem \}                            Edits the Auto-Voice list."
            notice $nick "  ${prefix}banfor <nick/hostmask> \[time \[reason\]\]      Bans and kicks the given user/host for x minutes."
            notice $nick "  ${prefix}ban <nick/hostmask> \[reason\]               Bans and kicks the given user/host for x minutes."
            notice $nick "  ${prefix}unban <nick/hostmask>                      Unbans the given user/host from the channel."
            notice $nick "  ${prefix}warn <nick>                                Warns the given user. 3 Warning-kicks and then ban."
			notice $nick "*** \002End Help\002 ***"
        }
        ### ChanSOP COMMANDS ###
        "sop" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help SOP\002"
            notice $nick "  All AOP commands included."
            notice $nick "  ${prefix}hop \{ add|rem \}            Edits the Half-Op list."
            notice $nick "  ${prefix}say <text>                 Makes $botnick say the given text."
            notice $nick "  ${prefix}me <text>                  Makes $botnick send the given text as ACTION (/me)."                 
			notice $nick "*** \002End Help\002 ***"
        }
        ### ChanOWNER COMMANDS ###
        "owner" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help Owner\002"
            notice $nick "  All SOP commands included."
            notice $nick "  ${prefix}aop \{ add|rem \}              Edits the Auto-Op list."
            notice $nick "  ${prefix}sop \{ add|rem \}              Edits the Super-Op list."
            notice $nick "  ${prefix}owner \{ add|rem \}            Edits the Owner list."
			notice $nick "  ${prefix}set <var> <argument(s)>      Sets diffrent channel variables and features. More help: ${prefix}set"
            notice $nick "  ${prefix}clearbans                    Removes all bans from the channel."
			notice $nick "*** \002End Help\002 ***"
        }


        ### Global Admin COMMANDS ###
        "admin" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help Admin\002"
            notice $nick "  ${prefix}say <text>                     Makes $botnick say the given text."
            notice $nick "  ${prefix}me <text>                      Makes $botnick send the given text as ACTION (/me)."
            notice $nick "  ${prefix}addchan <channel> <owner>      Lets $botnick join the given channel with the specified user as owner."
            notice $nick "  ${prefix}remchan <channel>              Lets $botnick pert the given channel and deletes all data about it."
            notice $nick "  ${prefix}suspend <channel> \[reason\]     Lets $botnick part the given channel without deleting the data." 
            notice $nick "  ${prefix}unsuspend <channel>            Makes $botnick join a suspended channel again."
            notice $nick "  ${prefix}join <channel>                 Lets $botnick join the given channel without setting an owner."
            notice $nick "  ${prefix}adduser <nick>                 Adds a new user for the specified nick."
            notice $nick "  ${prefix}deluser <handle>               Deletes the given user."
            notice $nick "  ${prefix}addhost <handle> <host>        Adds a host to the given user."
            notice $nick "  ${prefix}delhost <handle> <host>        Removes a hostname from the given user."
            notice $nick "  ${prefix}resetpw <handle>               Resets the password of the given user."
            notice $nick "  ${prefix}rehash                         Rehashs configuration and scripts."
            notice $nick "  ${prefix}restart                        Restarts $botnick."
            notice $nick "  ${prefix}die                            Stops $botnick and shuts down."
            notice $nick "  ${prefix}announce <text>                Sends the given text to all linked bots in all channels they're in."
            notice $nick "  ${prefix}grehash                        Like ${prefix}rehash, but rehashes on all linked bots."
            notice $nick "  ${prefix}grestart                       Like ${prefix}restart, but restarts all linked bots."
            notice $nick "  ${prefix}gdie                           Like ${prefix}die, but shuts down all linked bots."
            notice $nick "  ${prefix}chattr <handle> <flag(s)>      Sets the given flags on the specified user."
            notice $nick "  ${prefix}officialtopic <topic>          Sets the topic in the official channel for all linked bots."
            notice $nick "  ${prefix}raw <RAW command>              Lets the bot execute the given IRC RAW command."
			notice $nick "  ${prefix}owner \{ add|rem \}              Manipulates the Owner list of the channel."
			notice $nick "*** \002End Help\002 ***"
        } 

        ### Global Helper COMMANDS ###
        "helper" {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002Help Helper\002"
            notice $nick "  ${prefix}say <text>                     Makes $botnick say the given text."
            notice $nick "  ${prefix}me <text>                      Makes $botnick send the given text as ACTION (/me)."
            notice $nick "  ${prefix}addchan <channel> <owner>      Lets $botnick join the given channel with the specified user as owner."
            notice $nick "  ${prefix}remchan <channel> \[reason\]     Lets $botnick part the given channel and deletes all data about it."
            notice $nick "  ${prefix}suspend <channel> \[reason\]     Lets $botnick part the given channel without deleting the data." 
            notice $nick "  ${prefix}unsuspend <channel>            Makes $botnick join a suspended channel again."
            notice $nick "  ${prefix}join <channel>                 Lets $botnick join the given channel without setting an owner."
            notice $nick "  ${prefix}adduser <nick>                 Adds a new user for the specified nick."
            notice $nick "  ${prefix}addhost <handle> <host>        Adds a host to the given user."
            notice $nick "  ${prefix}delhost <handle> <host>        Removes a hostname from the given user."
            notice $nick "  ${prefix}rehash                         Rehashs configuration and scripts."
            notice $nick "  ${prefix}restart                        Restarts $botnick."
			notice $nick "*** \002End Help\002 ***"
        }       

        default {
			notice $nick "*** \002Start Help\002 ***"
            notice $nick "\002$botnick\002 / \002Cmd Prefix:\002 $prefix"
            notice $nick "\<...\> = needed argument; \[...\] = optional argument; \{ no1|no2 \} = no1 or no2"
            notice $nick "  \002Channel levels\002"
            notice $nick "     ${prefix}help user                 Help for normal channel users."
            notice $nick "     ${prefix}help vop                  VOP (VOiced People) user commands."
            notice $nick "     ${prefix}help hop                  HOP (HalfOp) commands."
            notice $nick "     ${prefix}help aop                  AOP (AutoOp) commands."
            notice $nick "     ${prefix}help sop                  SOP (SuperOp) commands."
            notice $nick "     ${prefix}help owner                Channel owner commands."
            notice $nick "  \002Global levels\002"
            notice $nick "     ${prefix}help helper               Global bot Helper commands."
            notice $nick "     ${prefix}help admin                Global Admin commands."
			notice $nick "Further help is available in the official $botnick channel $settings(officialchan)"
			notice $nick "and from the bot's main administrator ${admin}."
			notice $nick "*** \002End Help\002 ***"
        }
    }
}

putlog "Caro - help.tcl loaded."