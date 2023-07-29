# All things TTRPG

This is a library of regular expressions matching TTRPG-related terms for use
in Bluesky feeds. In particular, the patterns here are used in my
[All things TTRPG] feed, which is generated using [skyfeed.app].

## Topic file

This most interesting part of this is the [`topics.yml`] file. It contains a
[YAML]-formatted list of [regular expressions] (aka patterns), matching
TTRPG-related terms. These are grouped into "topics." So the listing for
*[Neoclassical Geek Revival]* looks like this:

  ```yaml
  Neoclassical Geek Revival:
  - Neoclassical\s*Geek\s*Revival
  - NGR
  ```

I'm not going to explain regular expressions here. If you don't know what they
are, there are plenty of resources on the web. The site
[regular-expressions.info] is a good starting point. There are many others.
Suffice to say that the pattern `Neoclassical\s*Geek\s*Revival` matches
"Neoclassical" followed by zero or more spaces followed by "Geek" followed by
zero or more spaces followed by "Revival". Thus the pattern will match
"Neoclassical Geek Revival", "NeoclassicalGeekRevival", and so on. All matches
are case-insensitive, so it will also match "neoclassical geek revival" or even
"nEocLaSSicalGEEKrEviVaL".

Moreover, patterns only match on word boundaries[^1]. So the pattern `NGR` will
*not* match on the text "*we searched for a point of i**ngr**ess.*",
but it *will* match "*I'm off to play some **NGR**.*"

Some patterns need to be enclosed in single quote marks because they contain
characters that are special to [YAML]. The ones to watch our for are patterns
containing `#` and patterns starting with `[`. Such patterns must be enclosed in
single quotes. For example: `[F5]TD` (for *[Five Torches Deep]*) and `#PF` (for
*[Pathfinder]*).

That's basically it. There is only one major wrinkle to this and that is the
`.macros` entry at the top of the file. This is a list of regular expressions
that can be used in other patterns. The only macro currently defined is
"the-rpg". A lot of the terms are ambiguous. For example, *[Traveller]* is a
TTRPG, but it's also a very common word[^2]. So in order to qualify as a match,
my feed requires that the term be followed by "RPG". The "the-rpg" macro is a
shortcut for this. It also matches variations such as "TravellerRPG",
"Traveller: RPG", or "Traveller the RPG". To use the macro you must place it in
an array with the other parts of the pattern. For example:

  ```yaml
  Traveller:
  - ['Travell?er', *the-rpg]
  ```

This will expand to `Travell?er(\s*:)?(\s*the)?\s*RPG`.

The way macros work uses a little YAML trickery known as "anchors" and
"aliases". I'm not going to explain that here either. The usages in `topics.yml`
should be enough to get the idea.

### Capitalization

You will notice that the patterns in `topics.yml` are capitalized, even though
I've said that all matches are case-insensitive. This is a stylistic choice. I
want the capitalization in the pattern to reflect the "canonical" orthography
for the term, which is usually [title case]. In the case of acronyms, I use
what I think is the common usage. Again, this usually follows title case, so we
have `V:?tM` for *[Vampire: the Masquerade]* and `TotV` for
*[Tales of the Valiant]*.

### Topic order

There is no special significance to the order of the topics in `topics.yml`, but
the `.macros` entry must come first. This is due to the way YAML works. Aside
from that restriction the order of topics does not matter. The script that
combines the topic patterns into the main feed pattern sorts the patterns by
descending length, so longer patterns are matched first. So
"[Candela Obscura RPG]" will be matched in preference to just
"[Candela Obscura]", which on its own is most often a reference to the show.

This is not really important for use in something like [skyfeed.app] because we
don't really care about which topics are matched. Topics are just a way to
organize the pattern library. However, I am working on a more sophisticated feed
generator in which topics will be relevant.

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

<!-- Footnotes -->

[^1]: A word boundary is a transition from a word character to a non-word
      character or vice versa. A word character is any letter, digit, or
      underscore. However, [skyfeed.app] seems to mistakenly consider at least
      some accented characters to be non-word characters, so I've seen things
      like "cocô" matching `CoC` (for *Call of Cthulhu*). This is rare enough
      that it doesn't bother me, but it's something to be aware of.

[^2]: When I first built my feed, I assumed that "Traveller" with two Ls would
      be rare enough that I could safely use it without qualification. I was
      wrong and ended up with a lot of false positives in the feed, so I added
      the "RPG" qualifier.

<!-- Links -->

[All things TTRPG]:          https://bsky.app/profile/did:plc:wpldthix3tayaursdd2czdi7/feed/aaabrflewwwxc
[skyfeed.app]:               https://skyfeed.app
[regular-expressions.info]:  https://www.regular-expressions.info
[regular expressions]:       https://www.regular-expressions.info
[YAML]:                      https://en.wikipedia.org/wiki/YAML
[title case]:                https://en.wikipedia.org/wiki/Title_case
[Neoclassical Geek Revival]: https://www.neoclassicalgames.com
[Five Torches Deep]:         https://www.fivetorchesdeep.com
[Pathfinder]:                https://paizo.com/pathfinder
[Traveller]:                 https://www.mongoosepublishing.com/collections/traveller-rpgs
[Vampire: the Masquerade]:   https://www.worldofdarkness.com/vampire-the-masquerade
[Tales of the Valiant]:      https://www.talesofthevaliant.com
[Candela Obscura RPG]:       https://darringtonpress.com/candela
[Candela Obscura]:           https://critrole.com/shows/candela-obscura
[Call of Cthulhu]:           https://www.chaosium.com/call-of-cthulhu-rpg
[`topics.yml`]:              topics.yml
