# All things TTRPG

Library of regular expressions matching TTRPG-related terms for use in Bluesky
feeds. In particular, the patterns here are used in my [All things TTRPG] feed
generated from [skyfeed.app].

## Topic file

The `topics.yml` file contains a [YAML]-formatted list of regular expressions
matching TTRPG-related terms. These are grouped into "topics." So the listing
for *Neoclassical Geek Revival* looks like this:

  ```yaml
  Neoclassical Geek Revival:
  - Neoclassical\s*Geek\s*Revival
  - NGR
  ```

I'm not going to explain regular expressions here. If you don't know what they
are, there are plenty of resources on the web. The wikipedia page covers the
[basic concepts]. Suffice to say that the pattern
`Neoclassical\s*Geek\s*Revival` matches "Neoclassical" followed by zero or more
spaces followed by "Geek" followed by zero or more spaces followed by "Revival".
Thus the pattern will match "Neoclassical Geek Revival",
"NeoclassicalGeekRevival", and so on. All matches are case-insensitive, so it
will also match "neoclassical geek revival" or even "nEocLaSSicalGEEKrEviVaL".

Some patterns need to be enclosed in single quote marks because they contain
characters that are special to [YAML]. The ones to watch our for are patterns
containing `#` and patterns starting with `[`. Such patterns must be enclosed in
single quotes. For example: `[F5]TD` (for *Five Torches Deep*) or `#PF` (for
*Pathfinder*).

That's basically it. There is only one major wrinkle to this and that is the
`.macros` entry at the top of the file. This is a list of regular expressions
that can be used in other patterns. The only macro currently defined is
"the-rpg". A lot of the terms are ambiguous. For example, *Shadowrun* is a
TTRPG, but it's also a video game. So in order to qualify as a match, my feed
requires that the term be followed by "RPG". The "the-rpg" macro is a shortcut
for this. It also matches variations such as "ShadowrunRPG", "Shadowrun: RPG",
or "Shadowrun the RPG". To use the macro you must place it in an array with the
other parts of the pattern. For example:

  ```yaml
  Shadowrun:
  - [Shadowrun, *the-rpg]
  ```

This will expand to `Shadowrun(\s*:)?(\s*the)?\s*RPG`.

The way macros work uses a little YAML trickery known as "anchors" and
"aliases". I'm not going to explain that here either. The usages in `topics.yml`
should be enough to get the idea.

## Using the script

The `build-pattern` script combines the patterns in `topics.yml` into a single
regular expression for use in feed generator such as [skyfeed.app].

To use it you must have Ruby 3.2 or later installed. Then you can run the script
with the following command:

  ```bash
  ./build-pattern topics.yml
  ```

If you want to get fancy, you can run the tests as well. First you need to
install the dependencies:

  ```bash
  bundle install
  ```

Then you can run the tests:

  ```bash
  rspec
  ```

If you've modified `topics.yml`, you might only want to run the tests for that.
You can do so with the following command:

  ```bash
  rspec spec/topics_spec.rb
  ```

## History

This started out as a simple text of the regular expressions making up the feed,
but as the library grew, it quickly became unwieldy to maintain. I decided to
move the patterns to a [YAML] file, which is easier to maintain, and added a
simple Ruby script to combine the individual patterns into a single regular
expression.

And then I added tests...

And then I added GitHub actions...

<!-- Links -->

[All things TTRPG]: https://bsky.app/profile/did:plc:wpldthix3tayaursdd2czdi7/feed/aaabrflewwwxc
[skyfeed.app]:      https://skyfeed.app
[basic concepts]:   https://en.wikipedia.org/wiki/Regular_expression#Basic_concepts
[YAML]:             https://en.wikipedia.org/wiki/YAML
