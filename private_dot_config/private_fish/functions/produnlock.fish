function produnlock
export BW_SESSION=(echo $BW_PASSWORD | prod unlock --raw)
end
