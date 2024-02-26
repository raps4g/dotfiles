dotfiles=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

links_file=$dotfiles/links
while read line; do
    source=$dotfiles/$(echo $line | sed -nE 's/(.*)\=.*/\1/p')
    dest=$HOME/$(echo $line | sed -nE 's/.*\=(.*)/\1/p')
    dest_dir=$(dirname $dest)
    if [ -f $source ] ; then
        mkdir -pv $dest_dir
        if [[ ( -d $dest || -f $dest ) && ! -L $dest ]]; then
            mv -v $dest $dest.old
        elif [[ -L $dest && $(readlink $dest) == $source ]]; then
            continue
        fi

        ln -fsv $source $dest
    else 
        echo $source does not exist
    fi

done < <(grep -vE '^(\s*$|#)' $links_file)

