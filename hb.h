#include <X11/Xft/Xft.h>
#include <harfbuzz/hb.h>
#include <hb-ft.h>

void hbunloadfonts();
void hbtransform(XftGlyphFontSpec *, const Glyph *, size_t, int, int);

