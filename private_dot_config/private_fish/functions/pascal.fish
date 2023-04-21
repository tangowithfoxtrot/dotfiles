function pascal
printf "%s\n" $argv | perl -pe 's/(^|_)./uc($&)/ge;s/_//g'
end
