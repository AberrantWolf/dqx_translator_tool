# DQX Translator

A small tool to make editing text/dialogue files a bit more straightforward.

## How To

Download the latest release and run the executable. Select "File -> Open" and
navigate to wherever you have your JSON files you want to edit. Select the one,
and click "Open".

The window should populate with all the Japanese and any English text present in
the file. The Japanese cannot be edited, but you can select it to help look up
words you aren't sure about. The English text can be edited freely.

You don't need to put in the `\n` newlines, as those are handled automatically
by the UI system!

Tags like `<this>` are grayed out, but you can still edit them. It's just to
make them look a little different from regular text.

When you're done, choose "File -> Save", and your changes will be saved in-place.

(Note: "Save As" is disabled for now because I didn't want to bother taking the
time to implement it yet. Sorry if you were hoping for that.)

## Development

If you want to edit the project, you'll need Godot 4.3 (currently in beta, but
that's what I'm using. Sorry if that upsets you; I know it's not the best idea).
