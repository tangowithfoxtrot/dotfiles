function glowread --description 'Read markdown file from GitHub link'
set arg2 (echo -n 'https://github.com'(curl -H "Accept: application/vnd.github.v3.raw" $argv 2> /dev/null | grep -i raw-url | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d')) && curl -L $arg2 > /tmp/tmp.md && glow -p /tmp/tmp.md
end
