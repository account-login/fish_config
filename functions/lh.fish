# same as lh
function l --wraps=ls --description 'List contents of directory using long format'
    ls -lAh $argv
end
