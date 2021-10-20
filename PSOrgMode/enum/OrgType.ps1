
enum OrgBaseType {
    base     = 0x0000
    element  = 0x1000
    greater  = 0x1100
    object   = 0x2000
}

enum OrgType {
    unknown                 = 0x000
    any                     = 0x001

    # Generic types
    orgdata                 = 0x002
    plaintext               = 0x004

    # 'Greater Elements' are made up of (only) elements
    headline            = [OrgBaseType]::greater + 0x0001
    section             = [OrgBaseType]::greater + 0x0002
    property_drawer     = [OrgBaseType]::greater + 0x0003
    footnote_definition = [OrgBaseType]::greater + 0x0004
    inlinetask          = [OrgBaseType]::greater + 0x0005
    plain_list          = [OrgBaseType]::greater + 0x0006
    item                = [OrgBaseType]::greater + 0x0007
    drawer              = [OrgBaseType]::greater + 0x0008
    table               = [OrgBaseType]::greater + 0x0009
    center_block        = [OrgBaseType]::greater + 0x000A
    quote_block         = [OrgBaseType]::greater + 0x000B
    dynamic_block       = [OrgBaseType]::greater + 0x000C
    special_block       = [OrgBaseType]::greater + 0x000D

    # org_mode Elements
    planning          = [OrgBaseType]::element + 0x0001
    babel_call        = [OrgBaseType]::element + 0x0002
    fixed_width       = [OrgBaseType]::element + 0x0003
    clock             = [OrgBaseType]::element + 0x0004
    comment           = [OrgBaseType]::element + 0x0005
    horizontal_rule   = [OrgBaseType]::element + 0x0006
    diary_sexp        = [OrgBaseType]::element + 0x0007
    keyword           = [OrgBaseType]::element + 0x0008
    latex_environment = [OrgBaseType]::element + 0x0009
    node_property     = [OrgBaseType]::element + 0x000A
    table_row         = [OrgBaseType]::element + 0x000B
    paragraph         = [OrgBaseType]::element + 0x000C
    comment_block     = [OrgBaseType]::element + 0x000D
    src_block         = [OrgBaseType]::element + 0x000E
    example_block     = [OrgBaseType]::element + 0x000F
    export_block      = [OrgBaseType]::element + 0x0010
    verse_block       = [OrgBaseType]::element + 0x0011

    #org_mode Objects
    bold               = [OrgBaseType]::object + 0x0001
    citation           = [OrgBaseType]::object + 0x0002
    citation_reference = [OrgBaseType]::object + 0x0003
    code               = [OrgBaseType]::object + 0x0004
    entity             = [OrgBaseType]::object + 0x0005
    export_snippet     = [OrgBaseType]::object + 0x0006
    footnote_reference = [OrgBaseType]::object + 0x0007
    inline_babel_call  = [OrgBaseType]::object + 0x0008
    inline_src_block   = [OrgBaseType]::object + 0x0009
    italic             = [OrgBaseType]::object + 0x000A
    line_break         = [OrgBaseType]::object + 0x000B
    latex_fragment     = [OrgBaseType]::object + 0x000C
    link               = [OrgBaseType]::object + 0x000D
    macro              = [OrgBaseType]::object + 0x000E
    radio_target       = [OrgBaseType]::object + 0x000F
    statistics_cookie  = [OrgBaseType]::object + 0x0010
    strike_through     = [OrgBaseType]::object + 0x0011
    subscript          = [OrgBaseType]::object + 0x0012
    superscript        = [OrgBaseType]::object + 0x0013
    table_cell         = [OrgBaseType]::object + 0x0014
    target             = [OrgBaseType]::object + 0x0015
    timestamp          = [OrgBaseType]::object + 0x0016
    underline          = [OrgBaseType]::object + 0x0017
    verbatim           = [OrgBaseType]::object + 0x0018

}
