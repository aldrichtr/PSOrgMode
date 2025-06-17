

enum BaseType {
    base    = 0x0000
    element = 0x1000
    greater = 0x1100
    object  = 0x2000
}
<#------------------------------------------------------------------
  TODO: #24 Change the OrgType enum system to a set of flags
------------------------------------------------------------------#>
enum ElementType {
    unknown   = [BaseType]::base + 0x0000

    # Generic types
    orgdata   = [BaseType]::base + 0x0002
    region    = [BaseType]::base + 0x0003
    plaintext = [BaseType]::base + 0x0007

    # 'Greater Elements' are made up of (only) elements
    headline           = [BaseType]::greater + 0x0001
    section            = [BaseType]::greater + 0x0002
    propertydrawer     = [BaseType]::greater + 0x0003
    footnotedefinition = [BaseType]::greater + 0x0004
    inlinetask         = [BaseType]::greater + 0x0005
    plainlist          = [BaseType]::greater + 0x0006
    item               = [BaseType]::greater + 0x0007
    drawer             = [BaseType]::greater + 0x0008
    table              = [BaseType]::greater + 0x0009
    centerblock        = [BaseType]::greater + 0x000A
    quoteblock         = [BaseType]::greater + 0x000B
    dynamicblock       = [BaseType]::greater + 0x000C
    specialblock       = [BaseType]::greater + 0x000D
    firstsection       = [BaseType]::greater + 0x000E

    # orgmode Elements
    planning         = [BaseType]::element + 0x0001
    babelcall        = [BaseType]::element + 0x0002
    fixedwidth       = [BaseType]::element + 0x0003
    clock            = [BaseType]::element + 0x0004
    comment          = [BaseType]::element + 0x0005
    horizontalrule   = [BaseType]::element + 0x0006
    diarysexp        = [BaseType]::element + 0x0007
    keyword          = [BaseType]::element + 0x0008
    latexenvironment = [BaseType]::element + 0x0009
    nodeproperty     = [BaseType]::element + 0x000A
    tablerow         = [BaseType]::element + 0x000B
    paragraph        = [BaseType]::element + 0x000C
    commentblock     = [BaseType]::element + 0x000D
    srcblock         = [BaseType]::element + 0x000E
    exampleblock     = [BaseType]::element + 0x000F
    exportblock      = [BaseType]::element + 0x0010
    verseblock       = [BaseType]::element + 0x0011

    #orgmode Objects
    bold              = [BaseType]::object + 0x0001
    citation          = [BaseType]::object + 0x0002
    citationreference = [BaseType]::object + 0x0003
    code              = [BaseType]::object + 0x0004
    entity            = [BaseType]::object + 0x0005
    exportsnippet     = [BaseType]::object + 0x0006
    footnotereference = [BaseType]::object + 0x0007
    inlinebabelcall   = [BaseType]::object + 0x0008
    inlinesrcblock    = [BaseType]::object + 0x0009
    italic            = [BaseType]::object + 0x000A
    linebreak         = [BaseType]::object + 0x000B
    latexfragment     = [BaseType]::object + 0x000C
    link              = [BaseType]::object + 0x000D
    macro             = [BaseType]::object + 0x000E
    radiotarget       = [BaseType]::object + 0x000F
    statisticscookie  = [BaseType]::object + 0x0010
    strikethrough     = [BaseType]::object + 0x0011
    subscript         = [BaseType]::object + 0x0012
    superscript       = [BaseType]::object + 0x0013
    tablecell         = [BaseType]::object + 0x0014
    target            = [BaseType]::object + 0x0015
    timestamp         = [BaseType]::object + 0x0016
    underline         = [BaseType]::object + 0x0017
    verbatim          = [BaseType]::object + 0x0018
}
