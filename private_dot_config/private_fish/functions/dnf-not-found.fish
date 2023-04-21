function dnf-not-found
curl -s "https://command-not-found.com/$argv" | grep dnf | head -1 | sed 's/<code>dnf install //g' | sed 's/<\/code>//g'
end
