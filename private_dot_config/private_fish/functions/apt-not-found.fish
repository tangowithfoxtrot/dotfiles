function apt-not-found
curl -s "https://command-not-found.com/$argv" | grep apt-get | head -1 | sed 's/<code>apt-get install //g' | sed 's/<\/code>//g'
end
