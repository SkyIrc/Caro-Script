######## Caro - User features #######
#                                   #
#####################################

# Bind Commands
bind pub - ${prefix}adduser pub_adduser
bind pub - ${prefix}deluser pub_deluser
bind pub - ${prefix}resetpw pub_resetpw
bind pub - ${prefix}addhost pub_addhost
bind pub - ${prefix}delhost pub_delhost
bind msg - help msg_help
bind msg - auth msg_auth
bind msg - login msg_auth
bind msg - id msg_auth
bind msg - identify msg_auth
bind msg - mystatus msg_mystatus



proc pub_adduser {nick host hand chan arg} {
    
    global botnick
    
    if { [matchattr $nick A] == 1 || [matchattr $nick H] == 1 || [accessint $hand $chan] == 5} {
    
		if { ![onchan $arg] } { putquick "PRIVMSG $chan :I can not find $arg" ; return }
	
        set uhost [maskhost [getchanhost $arg $chan] 1]
        
        if { [string length $arg] > 9 } {
            
            set newuser [string range $arg 0 8]
           
            putquick "PRIVMSG $chan :The username '$arg' is too long for me, shortening it to '$newuser'."
            
        } else {
            set newuser $arg
        }
        
        if { [adduser $newuser $uhost] == 1 } {
            putquick "PRIVMSG $chan :Created new user '$newuser'."
            putquick "PRIVMSG $arg :You have to set a password for your account '$newuser' using '/msg $botnick pass <your password>'."
            cmdlog $chan $nick $hand "New user: '$newuser' with host '$uhost'"
            return
        } else {
            
            putquick "PRIVMSG $chan :User '$newuser' does already exist!"
            return
            
        }
    
    
    } else {    
        noaccess $nick
    }
    
    
}

proc pub_resetpw {nick host hand chan arg} { 

    global botnick
    
    if { [matchattr $hand A] == 1 } {
        
        if { $arg == "" } { notice $nick "You have to specify a user to reset the password of." ; return }
        if { [validuser $arg] == 0 } { notice $nick "The user '$arg' is not in my database." ; return } 
        
        setuser $arg PASS
        putquick "PRIVMSG $chan :I resetted ${arg}'s password."
        if { [hand2nick $arg] != "" } { putquick "PRIVMSG [hand2nick $arg] :Your $botnick password has been resetted by $nick ($hand). Set a new one with: '/msg $botnick pass <your password>'." }
        cmdlog $chan $nick $hand "resetpw of $arg" 
        
    } else {
        noaccess $nick
        return
    }
}

proc pub_deluser {nick host hand chan arg} {
    
    global botnick
    
    if { [matchattr $nick A] == 1} {
    
        if { $arg == "" } { notice $nick "You have to specify a user to delete." ; return }
        if { [validuser $arg] == 0 } { notice $nick "The user '$arg' is not in my database." ; return }
    
        deluser $arg
        putquick "PRIVMSG $chan :I deleted user ${arg}."
        if { [hand2nick $arg] != "" } { notice [hand2nick $arg] "Your account on $botnick has been deleted by $nick ($hand)." }
        cmdlog $chan $nick $hand "delete user $arg"
    
    
    } else {    
        noaccess $nick
        return
    }
    
    
}

proc msg_mystatus {nick host hand arg} {
    
    if {$hand == "" || $hand == "*"} {
        
        notice $nick "You're not logged in."
    
    } else {
        
        notice $nick "You're logged in as \002$hand\002."
        
    }
    
    
    
}

proc pub_addhost {nick host hand chan arg} {

    if {[matchattr $hand A] || [matchattr $hand H] } {
    
        set account [lindex $arg 0]
        set host [lindex $arg 1]
        
        if {[validuser $account] == 0 } { putquick "PRIVMSG $chan :I can not find '$account' in my user database." ; return }
        if {[string match "*!*@*" $host] == 0 } { notice $nick "'$host' is no valid hostname." ; return }
        
        
        setuser $account HOSTS $host
        putquick "PRIVMSG $chan :I added '$host' to ${account}'s hostlist."
        cmdlog $chan $nick $hand "add host '$host' to '$account'."
        
    }

}

proc pub_delhost {nick host hand chan arg} {
    
    if {[matchattr $hand A] || [matchattr $hand H] } {
    
        set account [lindex $arg 0]
        set host [lindex $arg 1]
        
        if {[validuser $account] == 0 } { putquick "PRIVMSG $chan :I can not find '$account' in my user database." ; return }
        if {[string match "*!*@*" $host] == 0 } { notice $nick "'$host' is no valid hostname." ; return }
        
        
        if {[delhost $account $host] == 0} { putquick "PRIVMSG $chan :The given host is not in the hostlist of $account." ; return }
        putquick "PRIVMSG $chan :I removed '$host' out of ${account}'s hostlist."
        cmdlog $chan $nich $hand "remove host '$host' to '$account'."
        
    }
    
}


proc msg_help {nick host hand arg} {

    global botnick

    notice $nick "\002/msg $botnick commands:\002"
    notice $nick "  /msg $botnick pass <newpassword>            Set a password after beeing added to the user database."
    notice $nick "  /msg $botnick auth <username> <password>    Recognize at $botnick with a new host."
    notice $nick "  /msg $botnick mystatus                      Check login status."
    notice $nick "  /msg $botnick invite <channel>              Invites you to the given channel."




}


proc msg_auth {nick uhost hand arg} {
    global botnick
    set account [lindex $arg 0]
    set pass [lindex $arg 1]
    if {$hand != "*"} { notice $nick "You Are already identified to account: \002$hand\002." ; return }
    if {![validuser $account]} { notice $nick "Your Account does not exist, are you sure you registered?." ; return}
    if {![passwdok $account $pass]} {notice $nick "Incorrect password; please try again." ; return}
    set host [join \*!\*[join [split $uhost "~"]] ""]
    setuser $account HOSTS $host
    notice $nick "I recognize you from now on with the host '$host', too."
    if {[matchattr $account A] == 1} {
        cmdlog "MSG" $nick $hand "identified to ADMINISTRATOR account $account" 
    }
    if {[matchattr $account H] == 1} {
        cmdlog "MSG" $nick $hand "identified to HELPER account $account" 
    }
}


# No Access Error
proc noaccess {nick} {
    putquick "NOTICE $nick :You don't have access to this command."
}

proc cmdlog { chan nick hand cmd } {
global staffchan settings

    putcmdlog "Caro - ($chan) \[$nick:$hand\] $cmd"
    putquick "NOTICE $settings(staffchan) :($chan) \[$nick:$hand\] $cmd"
} 

proc accessint { hand chan } {
    if { [ matchattr $hand -|V $chan ] == 1 } {
        set ret 1
    } elseif { [ matchattr $hand -|H $chan ] == 1 } {
        set ret 2
    } elseif { [ matchattr $hand -|O $chan ] == 1 } {
        set ret 3
    } elseif { [ matchattr $hand -|S $chan ] == 1 } {
        set ret 4
    } elseif { [ matchattr $hand -|N $chan ] == 1 } {
        set ret 5
    } else {
        set ret 0
    }
    
    return $ret
    
}

putlog "Caro - user.tcl loaded."