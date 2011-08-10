######## Caro - Channel features #######
#                                      #
########################################


# Binds

bind pub - "${prefix}op" pub_op
bind pub - "+o" pub_op
bind pub - "${prefix}deop" pub_deop
bind pub - "-o" pub_deop
bind msg - "op" msg_op

bind pub - "${prefix}voice" pub_voice
bind pub - "+v" pub_voice
bind pub - "${prefix}devoice" pub_devoice
bind pub - "-v" pub_devoice
bind msg - "voice" msg_voice

bind msg - "invite" msg_invite

bind pub - "${prefix}down" pub_down
bind pub - "${prefix}up" pub_up

bind pub - "${prefix}owner" pub_owner
bind pub - "${prefix}sop" pub_sop
bind pub - "${prefix}aop" pub_aop
bind pub - "${prefix}hop" pub_hop
bind pub - "${prefix}vop" pub_vop
bind pub - "${prefix}accesslist" pub_accesslist

bind pub - "${prefix}mode" pub_mode

bind join - "*" join_autoov
bind part - "*" part_gainop

bind pub - "${prefix}access" pub_access
bind pub - "${prefix}say" pub_say
bind pub - "${prefix}me" pub_me
bind pub - "${prefix}act" pub_me
bind pub - "${prefix}cycle" pub_cycle
bind pub - "${prefix}addchan" pub_addchan
bind pub - "${prefix}remchan" pub_remchan
bind pub - "${prefix}join" pub_joinchan

bind pub - "${prefix}kick" pub_kick
bind pub - "+b" pub_ban
bind pub - "${prefix}ban" pub_ban
bind pub - "-b" pub_unban
bind pub - "${prefix}banfor" pub_banfor
bind pub - "${prefix}unban" pub_unban
bind pub - "${prefix}blacklist" pub_blacklist
bind pub - "${prefix}unblacklist" pub_unblacklist
bind pub - "${prefix}warn" pub_warn
bind pub - "${prefix}checkbans" pub_checkbans
bind pub - "${prefix}clearban" pub_clearbans
bind pub - "${prefix}clearbans" pub_clearbans

bind pub - "+e" pub_addexempt
bind pub - "${prefix}addexempt" pub_addexempt
bind pub - "-e" pub_delexempt
bind pub - "${prefix}delexempt" pub_delexempt

bind pub - "${prefix}topic" pub_topic
bind pub - "${prefix}tappend" pub_tappend
bind pub - "${prefix}invite" pub_invite
bind pub - "+I" pub_invite

bind pub - "${prefix}set" pub_set

bind pub - "${prefix}suspend" pub_suspend
bind pub - "${prefix}unsuspend" pub_unsuspend


###########################
### Give and take modes ###
###########################

# Op
proc pub_op {nick host hand chan arg} {
    
    if { $hand != "*" } {
        if { [accessint $hand $chan] >= 2 || [isop $nick $chan]} {
            
            if {$arg == ""} {
                
                putquick "MODE $chan +o $nick"
                return
                
            } else {
                putquick "MODE $chan +oooooooooooooooooo $arg"
            }
            
        } else {
        
            noaccess $nick
            return
            
        }
        
    } else {
        noaccess $nick
        return
    } 
}

# Deop
proc pub_deop {nick host hand chan arg} {
    
    global botnick
    
    if { [isop $nick $chan] == 1 || [accessint $hand $chan] >= 2 } {
        
        
        if { $arg == $botnick } {
            
            notice $nick "You can't deop $botnick."
            return
            
        }
        if { $arg == $nick } {
            
            putquick "MODE $chan -o $nick"
            return
        }   
        if { $arg == "" } {
            
            putquick "MODE $chan -o $nick"
            return
        } 
        
        if { [nick2hand $arg $chan] == ""} { notice $nick "User $arg does not exist." ; return }
        if { [nick2hand $arg $chan] == "*" } {
            
            putquick "MODE $chan -o $arg"
            return
        }
        if { [nick2hand $arg $chan] != "*" && [nick2hand $arg $chan] != "" } {
            
            set user [nick2hand $arg $chan]
            
            if { [accessint $hand $chan] >= [accessint $user $chan] } {
                
                putquick "MODE $chan -o $arg"
            
            } else { notice $nick "You do not have enough permissions to deop $arg" ; return }
            
            
            
        }
    
    }
    
    
}

# MSG-Op
proc msg_op {nick host hand arg} {
    
    if { $hand != "*" } {
        
        if { $arg == "" } { notice $nick "You have to specify a channel to get op on." ; return }
        if { ![botonchan $arg] } { notice $nick "I'm not in $arg." ; return }
        if { ![botisop $arg] } { notice $nick "I'm not opped in $arg." ; return }
        if { [accessint $hand $arg] >= 2 } {
            
            putquick "MODE $arg +o $nick"
            notice $nick "I opped you on $arg."
            
        } else {
            noaccess $nick
            return
        }
        
        
        
    }
    
}

# Voice
proc pub_voice {nick host hand chan arg} {
    
    if { $hand != "*" } {
        if { [accessint $hand $chan] >= 1} {
            
            if {$arg == ""} {
                
                putquick "MODE $chan +v $nick"
                return
                
            } else {
                
                if { [accessint $hand $chan] >= 2 } {
                
                    putquick "MODE $chan +vvvvvvv $arg"
                    
                } else {
                    noaccess $nick
                    return
                }
                
                
            }
            
        } else {
        
            noaccess $nick
            return
            
        }
        
    } else {
        noaccess $nick
        return
    } 
}

# Devoice
proc pub_devoice {nick host hand chan arg} {
    
    global botnick
    
    if { [isvoice $nick $chan] == 1 || [accessint $hand $chan] >= 1 } {
        
        
        if { $arg == $botnick } {
            
            notice $nick "You can't devoice $botnick."
            cmdlog $chan $nick $hand "Tried to devoice $botnick"
            return
            
        }
        if { $arg == $nick } {
            
            putquick "MODE $chan -v $nick"
            return
        }   
        if { $arg == "" } {
            
            putquick "MODE $chan -v $nick"
            return
        } 
        
        if { [nick2hand $arg $chan] == ""} { notice $nick "User $arg does not exist." ; return }
        if { [nick2hand $arg $chan] == "*" } {
            
            putquick "MODE $chan -v $arg"
            return
        }
        if { [nick2hand $arg $chan] != "*" && [nick2hand $arg $chan] != "" } {
            
            set user [nick2hand $arg $chan]
            
            if { [accessint $hand $chan] >= [accessint $user $chan] } {
                
                putquick "MODE $chan -v $arg"
            
            } else { notice $nick "You do not have enough permissions to devoice $arg" ; return }
            
            
            
        }
    
    }
    
    
}


#########################################
### Owner, AOP, SOP, HOP, VOP add/del ###
#########################################

### Owner ###
proc pub_owner {nick host hand chan arg} {
    
    global prefix
    
    set cmd [lindex [split $arg] 0]
    set user [join [lrange [split $arg] 1 end]]
    
    set accessname "Owner"
    set cmdname "owner"
    set minaccess 5
    set uaccess 5
    set flag "N"
    
    if { $cmd == "add" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A]} {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added user '$uhand' to ${chan}'s $accessname list."
                    
                    } else {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                        putquick "MODE $chan +o $user"
                    }

                
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                
                    set_list $uhand "+$flag" $chan
                    putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                    putquick "MODE $chan +o $user"
                }
            
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
        
        
    } elseif { $cmd == "del" || $cmd == "rem" || $cmd == "delete" || $cmd == "remove" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A] } {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :User '$uhand' is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed user '$uhand' out of ${chan}'s $accessname list."
                    
                    } else {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                        putquick "MODE $chan -o $user"
                    }

                    
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                    
                    if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                    
                    set_list $uhand "-$flag" $chan
                    putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                    putquick "MODE $chan -o $user"
                    
                    
                    
                }
                
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
    } elseif { $cmd == "list" } {
        
        set userlist [userlist |$flag $chan]
        
        if { $userlist == "" } { notice $nick "There are no users on my $accessname list for $chan." ; return }
        
        notice $nick "\002$accessname list for ${chan}:\002"
        notice $nick $userlist
    } else {
        notice $nick "\002Possible arguments:\002"
        notice $nick "  ${prefix}${cmdname} add <user>          Adds the given user to the $accessname list."
        notice $nick "  ${prefix}${cmdname} del <user>          Removes the given user from the $accessname list."
        notice $nick "  ${prefix}${cmdname} list                Shows all users with accesslevel $uaccess."
    }
}


### SOP ###

proc pub_sop {nick host hand chan arg} {
    
    global prefix
    
    set cmd [lindex [split $arg] 0]
    set user [join [lrange [split $arg] 1 end]]
    
    set accessname "SOP"
    set cmdname "sop"
    set minaccess 5
    set uaccess 4
    set flag "S"
    
    if { $cmd == "add" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A]} {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added user '$uhand' to ${chan}'s $accessname list."
                    
                    } else {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                        putquick "MODE $chan +o $user"
                    }

                
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                
                    set_list $uhand "+$flag" $chan
                    putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                    putquick "MODE $chan +o $user"
                }
            
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
        
        
    } elseif { $cmd == "del" || $cmd == "rem" || $cmd == "delete" || $cmd == "remove" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A] } {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :User '$uhand' is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed user '$uhand' out of ${chan}'s $accessname list."
                    
                    } else {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                        putquick "MODE $chan -o $user"
                    }

                    
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                    
                    if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                    
                    set_list $uhand "-$flag" $chan
                    putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                    putquick "MODE $chan -o $user"
                    
                    
                    
                }
                
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
    } elseif { $cmd == "list" } {
        
        set userlist [userlist |$flag $chan]
        
        if { $userlist == "" } { notice $nick "There are no users on my $accessname list for $chan." ; return }
        
        notice $nick "\002$accessname list for ${chan}:\002"
        notice $nick $userlist
    } else {
        notice $nick "\002Possible arguments:\002"
        notice $nick "  ${prefix}${cmdname} add <user>          Adds the given user to the $accessname list."
        notice $nick "  ${prefix}${cmdname} del <user>          Removes the given user from the $accessname list."
        notice $nick "  ${prefix}${cmdname} list                Shows all users with accesslevel $uaccess."
    }
}


### AOP ###

proc pub_aop {nick host hand chan arg} {
    
    global prefix
    
    set cmd [lindex [split $arg] 0]
    set user [join [lrange [split $arg] 1 end]]
    
    set accessname "AOP"
    set cmdname "aop"
    set minaccess 5
    set uaccess 3
    set flag "O"
    
    if { $cmd == "add" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A]} {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added user '$uhand' to ${chan}'s $accessname list."
                    
                    } else {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                        putquick "MODE $chan +o $user"
                    }

                
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                
                    set_list $uhand "+$flag" $chan
                    putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                    putquick "MODE $chan +o $user"
                }
            
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
        
        
    } elseif { $cmd == "del" || $cmd == "rem" || $cmd == "delete" || $cmd == "remove" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A] } {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :User '$uhand' is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed user '$uhand' out of ${chan}'s $accessname list."
                    
                    } else {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                        putquick "MODE $chan -o $user"
                    }

                    
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                    
                    if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                    
                    set_list $uhand "-$flag" $chan
                    putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                    putquick "MODE $chan -o $user"
                    
                    
                    
                }
                
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
    } elseif { $cmd == "list" } {
        
        set userlist [userlist |$flag $chan]
        
        if { $userlist == "" } { notice $nick "There are no users on my $accessname list for $chan." ; return }
        
        notice $nick "\002$accessname list for ${chan}:\002"
        notice $nick $userlist
    } else {
        notice $nick "\002Possible arguments:\002"
        notice $nick "  ${prefix}${cmdname} add <user>          Adds the given user to the $accessname list."
        notice $nick "  ${prefix}${cmdname} del <user>          Removes the given user from the $accessname list."
        notice $nick "  ${prefix}${cmdname} list                Shows all users with accesslevel $uaccess."
    }
}


### HOP ###

proc pub_hop {nick host hand chan arg} {
    
    global prefix
    
    set cmd [lindex [split $arg] 0]
    set user [join [lrange [split $arg] 1 end]]
    
    set accessname "HOP"
    set cmdname "hop"
    set minaccess 4
    set uaccess 2
    set flag "H"
    
    if { $cmd == "add" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A]} {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added user '$uhand' to ${chan}'s $accessname list."
                    
                    } else {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                        putquick "MODE $chan +o $user"
                    }

                
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                
                    set_list $uhand "+$flag" $chan
                    putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                    putquick "MODE $chan +o $user"
                }
            
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
        
        
    } elseif { $cmd == "del" || $cmd == "rem" || $cmd == "delete" || $cmd == "remove" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A] } {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :User '$uhand' is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed user '$uhand' out of ${chan}'s $accessname list."
                    
                    } else {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                        putquick "MODE $chan -o $user"
                    }

                    
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                    
                    if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                    
                    set_list $uhand "-$flag" $chan
                    putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                    putquick "MODE $chan -o $user"
                    
                    
                    
                }
                
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
    } elseif { $cmd == "list" } {
        
        set userlist [userlist |$flag $chan]
        
        if { $userlist == "" } { notice $nick "There are no users on my $accessname list for $chan." ; return }
        
        notice $nick "\002$accessname list for ${chan}:\002"
        notice $nick $userlist
    } else {
        notice $nick "\002Possible arguments:\002"
        notice $nick "  ${prefix}${cmdname} add <user>          Adds the given user to the $accessname list."
        notice $nick "  ${prefix}${cmdname} del <user>          Removes the given user from the $accessname list."
        notice $nick "  ${prefix}${cmdname} list                Shows all users with accesslevel $uaccess."
    }
}


### VOP ###

proc pub_vop {nick host hand chan arg} {
    
    global prefix
    
    set cmd [lindex [split $arg] 0]
    set user [join [lrange [split $arg] 1 end]]
    
    set accessname "VOP"
    set cmdname "vop"
    set minaccess 3
    set uaccess 1
    set flag "V"
    
    if { $cmd == "add" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A]} {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added user '$uhand' to ${chan}'s $accessname list."
                    
                    } else {
                        
                        set_list $uhand "+$flag" $chan
                        putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                        putquick "MODE $chan +v $user"
                    }

                
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                
                    set_list $uhand "+$flag" $chan
                    putquick "PRIVMSG $chan :Added '$user' ($uhand) to ${chan}'s $accessname list."
                    putquick "MODE $chan +v $user"
                }
            
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
        
        
    } elseif { $cmd == "del" || $cmd == "rem" || $cmd == "delete" || $cmd == "remove" } {
    
        if { $hand != "*" } {
            
            if { [accessint $hand $chan] >= $minaccess || [matchattr $hand A] } {
                
                if { $user == "" } {
                    notice $nick "You must specify a user."
                    return
                }
                
                if { [validuser $user] == 1 } {
                    
                    set uhand $user
                    
                    
                    if { [hand2nick $uhand] == "" } {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :User '$uhand' is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed user '$uhand' out of ${chan}'s $accessname list."
                    
                    } else {
                        
                        if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                        
                        set_list $uhand "-$flag" $chan
                        putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                        putquick "MODE $chan -v $user"
                    }

                    
                } else {
                    
                    if { [nick2hand $user] == "" } { putquick "PRIVMSG $chan :I can not find the nick '$user'." ; return }
                    if { [nick2hand $user] == "*" } { putquick "PRIVMSG $chan :I do not have '$user' in my user database." ; return }
                    
                    set uhand [nick2hand $user]
                    
                    if { [accessint $uhand $chan] != $uaccess } { putquick "PRIVMSG $chan :'$user' ($uhand) is not in my $accessname list of '$chan'." ; return }
                    
                    set_list $uhand "-$flag" $chan
                    putquick "PRIVMSG $chan :Removed '$user' ($uhand) out of ${chan}'s $accessname list."
                    putquick "MODE $chan -v $user"
                    
                    
                    
                }
                
            } else {
                noaccess $nick
                return
            }
        } else {
            noaccess $nick
            return
        }
    } elseif { $cmd == "list" } {
        
        set userlist [userlist |$flag $chan]
        
        if { $userlist == "" } { notice $nick "There are no users on my $accessname list for $chan." ; return }
        
        notice $nick "\002$accessname list for ${chan}:\002"
        notice $nick $userlist
    } else {
        notice $nick "\002Possible arguments:\002"
        notice $nick "  ${prefix}${cmdname} add <user>          Adds the given user to the $accessname list."
        notice $nick "  ${prefix}${cmdname} del <user>          Removes the given user from the $accessname list."
        notice $nick "  ${prefix}${cmdname} list                Shows all users with accesslevel $uaccess."
    }
}


proc set_list {hand flag chan} {
    
    if {![validuser $hand] } { return 0 }
    
    if {![validchan $chan] } { return 0 }
    
   
    chattr $hand |-N $chan

    chattr $hand |-S $chan

    chattr $hand |-O $chan
    
    chattr $hand |-H $chan

    chattr $hand |-V $chan

    chattr $hand |$flag $chan
    
}




#### Access list ####

proc pub_accesslist {nick host hand chan arg} {
    
     set rawlist_owner [userlist -|N $chan]
    set rawlist_sop [userlist -|S $chan]
    set rawlist_aop [userlist -|O $chan]
    set rawlist_hop [userlist -|H $chan]
    set rawlist_vop [userlist -|V $chan]
    
    
    set i 0
    set curlist $rawlist_owner
    
    while { $i >= 0 } {

        set curhand [lindex $curlist $i]
        if { $curhand == "" } { set i -1 ; break }
       
        if { [hand2nick $curhand] != "" } { set curnick " ([hand2nick $curhand])" } else { set curnick "" }
        
        lreplace $curlist $i $i "${curhand}${curnick}, "
        
        set i [expr "$i + 1"]
    }
    
    set list_owner $curlist
    
    
    set i 0
    set curlist $rawlist_sop
    
    while { $i >= 0 } {

        set curhand [lindex $curlist $i]
        if { $curhand == "" } { set i -1 ; break }

        if { [hand2nick $curhand] != "" } { set curnick " ([hand2nick $curhand])" } else { set curnick "" }
        
        lreplace $curlist $i $i "${curhand}${curnick}, "
        
        set i [expr "$i + 1"]
    }
    
    set list_sop $curlist
    
    
    set i 0
    set curlist $rawlist_aop
    
    while { $i >= 0 } {

        set curhand [lindex $curlist $i]
        if { $curhand == "" } { set i -1 ; break }

        if { [hand2nick $curhand] != "" } { set curnick " ([hand2nick $curhand])" } else { set curnick "" }
        
        lreplace $curlist $i $i "${curhand}${curnick}, "
        
        set i [expr "$i + 1"]
    }
    
    set list_aop $curlist
    
    
    set i 0
    set curlist $rawlist_hop
    
    while { $i >= 0 } {

        set curhand [lindex $curlist $i]
        if { $curhand == "" } { set i -1 ; break }

        if { [hand2nick $curhand] != "" } { set curnick " ([hand2nick $curhand])" } else { set curnick "" }
        
        lreplace $curlist $i $i "${curhand}${curnick}, "
        
        set i [expr "$i + 1"]
    }
    
    set list_hop $curlist
    
    
    set i 0
    set curlist $rawlist_vop
    
    while { $i >= 0 } {

        set curhand [lindex $curlist $i]
        if { $curhand == "" } { set i -1 ; break }

        if { [hand2nick $curhand] != "" } { set curnick " ([hand2nick $curhand])" } else { set curnick "" }
        
        lreplace $curlist $i $i "${curhand}${curnick}, "
        
        set i [expr "$i + 1"]
    }
    
    set list_vop $curlist
    
    if { $list_owner == "" } { set $list_owner "\00314None." }
    if { $list_sop == "" } { set $list_sop "\00314None." }
    if { $list_aop == "" } { set $list_aop "\00314None." }
    if { $list_hop == "" } { set $list_hop "\00314None." }
    if { $list_vop == "" } { set $list_vop "\00314None." }


    notice $nick "\002${chan}'s access list:\002"
    notice $nick "\002Owners:\002 $list_owner"
    notice $nick "\002SOP:   \002 $list_sop"
    notice $nick "\002AOP:   \002 $list_aop"
    notice $nick "\002HOP:   \002 $list_hop"
    notice $nick "\002VOP:   \002 $list_vop"
    
    
}

#################
### Kick/Bans ###
#################

proc pub_kick {nick host hand chan arg} {
    
    global botnick
    
    if { [accessint $hand $chan] >= 2 || [isop $nick $chan] } {

        set arg1 [lindex [split $arg] 0]
        set arg2 [join [lrange [split $arg] 1 end]]
        
        if { $arg1 == "" } { notice $nick "You have to specify a user to kick." ; return }
        if { $arg1 == $botnick } { notice $nick "You're not allowed to kick Caro." ; return }
        
        if { [onchan $arg1 $chan] == 0} { notice $nick "'$arg' is not on this channel." ; return }
        
        if { [accessint [nick2hand $arg1 $chan] $chan] > [accessint $hand $chan] } { notice $nick "You can not kick '$arg1', he/she has a higher access level." ; return }

        if { $arg2 == "" } {
            putkick $chan $arg1 "(Caro) Kicked by $nick"
            return
        } else {
            putkick $chan $arg1 "(Caro) Kicked by $nick, reason: $arg2"
            return
        }
        


    } else {
        noaccess $nick
        return
    }
}


# Ban
proc pub_banfor {nick host hand chan arg} {
    
    global botnick
    
    # arg1: Nick/Host, arg2: time, arg3: Comment 
    
    if { [accessint $hand $chan] >= 3} {
        if { $arg == $botnick } { notice $nick "You're not allowed to ban Caro." ; return }
        
        # quick example (counts begins with 0)
        set arg1 [lindex [split $arg] 0]
        set arg2 [lindex [split $arg] 1]
        set arg3 [join [lrange [split $arg] 2 end]]
        
        if { $arg1 == "" } { notice $nick "You have to specify a user/host to ban." ; return }
        
        if { [string match "*!*@*" $arg1] == 1 } {
            set ban $arg1
        } else {
            if { ![onchan $arg1] } { notice $nick "I can not find '$arg1'." ; return }
            
            set ban [maskhost [getchanhost $arg1 $chan] 3]
        }
        
        if { [finduser $ban] != "*" && [accessint [finduser $ban] $chan] > [accessint $hand $chan] } { notice $nick "Your access level isn't high enough to ban $uhost." ; return }
        
        if { $arg2 == 0 } { 
            set time 0 
            if { $arg3 == "" } { set comment "(Caro) Permanently banned by $nick (matching ${ban})." } else { set comment "(Caro) Permanently banned by $nick (matching ${ban}), reason: $arg3" }
        } else { 
        
            if { $arg2 < 0 } { notice $nick "Please enter a positiv value." ; return }
            set time $arg2
            if { $arg3 == "" } { set comment "(Caro) Banned for $time minutes by $nick (matching ${ban})." } else { set comment "(Caro) Banned for $time minutes by $nick (matching ${ban}), reason: $arg3" }
        }
        
        
        newchanban $chan $ban $hand $comment $time
        
        if { $time == 0 } {
            putquick "PRIVMSG $chan :I banned $ban permanently."
        }
        if { $time > 0 } {
            putquick "PRIVMSG $chan :I banned $ban for $time minutes."
        }
        
    } else {
        noaccess $nick
        return
    }
    
    
}

proc pub_clearbans {nick host hand chan arg} {
    
    if { [accessint $hand $chan] == 5 } {
    
        foreach ban [banlist $chan] {
        
            killchanban $chan [lindex $ban 0]
        
        }
        
        foreach ban [chanbans $chan] {
            
            putquick "MODE $chan -b [lindex $ban 0]"
        
        }
        
        putquick "PRIVMSG $chan :All bans cleared."
    
    } else {
        noaccess $nick
        return
    }
    
    
}

# Ban
proc pub_ban {nick host hand chan arg} {
    
    global botnick
    
    # arg1: Nick/Host, arg2: time, arg3: Comment 
    
    if { [accessint $hand $chan] >= 3} {
        if { $arg == $botnick } { notice $nick "You're not allowed to ban Caro." ; return }
        
        # quick example (counts begins with 0)
        set arg1 [lindex [split $arg] 0]
        set arg2 [join [lrange [split $arg] 1 end]]
        
        if { $arg1 == "" } { notice $nick "You have to specify a user/host to ban." ; return }
        
        if { [string match "*!*@*" $arg1] == 1 } {
            set ban $arg1
        } else {
            if { ![onchan $arg1] } { notice $nick "I can not find '$arg1'." ; return }
            
            set ban [maskhost [getchanhost $arg1 $chan] 3]
        }
        
        if { [finduser $ban] != "*" && [accessint [finduser $ban] $chan] > [accessint $hand $chan] } { notice $nick "Your access level isn't high enough to ban $uhost." ; return }
        
        if { $arg2 == "" } { set comment "(Caro) Permanently banned by $nick (matching ${ban})." } else { set comment "(Caro) Permanently banned by $nick (matching ${ban}), reason: $arg2" }
        
        newchanban $chan $ban $hand $comment 0
        
        putquick "PRIVMSG $chan :I banned $ban permanently."


        
    } else {
        noaccess $nick
        return
    }
    
    
}


# Unban
proc pub_unban {nick host hand chan arg} {
    
    if { [accessint $hand $chan] >= 3 } {
        
        if { [string match "*!*@*" $arg] == 1 } {
            set ban $arg
        } else {
            if { ![onchan $arg] } { notice $nick "I can not find '$arg'." ; return }
            
            set ban [maskhost [getchanhost $arg] 3]
        } 
        
        if { ![matchban $ban $chan] } { putquick "PRIVMSG $chan :'$arg' is not banned in ${chan}." ; return }
        
        killchanban $chan $ban
        
        putquick "PRIVMSG $chan :I removed the ban of '$ban'."
        
        
    } else {
        noaccess $nick
        return
    }
}


## Blacklist
proc pub_blacklist {nick host hand chan arg} {
    
    global botnick
    
    # arg1: Nick/Host, arg2: time, arg3: Comment 
    
    if { [matchattr $hand A] } {
        if { $arg == $botnick } { notice $nick "You're not allowed to blacklist Caro." ; return }
        
        # quick example (counts begins with 0)
        set arg1 [lindex [split $arg] 0]
        set arg2 [lindex [split $arg] 1]
        set arg3 [join [lrange [split $arg] 2 end]]
        
        if { $arg1 == "" } { notice $nick "You have to specify a user/host to blacklist." ; return }
        
        if { [string match "*!*@*" $arg1] == 1 } {
            set ban $arg1
        } else {
            if { ![onchan $arg1] } { notice $nick "I can not find '$arg1'." ; return }
            
            set ban [maskhost [getchanhost $arg1 $chan] 3]
        }
        
        if { [finduser $ban] != "*" && [accessint [finduser $ban] $chan] > [accessint $hand $chan] } { notice $nick "Your access level isn't high enough to blacklist $uhost." ; return }
        
        if { $arg2 == "" } { 
            set time 0 
            if { $arg3 == "" } { set comment "(Caro) Permanently added you to global blacklist by $nick." } else { set comment $arg3 }
        } else { 
        
            if { $arg2 < 0 } { notice $nick "Please enter a positiv value." ; return }
            set time $arg2
            if { $arg3 == "" } { set comment "(Caro) Blacklisted by $nick for $time minute(s)." } else { set comment $arg3 }
        }
        
        
        newban $ban $hand $comment $time
        
        if { $time == 0 } {
            putquick "PRIVMSG $chan :I blacklisted $ban permanently."
        }
        if { $time > 0 } {
            putquick "PRIVMSG $chan :I blacklisted $ban for $time minutes."
        }
        
    } else {
        noaccess $nick
        return
    }
    
    
}

# Unblacklist
proc pub_unblacklist {nick host hand chan arg} {
    
    if { [matchattr $hand A] } {
        
        if { [string match "*!*@*" $arg] == 1 } {
            set ban $arg
        } else {
            if { ![onchan $arg] } { notice $nick "I can not find '$arg'." ; return }
            
            set ban [maskhost [getchanhost $arg] 3]
        } 
        
        if { ![matchban $ban] } { putquick "PRIVMSG $chan :'$arg' is not blacklisted." ; return }
        
        killban $ban
        
        putquick "PRIVMSG $chan :I removed '$ban' from the blacklist."
        
        
    } else {
        noaccess $nick
        return
    }
}

proc pub_warn {nick host hand chan arg} {

    if { [accessint $hand $chan] >= 2 || [isop $nick $chan] } {
	
		if {[validuser [nick2hand $arg]]} {
			set uhand [nick2hand $arg]
		} elseif {[onchan $arg $chan]} {
			set uhost [maskhost [getchanhost $arg $chan] 1]
			adduser $arg $uhost
			set uhand [string range $arg 0 8]
		} else {
			notice $nick "I can not find $arg."
		}
       
        set warnings [getuser $uhand XTRA WARN-$chan]
		
		if { $warnings == "" } { set warnings 0 }
		
		if {[accessint $uhand $chan] > [accessint $hand $chan] } { notice $nick "Your access level isn't high enough to warn $arg." ; return }
		
		if { $warnings < 0 || $warnings > 3 } { cmdlog $chan $nick $hand "Warnings number error! ($arg in ${chan})." }
		
		switch -glob -- $warnings {
			
			0 {
				putquick "PRIVMSG $chan :${arg}: First warning of three. Do not brake the rules again!"
				putkick $chan $arg "(Caro) 1. of 3 Warnings by $nick ($hand)."
				
				setuser $uhand XTRA WARN-$chan 1
				
			}
			1 {
				putquick "PRIVMSG $chan :${arg}: Second warning of three. Do not brake the rules again!"
				putkick $chan $arg "(Caro) 2. of 3 Warnings by $nick ($hand)."
				
				setuser $uhand XTRA WARN-$chan 2
				
			}
			2 {
				putquick "PRIVMSG $chan :${arg}: Third warning of three. This is the last warning! Do not brake the rules again!"
				putkick $chan $arg "(Caro) Last of 3 Warnings by $nick ($hand). \002This is the last warning!\002"
				
				setuser $uhand XTRA WARN-$chan 3
				
			}
			3 {
				putquick "PRIVMSG $chan :${arg}: I warned you, banned you permanently"
				newchanban $chan [maskhost [getchanhost $arg $chan] 3] $nick "Banned after 3 warnings." 0				
				setuser $uhand XTRA WARN-$chan 0
			}
			
		}
		
    } else {
        noaccess $nick
        return
    }
}


proc pub_addexempt { nick host hand chan arg } {

	if { [accessint $hand $chan] >= 2 } {
		
		if { $arg == "" } { notice $nick "You have to specify a nick/hostmask to add an exempt for." ; return }
		
		if { [string match "*!*@*" $arg] == 1 } {
			set exempt $arg
        } else {
            if { ![onchan $arg] } { notice $nick "I can not find '$arg'." ; return }
            set exempt [maskhost [getchanhost $arg] 3]
        }
		
		newchanexempt $chan $exempt $hand "(Caro)" 0
		
		putquick "PRIVMSG $chan :Added a ban exempt for ${arg}."
	}
}

proc pub_delexempt { nick host hand chan arg } {

	if { [accessint $hand $chan] >= 2 } {
		
		if { $arg == "" } { notice $nick "You have to specify a nick/hostmask to delete the exempt for." ; return }
		
		if { [string match "*!*@*" $arg] == 1 } {
			set exempt $arg
        } else {
            if { ![onchan $arg] } { notice $nick "I can not find '$arg'." ; return }
            set exempt [maskhost [getchanhost $arg] 3]
        }
		
		if { ![matchban $exempt $chan] } { putquick "PRIVMSG $chan :There is no exempt for '$arg' in ${chan}." ; return }
		
		killchanexempt $chan $exempt
		
		putquick "PRIVMSG $chan :Deleted the exempt for ${arg}."
	}
}

# Check and refresh bans
proc pub_checkbans {nick host hand chan arg} {
    
    if { [accessint $hand $chan] >= 2 } {
        
        resetbans $chan
        putquick "PRIVMSG $chan :Synchronisizing channel bans with my ban list ..."
        
        
        
    } else {
        noaccess $nick
        return
    }
}



########################
##### Topic/Invite #####
########################

proc pub_topic {nick host hand chan arg} {
    
    if { [accessint $hand $chan] >= 2 || [isop $nick $chan] } {
        
        if {$arg == "" } { notice $nick "You must specify a topic to set." ; return }
        
        putquick "TOPIC $chan :$arg"
        
    } else {
        noaccess $nick
        return
    }
}


proc pub_tappend {nick host hand chan arg } {
    
    if { [accessint $hand $chan] >= 2 || [isop $nick $chan] } {
        
        if {$arg == "" } { notice $nick "You must specify a text to append to the topic." ; return }
        
        set newtopic "[topic $chan] | $arg"
        
        putquick "TOPIC $chan :$newtopic"       
        
    } else {
        noaccess $nick
        return
    }
}

proc pub_invite {nick host hand chan arg} {
    
    
    if {[accessint $hand $chan] >= 1 || [isvoice $nick $chan] || [isop $nick $chan] } {
        
        if { $arg == "" } { notice $nick "You must specify a user to invite." ; return }
        
        putquick "INVITE $arg $chan"
        newchaninvite $chan $arg $nick "(Caro) Invited by $nick." 60
        
        putquick "PTIVMSG $chan :I invited $arg to $chan. The invite expires in 60 minutes."
    
    } else {
        noaccess $nick
        return
    }
}


##################
### Misc funcs ###
##################

# Up
proc pub_up {nick host hand chan arg} {
    
    if { $hand != "*" } {
        
        if { $arg == "" } {
            
            if { [accessint $hand $chan] == 1 && ![isvoice $nick $chan]} {
                putquick "MODE $chan +v $nick"
                return
            }
            if { [accessint $hand $chan] >= 2 && ![isop $nick $chan] } {
                putquick "MODE $chan +o $nick"
                return
            }
        } else {
            
            if { [nick2hand $arg $chan] != "*" || [nick2hand $arg $chan] != "" } {
                
                set uhand [nick2hand $arg]
                
                if { [accessint $uhand $chan] == 1 && ![isvoice $arg $chan]} {
                    putquick "MODE $chan +v $arg"
                    return
                }   
                if { [accessint $uhand $chan] >= 2 && ![isop $arg $chan]} {
                    putquick "MODE $chan +o $arg"
                    return
                }
                
            }
        }  
    }
}

# Down
proc pub_down {nick host hand chan arg} {
    
    if { $arg == "" } {
        
        if { [isop $nick $chan] == 1 } {
            putquick "MODE $chan -o $nick"
            return
        }
        if { [isvoice $nick $chan] == 1 } {
            putquick "MODE $chan -v $nick"
            return
        }
    } else {
        if { [isop $arg $chan] == 1 } {
            putquick "MODE $chan -o $arg"
            return
        }
        if { [isvoice $arg $chan] == 1 } {
            putquick "MODE $chan -v $arg"
            return
        }
    }
}

# Add Channels
proc pub_addchan {nick host hand chan arg} {
    
    if { [matchattr $hand A] == 1 || [matchattr $hand H] == 1 } {

        set arg1 [lindex $arg 0]
        set arg2 [lindex $arg 1]

        if { $arg1 == "" } { notice $nick "You have to specify a channel to add." ; return }
        if { [validchan $arg1] && [channel get $arg1 inactive] } { putquick "PRIVMSG $chan :I am already on '$arg', but it is suspended." ; return }
        if { [validchan $arg1] && ![channel get $arg1 inactive] } { putquick "PRIVMSG $chan :I am already on '$arg'." ; return }

        if { $arg2 == "" } { notice $nick "You have to specify a user to be owner of the new channel." ; return }
        if { ![validuser $arg2] } { putquick "PRIVMSG $chan :'$arg2' is not in my user database." ; return }

        channel add $arg1
        chattr $arg2 |+N $arg1
        
        putquick "PRIVMSG $chan :I have joined '$arg1' and added it to my channel database. Owner of ${arg1}: $arg2"
        cmdlog $chan $nick $hand "channel add '$arg1' (Owner: $arg2)"
        if { $Oper == 1 } {
            utimer 5 [list oper_op $chan]
        }
        
    } else {
        noaccess $nick
        return
    }
}

proc oper_op {chan} {
    
    global botnick
    
    if { ![botisop $chan] } {
     
        putquick "PRIVMSG OperServ :MODE $chan +o botnick"
        
    }
    
}

# Join Channel
proc pub_joinchan {nick host hand chan arg} {
    
    if { [matchattr $hand A] == 1 || [matchattr $hand H] == 1 } {

        set arg1 [lindex $arg 0]

        if { $arg == "" } { notice $nick "You have to specify a channel to add." ; return }
        if { [validchan $arg] && [channel get $arg1 inactive] } { putquick "PRIVMSG $chan :I am already on '$arg', but it is suspended." ; return }
        if { [validchan $arg] && ![channel get $arg1 inactive] } { putquick "PRIVMSG $chan :I am already on '$arg'." ; return }

        channel add $arg
        
        putquick "PRIVMSG $chan :I have joined '$arg' and added it to my channel database."
        cmdlog $chan $nick $hand "channel join '$arg'"

        
    } else {
        noaccess $nick
        return
    }
}

# Rem Channels
proc pub_remchan {nick host hand chan arg} {
    
    if { [matchattr $hand A] == 1 || [matchattr $hand H] == 1 } {
    
        set arg1 [lindex [split $arg] 0]
        set arg2 [join [lrange [split $arg] 1 end]]
        
        if { $arg1 == "" } { notice $nick "You have to specify a channel to remove." ; return }
        if { [validchan $arg1] == 0 } { putquick "PRIVMSG $chan :I am not on $arg1." ; return }

        
        if { $arg2 != "" && $chan != $arg1} {
            putquick "PRIVMSG $arg1 :This channel (${arg1}) has been removed by $nick ($hand), reason: $arg2"
        } elseif { $chan != $arg1 } {
            putquick "PRIVMSG $arg1 :This channel (${arg1}) has been removed by $nick ($hand)."
        }
        
        utimer 2 [list channel remove $arg1]
        
        putquick "PRIVMSG $chan :I have left $arg1 and deleted it out of my channel database."
        cmdlog $chan $nick $hand "channel rem $arg1, reason: $arg2"

        
    } else {
        noaccess $nick
        return
    }
}


# Suspend channel
proc pub_suspend {nick host hand chan arg} {
    
    if { [matchattr $hand H] || [matchattr $hand A] } {
        
        set arg1 [lindex [split $arg] 0]
        set arg2 [join [lrange [split $arg] 1 end]]
        
        if { $arg1 == "" } { notice $nick "You have to specify a channel to suspend." ; return }
        
        if { ![validchan $arg1] } { putquick "PRIVMSG $chan :I am not on $arg." ; return }
        
        if { [channel get $chan inactive] } { putquick "PRIVMSG $chan :$arg1 is already suspended." ; return }
        
        if { $arg2 != "" && $chan != $arg1 } {
            putquick "PRIVMSG $arg1 :This channel (${arg1}) has been suspended by $nick ($hand), reason: $arg2"
        } elseif { $chan != $arg1 } {
            putquick "PRIVMSG $arg1 :This channel (${arg1}) has been suspended by $nick ($hand)."
        }
        
        putquick "PRIVMSG $chan :I have suspended $arg1 and parted."
        utimer 2 [list channel set $arg1 +inactive]
        cmdlog $chan $nick $hand "channel suspend $arg1, reason: $arg2"
        
        
        
        
    } else {
        noaccess $nick
        return
    }
}

# Unsuspend channel
proc pub_unsuspend {nick host hand chan arg} {
    
    if { [matchattr $hand A] == 1 || [matchattr $hand H] == 1 } {

        set args [cleanarg $arg]
        set arg1 [lindex $args 0]

        if { $arg1 == "" } { notice $nick "You have to specify a channel to unsuspend." ; return }
        if { ![validchan $arg1] } { putquick "PRIVMSG $chan :I do not have $arg1 in my channel database." ; return }
        if { ![channel get $arg1 inactive] } { putquick "PRIVMSG $chan :$arg1 is not suspended." ; return }

        channel set $arg1 -inactive
        
        putquick "PRIVMSG $chan :I have unsuspended $arg1 and joined."
        cmdlog $chan $nick $hand "channel unsuspend $arg1"

        
    } else {
        noaccess $nick
        return
    }
    
    
}


# Say
proc pub_say {nick host hand chan arg } {

    global botnick
    global settings
    global prefix
    
    if { $hand == "*" } { noaccess $nick ; return}
        
    if { [accessint $hand $chan] >= 4 || [matchattr $hand H] || [matchattr $hand A]} { 
        putquick "PRIVMSG $chan :$arg"
        return 
    } else {
        noaccess $nick
        return
    }
}

# Me
proc pub_me {nick host hand chan arg} {

    global botnick
    global settings
    global prefix
    
    if { $hand == "*" } { noaccess $nick ; return}
        
    if { [accessint $hand $chan] >= 4 || [matchattr $hand H] || [matchattr $hand A]} { 
        putquick "PRIVMSG $chan :\001ACTION $arg\001"
        return 
    } else {
        noaccess $nick
        return
    }
}

# Cycle
proc pub_cycle {nick host hand chan arg} {
    
    if {$hand == "*"} {noaccess $nick ; return }
    
    if { [accessint $hand $chan] >= 4 || [matchattr $hand H] || [matchattr $hand A]} { 
        putquick "PART $chan :Cycling"
        putquick "JOIN $chan"
        return 
    } else {
        noaccess $nick
        return
    } 
}

# GainOp - Cycle
proc part_gainop {nick host hand chan msg} {
    
    set numuser [llength [chanlist $chan]]
    
    if { $numuser == 1 } {
        
        putquick "PART $chan :Cycling"
        putquick "JOIN $chan"
        
    }
    
    
    
}


# My status
proc pub_access {nick host hand chan arg } {
    
    global botnick
    global partyline settings
    
    if { $arg == "" } {

        notice $nick "You ($hand) have the access level \002[accessint $hand $chan]\002 in $chan."
        
        
        if { [matchattr $hand A] == 1 } {
            
            notice $nick "You are a \002Administrator\002 on $botnick"
        
        }
        if { [matchattr $hand H] == 1 } {
            
            notice $nick "You are a \002Helper\002 on $botnick"
        
        }
        if { [matchattr $hand h] == 1 } {
            notice $nick "You can join ${botnick}'s partyline: $settings(partyline) (TelNet)"
        }
    } else {
        
        if { [validuser $arg] == 1 && $arg != "*"} {
            set uhand $arg
        } else {
            if { [nick2hand $arg] == "" } { notice $nick "I can not find ${arg}." ; return }
            if { [nick2hand $arg] == "*" } { notice $nick "$arg is not registered or not logged in at me." ; return }
            
            set uhand [nick2hand $arg]
        }
        
        notice $nick "$uhand has the access level \002[accessint $hand $chan]\002 in $chan."
        
        
        if { [matchattr $hand A] == 1 } {
            
            notice $nick "$uhand is a \002Administrator\002 on $botnick"
        
        }
        if { [matchattr $hand H] == 1 } {
            
            notice $nick "$uhand is a \002Helper\002 on $botnick"
        
        }
        if { [matchattr $hand h] == 1 } {
            notice $nick "$uhand can join ${botnick}'s partyline: $settings(partyline) (TelNet)"
        }
        
        
    }
}

# MSG-Voice
proc msg_voice {nick host hand arg} {
    
    if { $hand != "*" } {
        
        if { $arg == "" } { notice $nick "You have to specify a channel to get voice on." ; return }
        if { ![botonchan $arg] } { notice $nick "I'm not in $arg." ; return }
        if { ![botisop $arg] } { notice $nick "I'm not opped in $arg." ; return }
        if { [accessint $hand $arg] >= 1 } {
            
            putquick "MODE $arg +v $nick"
            notice $nick "I voiced you on $arg."
            
        } else {
            noaccess $nick
            return
        }
        
        
        
    }
    
}

# Set modes
proc pub_mode {nick host hand chan arg} {
    
    if {[isop $nick $chan] || [accessint $hand $chan] >= 2} {
        
        if {$arg == ""} {notice $nick "You need to specify modes to set/remove." ; return }
        
        putquick "MODE $chan $arg"
        
        
    } else {
        noaccess $nick
        return
    }    
}

# AutoOp/AutoVoice on Join
proc join_autoov {nick host hand chan} {
    
    if {$hand != "*"} {
        
        if { [matchattr $hand c] } { return }
        if { [channel get $chan noauto] } { return }
        
        if {[accessint $nick $chan] >= 2} {
            putquick "MODE $chan +o $nick"
            return
        }        
        if {[accessint $nick $chan] == 1} {
            putquick "MODE $chan +v $nick"
            return
        }
    }
}


proc msg_invite {nick host hand arg} {
    
    if { $arg == "" } {
        notice $nick "You need to specify a channel to get invited to."
    }
    
    if { ![botonchan $arg] } {
        notice $nick "I am not in $arg."
    }
    
    if { [accessint $hand $arg] >= 1 || [matchattr $hand A] } {
        
        newchaninvite $arg $nick!*@* $nick "Invite by PRIVMSG" 5
        putquick "INVITE $nick $arg"
        notice $nick "I invited you to $arg, you can now join it."
        
    } else {
        notice $nick "Your access level for $arg is too low for this command."
        return
    }
}

## SET ##

setudef flag nogreet
setudef flag autolimit
setudef str entrymsg
setudef flag noauto
setudef flag nosync
setudef flag nourl

proc pub_set {nick host hand chan arg} {

	global botnick
	global settings
	global prefix
	
	if { [accessint $hand $chan] == 5 } {
		
		set arg1 [lindex $arg 0]
			
			if { $arg1 == "greet"} {
			
				## GREETINGS ##
				
				set arg2 [lindex $arg 1]
				if { $arg2 == "on" } {
					if { ![channel get $chan nogreet] } { putquick "PRIVMSG $chan :Greetings are already enabled." ; return }
					channel set $chan -nogreet
					putquick "PRIVMSG $chan :Greetings are now enabled."
				} elseif { $arg2 == "off" } {
					if { [channel get $chan nogreet] } { putquick "PRIVMSG $chan :Greetings are already disabled." ; return }
					channel set $chan +nogreet
					putquick "PRIVMSG $chan :Greetings are now disabled."
				} else {
					
					notice $nick "*** \002${prefix}set greet\002 ***"
					notice $nick "  Enables or Disables the greet function on your channel."
					notice $nick ""
					notice $nick " \002Syntax:\002"
					notice $nick "   ${prefix}set greet \{ on|off \}"
					notice $nick "*** \002${prefix}set greet End\002 ***"
					
				}		
				
			} elseif { $arg1 == "autolimit"} {

				## AUTOLIMIT ##
				
				set arg2 [lindex $arg 1]
				
				if { $arg2 == "on" } {
					if { [channel get $chan autolimit] } { putquick "PRIVMSG $chan :Auto-limit function is already enabled." ; return }
					channel set $chan +autolimit
					putquick "PRIVMSG $chan :Auto-limit function is now enabled."
                    putquick "MODE $chan +l [expr [llength [chanlist $chan]] + 4]"
                    
                    
				} elseif { $arg2 == "off" } {
					if { ![channel get $chan autolimit] } { putquick "PRIVMSG $chan :Auto-limit function is already disabled." ; return }
					channel set $chan -autolimit
					putquick "PRIVMSG $chan :Auto-limit function is now disabled."
                    putquick "MODE $chan -l"
				} else {
					
					notice $nick "*** \002${prefix}set autolimit\002 ***"
					notice $nick "  Enables or Disables the auto-limit function on your channel."
					notice $nick ""
					notice $nick " \002Syntax:\002"
					notice $nick "   ${prefix}set autolimit \{ on|off \}"
					notice $nick "*** \002${prefix}set greet End\002 ***"
					
				}	
			
			} elseif { $arg1 == "entrymsg"} {

				## ENTRYMSG ##
				
				set arg2 [join [lrange [split $arg] 1 end]]
				
				if { $arg2 == "" } {
                    if { [channel get $chan entrymsg] == "" } { notice $nick "The entry message is already cleared and is disabled." ; return }
                    
                    channel set $chan entrymsg ""
                    
                    putquick "PRIVMSG $chan :Entry message cleared and disabled."
                    
				} else {
                
                    channel set $chan entrymsg $arg2
                    
                    putquick "PRIVMSG $chan :Entry message enabled and set to \"$arg2\""
					
					#notice $nick "*** \002${prefix}set entrymsg\002 ***"
					#notice $nick "  Sets the entry message every user joining your channel will get by NOTICE."
                    #notice $nick "  No argument clears the message and disables it."
					#notice $nick ""
					#notice $nick " \002Syntax:\002"
					#notice $nick "   ${prefix}set autolimit \<message\>"
					#notice $nick "*** \002${prefix}set entrymsg End\002 ***"
					
				}	
                
			
			} elseif { $arg1 == "auto"} {

				## AUTO ##
				
				set arg2 [lindex $arg 1]
				
				if { $arg2 == "on" } {
					if { ![channel get $chan noauto] } { putquick "PRIVMSG $chan :Autovoicing/-oping function is already enabled." ; return }
					channel set $chan -noauto
					putquick "PRIVMSG $chan :Autovoicing/-oping function is now enabled."
                    
                    
				} elseif { $arg2 == "off" } {
					if { [channel get $chan noauto] } { putquick "PRIVMSG $chan :Autovoicing/-oping function is already disabled." ; return }
					channel set $chan +noauto
					putquick "PRIVMSG $chan :Autovoicing/-oping function is now disabled."
				} else {
					
					notice $nick "*** \002${prefix}set auto\002 ***"
					notice $nick "  Enabled or disables voicing/oping of users in xOP lists on join."
					notice $nick ""
					notice $nick " \002Syntax:\002"
					notice $nick "   ${prefix}set auto \{ on|off \}"
					notice $nick "*** \002${prefix}set auto End\002 ***"
					
				} 
                
            } elseif { $arg1 == "url"} {

				## URL ##
				
				set arg2 [lindex $arg 1]
				
				if { $arg2 == "on" } {
					if { ![channel get $chan nourl] } { putquick "PRIVMSG $chan :URL titles are already shown." ; return }
					channel set $chan -nourl
					putquick "PRIVMSG $chan :URL titles are now shown."
                    
                    
				} elseif { $arg2 == "off" } {
					if { [channel get $chan nourl] } { putquick "PRIVMSG $chan :URL titles are not shown already." ; return }
					channel set $chan +nourl
					putquick "PRIVMSG $chan :URL titles are not longer shown."
				} else {
					
					notice $nick "*** \002${prefix}set url\002 ***"
					notice $nick "  Enabled or disables showing of URL titles if they are mentioned."
					notice $nick ""
					notice $nick " \002Syntax:\002"
					notice $nick "   ${prefix}set url \{ on|off \}"
					notice $nick "*** \002${prefix}set auto End\002 ***"
					
				} 
                
            } elseif { $arg1 == "sync"} {

				## SYNC ##
				
				set arg2 [lindex $arg 1]
				
				if { $arg2 == "on" } {
					if { ![channel get $chan nosync] } { putquick "PRIVMSG $chan :Ban, ban exempt and invite syncing is already enabled." ; return }
					channel set $chan -nosync
					putquick "PRIVMSG $chan :Ban, ban exempt and invite syncing is now enabled."
                    
                    
				} elseif { $arg2 == "off" } {
					if { [channel get $chan nosync] } { putquick "PRIVMSG $chan :Ban, ban exempt and invite syncing is already disabled." ; return }
					channel set $chan +nosync
					putquick "PRIVMSG $chan :Ban, ban exempt and invite syncing is now disabled."
				} else {
					
					notice $nick "*** \002${prefix}set sync\002 ***"
					notice $nick "  Enabled or disables ban, ban exempt and invite syncing of the channel with the bot's lists."
					notice $nick ""
					notice $nick " \002Syntax:\002"
					notice $nick "   ${prefix}set sync \{ on|off \}"
					notice $nick "*** \002${prefix}set sync End\002 ***"
                    
				} 
            } else {
                
                notice $nick "*** \002${prefix}set Help\002 ***"
                notice $nick "  \002Possible ${prefix}set variables:\002"
                notice $nick "  \<...\> = needed argument; \[...\] = optional argument; \{ no1|no2 \} = no1 or no2"
                notice $nick "      * ${prefix}set greet \{ on|off \}"
                notice $nick "      * ${prefix}set autolimit \{ on|off \}"
                notice $nick "      * ${prefix}set entrymsg \<message\>"
                notice $nick "      * ${prefix}set auto \{ on|off \}"
                notice $nick "      * ${prefix}set sync \{ on|off \}"
                notice $nick "      * ${prefix}set url \{ on|off \}"
                notice $nick "*** \002${prefix}set Help End\002 ***"
                
            }
			
		
	} else {
		noaccess $nick
		return
	}
}

## SET END ##

proc pub_enablegreet {nick host hand chan arg} {

	if {[accessint $hand $chan] == 5 } {
		
		if { ![channel get $chan nogreet] } { putquick "PRIVMSG $chan :Greetings are already enabled." ; return }
		
		channel set $chan -nogreet
		
		putquick "PRIVMSG $chan :Greetings are now enabled."
		
		
	} else {
		noaccess $nick
		return
	}
}


proc pub_disablegreet {nick host hand chan arg} {

	if {[accessint $hand $chan] == 5 } {
		
		if { [channel get $chan nogreet] } { putquick "PRIVMSG $chan :Greetings are already disabled." ; return }
		
		channel set $chan +nogreet
		
		putquick "PRIVMSG $chan :Greetings are now disabled."
		
		
	} else {
		noaccess $nick
		return
	}
}








proc noaccess {nick} {
    putquick "NOTICE $nick :You don't have access to this command."
}
# Send logs to 
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

# Notice
proc notice {who msg} {
    putquick "NOTICE $who :$msg"
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

putlog "Caro - channel.tcl loaded."