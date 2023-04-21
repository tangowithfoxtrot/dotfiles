function bw-to-yaml
    for line in (curl -s "$BW_SERVE_URL/list/object/items" | jq '.data.data[]' | jq -r '[.name, .login.uris[0].uri, .login.username, .login.password] | join ("😀")')
        # output yaml
        set -l name (echo $line | cut -d😀 -f1)
        set -l url (echo $line | cut -d😀 -f2)
        # set -l notes (printf '%s' $line | cut -d😀 -f3)
        set -l username (echo $line | cut -d😀 -f3)
        set -l password (echo $line | cut -d😀 -f4)
        # only echo values if they exist
        if test -n "$name"
            printf '%s\n    %s\n' '- name: |-' $name
        end
        if test -n "$url"
            echo "  url: |-
    $url"
        end
        # if test -n "$notes"
        #   echo "  notes: |-
        #   $notes"
        # end
        if test -n "$username"
            echo "  username: |-
    $username"
        end
        if test -n "$password"
            echo "  password: |-
    $password"
        end
    end
end
