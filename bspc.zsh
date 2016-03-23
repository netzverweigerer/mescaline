#compdef bspc

_bspc() {
	local -a commands settings
	commands=('window' 'desktop' 'monitor' 'query' 'pointer' 'rule' 'restore' 'control' 'config' 'quit')
	settings=('external_rules_command' 'status_prefix' 'focused_border_color' 'active_border_color' 'normal_border_color' 'presel_border_color' 'focused_locked_border_color' 'active_locked_border_color' 'normal_locked_border_color' 'focused_sticky_border_color' 'normal_sticky_border_color' 'focused_private_border_color' 'active_private_border_color' 'normal_private_border_color' 'urgent_border_color' 'border_width' 'window_gap' 'top_padding' 'right_padding' 'bottom_padding' 'left_padding' 'split_ratio' 'initial_polarity' 'borderless_monocle' 'gapless_monocle' 'focus_follows_pointer' 'pointer_follows_focus' 'pointer_follows_monitor' 'apply_floating_atom' 'auto_alternate' 'auto_cancel' 'history_aware_focus' 'focus_by_distance' 'ignore_ewmh_focus' 'center_pseudo_tiled' 'remove_disabled_monitors' 'remove_unplugged_monitors' 'merge_overlapping_monitors')
	if (( CURRENT == 2 )) ; then
		_values 'command' "$commands[@]"
	elif (( CURRENT == 3 )) ; then
		case $words[2] in
			config)
				_values 'setting' "$settings[@]"
				;;
			*)
				return 1
				;;
		esac
	else
		return 1
	fi
}

_bspc "$@"

