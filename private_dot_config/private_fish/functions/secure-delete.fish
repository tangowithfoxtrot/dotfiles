function secure-delete
dd if=/dev/urandom of="$argv" bs=10 count=1
rm -f "$argv"
end
