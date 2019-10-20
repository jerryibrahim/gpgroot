
export GNUPGHOME=~/gpgtemp/gnupghome-$1
export GPGBACKUP=~/gpgtemp/gpg-backup-$1
export GNUPGHOME2=~/gpgtemp2/gnupghome-$1
export GPGBACKUP2=~/gpgtemp2/gpg-backup-$1
export GPGXFER=~/gpgtempX/k/$1
export GPGUSER=$1

mkdir ~/gpgtemp
mkdir ~/gpgtemp2
# mkdir -p ~/gpgtempX/k
echo $GPGXFER
mkdir -p $GPGXFER