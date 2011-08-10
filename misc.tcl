######## Caro - Misc features #######
#                                   #
#####################################

# Bind commands

bind pub - "${prefix}die" pub_die
bind pub - "${prefix}rehash" pub_rehash
bind pub - "${prefix}restart" pub_restart
bind pub - "${prefix}raw" pub_raw
bind pub - "${prefix}version" pub_version
bind pub - "${prefix}status" pub_status
bind ctcp - version ctcp_version
bind pub - "${prefix}announce" pub_announce
bind pub - "${prefix}gethandle" pub_gethandle
bind mode - * mode_getop
bind pub - "${prefix}chattr" pub_chattr
bind pub - "${prefix}tcl" pub_tcl
bind time - "* * * * *" check_bans

bind bot - announce bot_announce
bind bot - rehash bot_rehash
bind bot - restart bot_restart
bind bot - die bot_die
bind bot - ochantopic bot_ochantopic

bind pub - "${prefix}grehash" pub_grehash
bind pub - "${prefix}grestart" pub_grestart
bind pub - "${prefix}gdie" pub_gdie
bind pub - "${prefix}officialtopic" pub_ochantopic

bind pub - "${prefix}lookup" pub_dnslookup

bind join - "*" join_greet
bind pub - "${prefix}greet" pub_greet

bind pub - "${prefix}calc" pub_calc

bind pub - "${prefix}rand" pub_rand

bind pub - "${prefix}staff" pub_staff

bind pub - "${prefix}quote" pub_quote

bind join - "*" join_usrlimit
bind part - "*" part_usrlimit
bind sign - "*" part_usrlimit
bind kick - "*" kick_usrlimit

bind join - "*" join_peak
bind pub - "${prefix}peak" pub_peak

bind pub - "${prefix}auto" pub_auto

bind pub - "${prefix}needop" pub_needop
bind pub - "${prefix}needowner" pub_needowner

bind pub - "${prefix}jump" pub_jump

bind evnt - sighup evnt_sig
bind evnt - sigterm evnt_sig
bind evnt - sigill evnt_sig
bind evnt - sigquit evnt_sig


proc evnt_sig { type } {
    
    cmdlog "--" "--" "--" "Recieved $type."
    
    
    
}


# Identifcation
bind pub - ${prefix}identify pub_identify
proc pub_identify {nick host hand chan arg} {
    
    if { [matchattr $hand A] || [matchattr $hand H] } { 
        
        do_identify $chan

    } else {
        noaccess $nick
        return
    }
}

# Opering
bind pub - ${prefix}oper pub_oper
proc pub_oper {nick host hand chan arg} {
    
    if { [matchattr $hand A] || [matchattr $hand H] } { 
        
        do_oper $chan
        
    } else {
        noaccess $nick
        return
    }
}

bind evnt - init-server evnt_identify_oper

proc evnt_identify_oper {type} {

    global settings
    
    do_identify $settings(staffchan)
    do_oper $settings(staffchan)
    
}


proc do_identify {chan} {

    global NickServ
    global NSuser
    global NSpass
    
    if { $NickServ == 1 } {    
        putquick "PRIVMSG NickServ :IDENTIFY $NSuser $NSpass"
        putlog "Caro - Identified at NickServ"
        putquick "PRIVMSG $chan :Identified at NickServ."
    }  else {
        putquick "PRIVMSG $chan :No NickServ data set."
        return
    }

}

proc do_oper {chan} {

    global Oper
    global OperUser
    global OperPass
    
    if { $Oper == 1 } {
        putquick "OPER $OperUser $OperPass"
        putlog "Caro - Opered up"
        putquick "PRIVMSG $chan :Opered up."
    } else {
        putquick "PRIVMSG $chan :No oper data set."
        return
    }

}

# Die
proc pub_die {nick host hand chan arg} {
    
    global botnick
    
    # Check permissions
    if {[matchattr $hand A] == 0} {
        noaccess $nick
        return
    }
    cmdlog $chan $nick $hand "die $arg"
    
    if { $arg == "" } {
        die "\002${nick}\002 shuts down ${botnick}"      
    } else {
        die "\002${nick}\002 shuts down $botnick \(\002Reason\002: ${arg}\)" 
    }
    
    
}

# Rehash
proc pub_rehash {nick host hand chan arg} {
    global botnick
    
    # Check permissions
    if {[matchattr $hand A] == 1 || [matchattr $hand H]} {
        cmdlog $chan $nick $hand "rehash"
        putquick "PRIVMSG $chan :Rehashing my configuration and scripts ..."  
        rehash
    } else {
        noaccess $nick
        return
    }
}

# Restart
proc pub_restart {nick host hand chan arg} {
    
    # Check permissions
    if {[matchattr $hand A] == 1 || [matchattr $hand H]} {
    
        global botnick
    
        putquick "NOTICE $nick :Restarting $botnick services."
        cmdlog $chan $nick $hand "restart"
    
        restart
    } else {
        noaccess $nick
        return
    }
}

# RAW
proc pub_raw {nick host hand chan arg} {
    if {[matchattr $hand A] == 1} {
    
        if {$arg == ""} {
            notice $nick "Not enough arguments for RAW."
            return
        }
    
        putquick "NOTICE $nick :Executed $arg."
        cmdlog $chan $nick $hand "raw $arg"
    
        putquick $arg
    } else {
        noaccess $nick
        return
    }
    
}

# Version
proc pub_version {nick host hand chan arg} {
    global caroversion
    putquick "PRIVMSG $chan :$caroversion"
}

#CTCP Version
proc ctcp_version {nick host hand dest keyword arg} {
    global caroversion
    puthelp "NOTICE $nick :\001$keyword $caroversion\001"
}


# Status
proc pub_status {nick host hand chan arg} {
    
    global caroversion
    global botnick
    global staffchan settings
    global officialchan settings
    
    notice $nick $caroversion
    notice $nick "I have [countusers] registered users."
    notice $nick "My official channel: $settings(officialchan)."
    notice $nick "My staff is in $settings(staffchan)."
    notice $nick "At the moment I'm in [llength [channels]] channels."
    
}

# Global Announcement
proc pub_announce {nick host hand chan arg} {
    
    if { [matchattr $hand A] == 1 } {
        
        putallbots "announce \002|Announcement|\002 $nick: $arg"        
        foreach chan [channels] { putserv "Privmsg $chan :\002|Announcement|\002 $nick: $arg" }
    } else {
        noaccess $nick
        return
    }
}

# Incoming announcement
proc bot_announce {bot cmd arg} {
    
    foreach chan [channels] { putserv "Privmsg $chan :$arg" }    
    
}

# Get handle
proc pub_gethandle {nick host hand chan arg} {

    if { [nick2hand $arg] == "" } { putquick "PRIVMSG $chan :I can not find '$arg'." ; return }
    if { [nick2hand $arg] == "*" } { putquick "PRIVMSG $chan :'$arg' is not registered or not logged in at me." ; return }
    
    putquick "PRIVMSG $chan :${arg}'s handle is '[nick2hand $arg]'."
}


# Chattr
proc pub_chattr {nick host hand chan arg} {

    if { [matchattr $hand A] == 1 } {
        
        set arg1 [lindex [split $arg] 0]
        set arg2 [join [lrange [split $arg] 1 end]]
        
        if { [validuser $arg1] == 0 } { putquick "PRIVMSG $chan :I can not find $arg1 in my user database." ; return }
        
        
        chattr $arg1 $arg2
        
        putquick "PRIVMSG $chan :Setted mode(s) '$arg2' on handle $arg1."
        
        
    } else {
        noaccess $nick
        return
    }
}

# Tcl
proc pub_tcl {nick host hand chan arg} {

    if { [matchattr $hand A] == 1 } {

        exec $arg
        
    } else {
        noaccess $nick
        return
    }
}


# Getop
proc mode_getop {nick host hand chan modes target} {
    
    global botnick
    global NickServ
    global Oper
    
    if { $target == $botnick && $modes == "-o" } {
        if { $Oper == 1 } {
            putquick "PRIVMSG OperServ :MODE $chan +o $botnick"
            return
        }        
        if { $NickServ == 1 } {
            putquick "PRIVMSG ChanServ :OP $chan"
            return
        }
    } elseif { $target == $botnick && $modes == "+o" } {
        
        set users [llength [chanlist $chan]]
        
        set newusers [expr $users + 4]
   
        #putquick "MODE $chan +l $newusers"
    
    }
    
}

# Check Bans
proc check_bans { minute hour day month year } {


    foreach chan [channels] { 
        
        if { ![channel get $chan nosync] } {
            resetbans $chan 
        }
    }
	foreach chan [channels] { 
        if { ![channel get $chan nosync] } {
            resetexempts $chan 
        }
    }
	foreach chan [channels] { 
        if { ![channel get $chan nosync] } {
            resetinvites $chan 
        }
    }

}


proc pub_grehash {nick host hand chan arg} {

    if {[matchattr $nick A] == 1 } {
        
        putallbots "rehash $chan $nick $hand"
        
        putquick "PRIVMSG $chan :Rehashing my configuration and scripts on all linked bots ..."  
        cmdlog $chan $nick $hand "global rehash"
        rehash
        
    } else {
        noaccess $nick
        return
    }
}

proc pub_grestart {nick host hand chan arg} {

    global botnick
    if {[matchattr $nick A] == 1 } {
        
        putallbots "restart $chan $nick $hand"
        
        putquick "NOTICE $nick :Global restart of $botnick."
        cmdlog $chan $nick $hand "global restart"
        restart
        
    } else {
        noaccess $nick
        return
    }
}

proc pub_gdie {nick host hand chan arg} {

    if {[matchattr $nick A] == 1 } {
        
        putallbots "die $chan $nick $hand"
        
        cmdlog $chan $nick $hand "global die"
        die "Global shutdown."
        
    } else {
        noaccess $nick
        return
    }
}

proc bot_rehash {bot cmd arg} {

    set chan [lindex $arg 0]
    set nick [lindex $arg 1]
    set hand [lindex $arg 2]

    cmdlog "$chan @ $bot" $nick $hand "global rehash"
    rehash
    
}

proc bot_restart {bot cmd arg} {
 
    set chan [lindex $arg 0]
    set nick [lindex $arg 1]
    set hand [lindex $arg 2]

    cmdlog "$chan @ $bot" $nick $hand "global restart"
    restart
    
}

proc bot_die {bot cmd arg} {
 
    set chan [lindex $arg 0]
    set nick [lindex $arg 1]
    set hand [lindex $arg 2]

    cmdlog "$chan @ $bot" $nick $hand "global die"
    die
    
}

### AUTO-LIMIT ###

proc join_usrlimit {nick host hand chan} {

	if { [channel get $chan autolimit] } {
		set users [llength [chanlist $chan]]
		
		set newusers [expr $users + 3 + [round [expr $users / 10]]]
		
		utimer 20 [list set_limit $chan $newusers]
	}
}
proc part_usrlimit {nick host hand chan msg} {
    
    if { [channel get $chan autolimit] } {
		set users [llength [chanlist $chan]]
		
		set newusers [expr $users + 2 + [round [expr $users / 10]]]
		
		utimer 2 [list set_limit $chan $newusers]
	}
 
}

proc kick_usrlimit {nick host hand chan target reason} {
    
    if { [channel get $chan autolimit] } {
		set users [llength [chanlist $chan]]
		
		set newusers [expr $users + 2 + [round [expr $users / 10]]]
		
		utimer 2 [list set_limit $chan $newusers]
	}
 
}

proc set_limit {chan limit} {
    putquick "MODE $chan +l $limit"
}

################

proc pub_dnslookup {nick host hand chan arg} {
    
    if {$arg == "" } { putquick "PRIVMSG $chan :No IP/hostname specified." ; return }
    
    dnslookup $arg send_lookup $chan
    
    
}

proc send_lookup {ip hostname status arg} {
    
    if { $status == 0 } { putquick "PRIVMSG $arg :Error while resolving the hostname/IP." ; return }
    
    putquick "PRIVMSG $arg :IP:       $ip"
    putquick "PRIVMSG $arg :Hostname: $hostname"
    
    
}

proc pub_ochantopic {nick host hand chan arg} {

    if { [matchattr $hand A] || [matchattr $hand H] } {
        
        global officialchan settings
        
        if { [topic $settings(officialchan)] != $arg } {
        
            putquick "TOPIC $settings(officialchan) :$arg"
        
        }
        
        putallbots "ochantopic $arg"        
        
        
    } else {
        noaccess $nick
        return
    }
}

proc bot_ochantopic {bot cmd arg} {

    global officialchan settings
     
    if { [topic $settings(officialchan)] != $arg } {
        
        putquick "TOPIC $settings(officialchan) :$arg"
        
    }
    
}


proc join_greet {nick host hand chan} {

	if { $hand != "*" && ![channel get $chan nogreet]} {
		
		set greet [getuser $hand XTRA GREET]
		
		if { $greet != "" } {
			
			putquick "PRIVMSG $chan :\0035\002(\002\00314$nick\0035\002)\002\0031 - $greet"
		
		}
	}
    
    if { [channel get $chan entrymsg] != "" } {
        
        notice $nick "${chan} - [channel get $chan entrymsg]"
    }
}

proc pub_greet {nick host hand chan arg} {

	global botnick
	if { $hand == "*" } { notice $nick "You have to be logged in to $botnick to do that." ; return }
	
	if { $arg == "" } { 
		setuser $hand XTRA GREET ""
		notice $nick "Greet message resetted."
		return 
	} else {
		setuser $hand XTRA GREET $arg
		notice $nick "Greet message set to: $arg"
		return
	}	
}

proc pub_calc {nick host hand chan arg} {
	
	if { $arg == "" } { notice $nick "You have to specify a term." ; return }
	
	set outp [expr $arg]
	
	putquick "PRIVMSG $chan :\002Result:\002 $outp"
	
}


proc pub_rand {nick host hand chan arg} {

	global prefix

	set low [lindex $arg 0]
    set high [lindex $arg 1]


	if { $arg == "" } { 
		notice $nick "You have to specify a limit:"
		notice $nick "${prefix}rand <limit> for a number between 0 and <limit>,"
		notice $nick "${prefix}rand <low limit> <high limit> for a number between <low limit> and <high limit>."
		return
	}
	
	set outp [rand [expr $arg + 1]]
	
	putquick "PRIVMSG $chan :\002Random number between 0 and $arg:\002 $outp"
	
}


proc pub_staff {nick host hand chan arg} {
	
	global botnick
	
	set admins [userlist A]
	set helpers [userlist H]
	
	if { $admins == "" } { set admins " - None - " }
	if { $helpers == "" } { set helpers " - None - " }
	
	notice $nick "*** \002$botnick staff\002 ***"
	notice $nick " \002Admins:\002"
	notice $nick "   $admins"
	notice $nick " \002Helpers:\002"
	notice $nick "   $helpers"
	notice $nick "*** \002$botnick staff end\002 ***"
	
	
}

## PEAK ##

setudef int peaktime
setudef int peaknum

proc join_peak {nick host hand chan} {
    
    if { [channel get $chan peaknum] <= [llength [chanlist $chan]] } {
     
        channel set $chan peaktime [unixtime]
        channel set $chan peaknum [llength [chanlist $chan]]
        
    }
    
}

proc pub_peak {nick host hand chan arg} {

    if { [channel get $chan peaknum] < [llength [chanlist $chan]] } {
     
        channel set $chan peaktime [unixtime]
        channel set $chan peaknum [llength [chanlist $chan]]
        
        putquick "PRIVMSG $chan :${chan} reaches it's user peak with \002$peaknum\002 users now!"
        
        return
        
    }
    
    set peaktime [strftime "%d/%m/%Y at %H:%M:%S %Z" [channel get $chan peaktime]]
    set peaknum [channel get $chan peaknum]
    
    putquick "PRIVMSG $chan :${chan} reached it's user peak with \002$peaknum\002 users on ${peaktime}."
 
 
}

## AUTO ##

proc pub_auto {nick host hand chan arg} {
    
    if { $arg == "on" } {
        
        if { ![matchattr $hand c] } { notice $nick "Autovoice/Autoop is already enabled." ; return }
        
        chattr $hand -c
        
        notice $nick "Autovoice/Autoop is now enabled."
    } elseif { $arg == "off" } {
        
        if { [matchattr $hand c] } { notice $nick "Autovoice/Autoop is already disabled." ; return }
        
        chattr $hand +c
        
        notice $nick "Autovoice/Autoop is now disabled."
        
    } else {
        notice $nick "*** \002${prefix}auto\002 ***"
        notice $nick "  Enabled or disables voicing/oping of you on join."
        notice $nick ""
        notice $nick " \002Syntax:\002"
        notice $nick "   ${prefix}auto \{ on|off \}"
        notice $nick "*** \002${prefix}auto End\002 ***"
    }
    
    
}

setudef str quotes
proc pub_quote {nick host hand chan arg} {

    set arg1 [lindex [split $arg] 0]
    set arg2 [join [lrange [split $arg] 1 end]]
	
	if { $arg1 == "add" } {
		
		if { [accessint $hand $chan] >= 1 } {
            
            set append "${nick}\t${arg2}\n"
            set prepend [channel get $chan quotes]
            set new "${prepend}${append}"
            
            channel set $chan quotes $new
            
            set quotes [split $new "\n"]
            
            putquick "PRIVMSG $chan :Quote added, I now have [expr [llength $quotes]-1] quotes for $chan."
            
		} else {
			noaccess $nick
			return
		} 
		
	} elseif { [string match "\#?*" $arg1] == 1} {
        
        set num [lindex [split $arg1 "#"] 1]
        
        set data [channel get $chan quotes]
		
		set quotes [split $data "\n"]
        
        if { $num > [expr [llength $quotes]-1] || $num < 0 } {
        
            putquick "PRIVMSG $chan :I have no quote $arg1 in my database."
            return
        }
        
        set act_quote [lindex $quotes $num]
		
		set act_data [split $act_quote "\t"]
		
		set act_nick [lindex $act_data 0]
		set act_msg [lindex $act_data 1]
        
        putquick "PRIVMSG $chan :(\002#$num\002 by ${act_nick}) $act_msg"
        
        
    } else {
   
        
		set randchan [lindex [split [channels] " "] [rand [llength [split [channels] " "]]]]
        
        set quotes [channel get $randchan quotes]
		
		putquick "PRIVMSG $chan :(\002#$quotenum\002 by ${act_nick}) $act_msg"
	}
}


proc pub_needop {nick host hand chan arg} {
    
    if { [matchattr $hand A] || [matchattr $hand H] } {
        
        set i 0
        
        notice $nick "I am not opped in the following channels:"
        
        foreach ch [channels] {
            
            if {![botisop $ch] && ![channel get $ch inactive] && ![botonchan $ch]} {
                
                notice $nick "  $ch"
                incr i
            }           
        }
        
        if { $i == 0 } { notice $nick "  None." }
        
    } else {
        noaccess $nick
        return
    }
}

proc pub_needowner {nick host hand chan arg} {
    
    if { [matchattr $hand A] || [matchattr $hand H] } {
        
        set i 0
        
        notice $nick "I have no channel owner in the following channels:"
        
        foreach chan [channels] {
            
            if {[llength [userlist |N $chan]] == 0} {
                
                if { [channel get $chan inactive] } {
                    notice $nick "  $chan (suspended)"
                } else {                
                    notice $nick "  $chan"
                }
                incr i
            }           
        }
        
        if { $i == 0 } { notice $nick "  None." }
        
    } else {
        noaccess $nick
        return
    }
}


proc pub_jump {nick host hand chan arg} {
    
    if { [matchattr $hand A] || [matchattr $hand H] } {
        
        
        if { $arg != "" } {
            putquick "PRIVMSG $chan :Jumping to $arg in 5 seconds."
            cmdlog $chan $nick $hand "jump to $arg"
            
            utimer 5 [list jump $arg]
        } else {
            putquick "PRIVMSG $chan :Jumping to next server in my serverlist in 5 seconds."
            cmdlog $chan $nick $hand "jump to next server"
            
            utimer 5 [jump]
        }
        
        putquick "PRIVMSG $chan :Jumping"
    }
}


proc cleanarg {arg} {
 set temp ""
  for {set i 0} {$i < [string length $arg]} {incr i} {
  set char [string index $arg $i]
  if {($char != "\12") && ($char != "\15")} {
   append temp $char
  }
 }
 set temp [string trimright $temp "\}"]
 set temp [string trimleft $temp "\{"]
  return $temp
}

# No Access Error
proc noaccess {nick} {
global settings
    putquick "NOTICE $nick :You don't have access to this command. If you think you should have access to this command, please contact the administrators on $settings(officialchan)."
}
# Send logs to 
proc cmdlog { chan nick hand cmd } {
global staffchan settings

    putcmdlog "Caro - ($chan) \[$nick:$hand\] $cmd"
    putquick "NOTICE $settings(staffchan) :($chan) \[$nick:$hand\] $cmd"
} 

# Notice
proc notice {who msg} {
    putquick "NOTICE $who :$msg"
}

proc round {number {digits 0}} {
    return [expr {round(pow(10,$digits)*$number)/pow(10,$digits)}]
}


putlog "Caro - misc.tcl loaded."