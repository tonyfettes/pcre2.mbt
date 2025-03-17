import tree_sitter
import tree_sitter_moonbit
from pathlib import Path

MOONBIT_LANGUAGE = tree_sitter.Language(tree_sitter_moonbit.language())


def generate(template: Path):
    parser = tree_sitter.Parser(MOONBIT_LANGUAGE)
    template_content = template.read_text()
    tree = parser.parse(template_content.encode())
    query = MOONBIT_LANGUAGE.query(
        """
(type_definition
 "extern"
 (identifier)) @externType

(type_alias_definition) @typeAlias

((function_definition
  (visibility)? @visibility
  (external_linkage
   (string_literal) @externalLinkage)
  (function_identifier) @functionIdentifier
  (parameters) @functionParameters
  (return_type)? @functionReturnType
  (external_source
   (string_literal
    (string_fragment) @externalSource)))
 (#eq? @externalLinkage "\\"c\\""))"""
    )
    matches = query.matches(tree.root_node)
    artifact = {
        "8": [],
        "16": [],
    }
    for index, captures in matches:
        capture_texts = {}
        for capture_name, capture_node in captures.items():
            capture_node = capture_node[0]
            capture_text = template_content[
                capture_node.start_byte : capture_node.end_byte
            ]
            capture_texts[capture_name] = capture_text

        for code_unit_width in ["8", "16"]:
            if index == 0:
                artifact[code_unit_width].append(capture_texts["externType"])
            elif index == 1:
                artifact[code_unit_width].append(capture_texts["typeAlias"])
            elif index == 2:
                visibility = capture_texts["visibility"] if "visibility" in capture_texts else ""
                identifier = capture_texts['functionIdentifier']
                parameters = capture_texts["functionParameters"]
                return_type = (
                    capture_texts["functionReturnType"]
                    if "functionReturnType" in capture_texts
                    else ""
                )
                external_source = f"\"{capture_texts['externalSource']}_{code_unit_width}\""

                artifact[code_unit_width].append(
                    f"""{visibility} extern \"c\" fn {identifier}{parameters}{return_type} = {external_source}"""
                )

    for code_unit_width in ["8", "16"]:
        artifact[code_unit_width] = "\n\n".join(artifact[code_unit_width])
        path = Path("src") / f"pcre2_{code_unit_width}" / "pcre2.mbt"
        path.write_text(artifact[code_unit_width])


if __name__ == "__main__":
    generate(template=Path("src") / "pcre2.mbt.in")
