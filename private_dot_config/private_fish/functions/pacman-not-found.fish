function pacman-not-found
curl -s "https://command-not-found.com/$argv" | grep pacman | head -1 | sed 's/<code>pacman -S //g' | sed 's/<\/code>//g'
end
