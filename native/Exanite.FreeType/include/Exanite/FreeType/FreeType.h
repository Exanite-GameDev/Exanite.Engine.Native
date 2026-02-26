// Include the local config first
//
// This is a bit of a monster because Silk can't access the installed headers
// since it requires building the External.FreeType target first
// For consistency reasons, we also don't store the ftoption header locally because
// it differs between the final and bootstrap builds
// We always want the final version for Silk bindings generation
#include "../../../../../cmake/FreeType/include/freetype2/freetype/config/ftoption.h"

#include <ft2build.h>
#include FT_FREETYPE_H
