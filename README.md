# dotvimwin



	C:\...\Vimrc



the VIM's config file and plugins




# the path

          ~/vimfiles

# Vim "swap", "backup" and "undo" files.

## vim backup undo swap swp

These files can be put in a fixed directory to keep things more organized.

First of all, create these three folders:

	mkdir ~/.vim/.backup ~/.vim/.swp ~/.vim/.undo

Now, put these lines in your vimrc file.

	set undodir=~/.vim/.undo//

	set backupdir=~/.vim/.backup//

	set directory=~/.vim/.swp//

the "//" at the end of each directory means that file names will be built from the complete path to the file with all path separators substituted to percent "%" sign. This will ensure file name uniqueness in the preserve directory.

Alternatively you can turn them off, putting this in your vimrc file:

> set nobackup
> 
> set noswapfile

