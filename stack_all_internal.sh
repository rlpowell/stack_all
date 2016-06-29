#!/bin/bash

. ~/.bothrc

set -x

sudo chown -R rlpowell:rlpowell /home/rlpowell/
rm ~/.local/bin/stack

cd /home/rlpowell/stack/
cp stack.cabal stack.cabal.orig
stack setup

# Get some basics
stack -j 4 build --haddock --copy-bins hsc2hs hscolour
rm ~/.local/bin/stack

# Get stuff we *know* we want
cat stack.cabal.orig | sed "s/PACKAGES/hakyll, pcre-heavy, unix, base/" >stack.cabal
stack -j 4 build --haddock --copy-bins
rm -f ~/.local/bin/stack

# Set up hoogle; this is a bit weird because the only directories we
# have as Docker volumes are /home/rlpowell/.stack/ and
# /home/rlpowell/.local/
#
# Following the instructions at http://stackoverflow.com/questions/34637832/manage-hoogle-index-using-stack-tool
mkdir -p /home/rlpowell/.local/src/
cd /home/rlpowell/.local/src/
if [ -d /home/rlpowell/.local/src/hoogle/ ]
then
  cd /home/rlpowell/.local/src/hoogle/
  git checkout master
  git pull
else
  git clone https://github.com/ndmitchell/hoogle.git
  cd hoogle
  git checkout master
fi
# git checkout tags/v5.0  # Might as well get a vaguely consistent version, although not really as it's under dev as of Jun 2016

# Install hoogle from master
stack --resolver=lts-6.4 init
stack --resolver=lts-6.4 install --haddock

# Here we make a hoogle script that will work without having to
# specify the database option all the time
mv /home/rlpowell/.local/bin/hoogle /home/rlpowell/.local/bin/hoogle-orig
echo '#!/bin/bash

/home/rlpowell/.local/bin/hoogle-orig "$@" --database=/home/rlpowell/.local/share/hoogledb
' > /home/rlpowell/.local/bin/hoogle
chmod 755 /home/rlpowell/.local/bin/hoogle
# So now things like:
#
# $ hoogle tail
#
# should just work, at least once the generation is done below
cd /home/rlpowell/stack/

# Get everything else
EXCLUDE_NOT_WINDOWS='Win32.*'
EXCLUDE_NOT_MACOS='hfsevents.*'
EXCLUDE_BROKEN='shell-conduit|inline-r|H|ihaskell-inline-r'
EXCLUDE_ALWAYS_RECOMPILES='gi-[a-z]+'
sed -n '/^packages:$/,/^[a-z]/p' /home/rlpowell/.stack/build-plan/lts-6.4.yaml | grep '^  \S' | \
  sed -e 's/^\s*//' -e 's/:\s*$/, /' | \
  grep -Pv '^('"$EXCLUDE_NOT_WINDOWS|$EXCLUDE_NOT_MACOS|$EXCLUDE_BROKEN|$EXCLUDE_ALWAYS_RECOMPILES"')\s*,\s*$' | \
  tr -d '\n' | sed 's/,\s*$//' >allpacks
set +x
cat stack.cabal.orig | sed "s/PACKAGES/$(cat allpacks)/" >stack.cabal
set -x
stack -j 4 build --haddock --copy-bins
rm ~/.local/bin/stack

# Now that we have all the docs, generate a hoogle database from them
# Again from http://stackoverflow.com/questions/34637832/manage-hoogle-index-using-stack-tool
cd /home/rlpowell/.local/src/hoogle/
# generate the Hoogle index
stack exec -- hoogle generate --local --database=/home/rlpowell/.local/share/hoogledb
cd /home/rlpowell/stack/

zsh
