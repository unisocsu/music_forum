#!/usr/bin/env bash
set -euo pipefail

python3 <<'PY'
from pathlib import Path

common_path = Path("webpack.common.js")
common = common_path.read_text(encoding="utf-8")
marker = "// LEGACY_BROWSER_RUNTIME"
if marker not in common:
    anchor = "\toutput: {\n"
    if anchor not in common:
        raise SystemExit("Could not find webpack.common.js output configuration")
    patch = """\toutput: {
\t\t// LEGACY_BROWSER_RUNTIME: keep webpack's runtime compatible with Firefox 68.
\t\tenvironment: {
\t\t\tarrowFunction: false,
\t\t\tconst: false,
\t\t\tdestructuring: false,
\t\t\tdynamicImport: false,
\t\t\tforOf: false,
\t\t\tmodule: false,
\t\t\toptionalChaining: false,
\t\t\ttemplateLiteral: false,
\t\t},
"""
    common = common.replace(anchor, patch, 1)
    common_path.write_text(common, encoding="utf-8")

prod_path = Path("webpack.prod.js")
prod = prod_path.read_text(encoding="utf-8")
marker = "LEGACY_BROWSER_TARGET"
if marker not in prod:
    anchor = "minimizerOptions: {},"
    if anchor not in prod:
        raise SystemExit("Could not find webpack.prod.js minimizerOptions")
    replacement = """// LEGACY_BROWSER_TARGET: lower bundled JavaScript syntax for Firefox 68.
\t\t\t\tminimizerOptions: {
\t\t\t\t\ttarget: 'firefox68',
\t\t\t\t},"""
    prod = prod.replace(anchor, replacement, 1)
    prod_path.write_text(prod, encoding="utf-8")

Path(".browserslistrc").write_text(
    "# CSS compatibility target: Firefox on Android 4.4 KitKat.\nFirefox 68\n",
    encoding="utf-8",
)
PY
