# gmakerss

Post/convert rss feeds to nntp servers or mbox files.

This is somewhat spiritually similar to
[gmakepod](https://github.com/gromnitsky/gmakepod), only it's written
in JS instead of Ruby.

## Setup

Requires GNU Make 4+, curl, node 18.x.

Clone the repo, type `npm i` inside its dir.

Chose an 'umbrella' dir for your feeds, e.g., `~/rss`; create
a file named `rss.ini` in that dir:

~~~
[http://queue.acm.org/rss/feeds/queuecontent.xml]
dest = comp
from = acmqueue <q@example.com>

[http://tenderlovemaking.com/atom.xml]
dest = comp

[https://www.reddit.com/user/eli-zaretskii/comments/.rss]
curl.opt = -A gmakerss/0.0.1
dest = emacs
~~~

`dest` means either an output name of the resultion mbox file, or a
newsgroup name. `from` is an optional override for the `From` header
in the resulting emails; it's handy when a feed doesn't contain enough
useful metadata. `curl.opt` is used to pass additional params to curl;
e.g., reddit often throws upon the default curl user-agent, hence we
provide another one in the above example.

Now, cd to `~/rss` & type `gmakerss`. It won't create duplicate
emails, for it maintains a history file w/ message-ids.

~~~
$ tree --noreport
.
├── history.txt
├── rss
│   ├── comp
│   └── emacs
└── rss.ini
~~~

`mutt -f rss/comp` will view the mbox.

For help, type `gmakerss help`.

## See also

[rss2mail](https://github.com/gromnitsky/rss2mail),
[grepfeed](https://github.com/gromnitsky/grepfeed)

## Bugs

* tested on Fedora only

## License

MIT
