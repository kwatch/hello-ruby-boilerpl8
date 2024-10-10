
export GEM_HOME=$PWD/gem
#export GEM_HOME=$HOME/gem
#export GEM_HOME=/var/tmp/gem
export PATH=$GEM_HOME/bin:${_path:=$PATH}
export RUBYLIB=$PWD/lib:${_rubylib:=$RUBYLIB}

alias t="rake test"
alias ta="rake test:all"
