function gitc --description='git commit -am'
    git commit -am (string join " " -- $argv)
end
