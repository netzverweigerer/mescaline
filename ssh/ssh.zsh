
_forwarding=no

function _start_agent()
{
  # start ssh-agent and setup environment
  echo "starting ssh-agent..."
  /usr/bin/env ssh-agent -t 3600 | sed 's/^echo/#echo/' > $HOME/.ssh/env
  chmod 600 $HOME/.ssh/env
  . $HOME/.ssh/env > /dev/null
  /usr/bin/ssh-add $HOME/.ssh/id_ed25519
}

sshenv="$HOME/.ssh/env"

loaded=0
if [[ -e "$sshenv" ]]; then
  echo "ssh env exists, loading env."
  . "$sshenv"
  loaded=1
fi

if [[ "$loaded" -eq 1 ]]; then

if [[ ${_forwarding} == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
  [[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen
elif [ -f "${sshenv}" ]; then
  /usr/bin/ssh-add $HOME/.ssh/id_ed25519
fi

if [[ ${_forwarding} == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
  [[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen
elif [ -f "${sshenv}" ]; then
  . ${sshenv} > /dev/null
  ps x | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
    _start_agent;
  }
else
  _start_agent;
fi

unfunction _start_agent
unset _forwarding

unset sshenv

fi

