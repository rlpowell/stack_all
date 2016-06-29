Simple scripts to set up a Docker volume with a complete stack
checkout in it.  Currently uses lts-6.4

I wrote this for myself; I'm releasing it in case it's helpful, but
I'm not maintaning it for public use, so, like, everything is
under /home/rlpowell , and I assume that you've got some of the
basics installed (shell, ssh, etc) and it's Fedora 24, which may not
be your thing ; sorry.

You want to run volume_setup.sh *exactly once* to setup the docker
volume that everything will be stored in.

The volume has /home/rlpowell/.local/ and /home/rlpowell/.stack/

To install (almost) all of lts-6.4, and generate Haddock and Hoogle
for them, run stack_all.sh ; you will, if everything goes well, get
a zsh prompt back about 8+ hours later.

At that prompt basic hoogle searches work:

$ hoogle map
map :: (a -> b) -> [a] -> [b]
map :: (Word8 -> Word8) -> ByteString -> ByteString
map :: (Char -> Char) -> ByteString -> ByteString
map :: (Char -> Char) -> Text -> Text
map :: (Char -> Char) -> Stream Char -> Stream Char
map :: (a -> b) -> IntMap a -> IntMap b
map :: (Key -> Key) -> IntSet -> IntSet
map :: (a -> b) -> Map k a -> Map k b
map :: Ord b => (a -> b) -> Set a -> Set b
map :: (a -> b) -> Vector a -> Vector b
-- plus more results not shown, pass --count=20 to see more

If you want a hoogle web interface, and you almost certainly do, run
run_hoogle.sh and point your browser at http://docker:8081/ ; in
this hoogle, all the links will work, i.e. this is how you get to
the Hackage documentation, too, and the rendered source files.
