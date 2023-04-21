function bw-to-env
    curl -s "$BW_SERVE_URL/list/object/items" | jq '.data.data[]' | jq -r '[.name, .login.password] | join ("=")'
end
