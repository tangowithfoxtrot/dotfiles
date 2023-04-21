function ssh-forward --description 'Usage: ssh-forward $USER $HOST $PORT'
ssh -L $argv[3]:$argv[2]:$argv[3] $argv[1]@$argv[2]
end
