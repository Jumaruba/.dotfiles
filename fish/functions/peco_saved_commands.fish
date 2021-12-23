function _peco_saved_commands 
  if [ (count $argv) ]
    peco --layout=bottom-up --query "$argv "|  read foo
  else
    peco --layout=bottom-up | read foo
  end 
  if [ $foo ]   
    commandline $foo 
  else
    commandline ''
  end
end

function peco_saved_commands
  begin 
    echo 'sudo docker rm -f (sudo docker ps -aq)'
    echo 'sudo docker image rm -f (sudo docker image ls -a)'  
    echo 'nvim $HOME/.config/fish/functions/peco_saved_commands.fish'
  end | _peco_saved_commands $argv
end
