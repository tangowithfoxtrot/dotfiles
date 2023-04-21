function githubraw --description 'Grab GitHub raw link'
set arg2 (echo -n 'https://github.com'(curl -H "Accept: application/vnd.github.v3.raw" $argv 2> /dev/null | grep -i raw-url | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d')) && curl -L $arg2 2> /dev/null
end
