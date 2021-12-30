
enum OrgBaseType {
    base    = 0x0000
    element = 0x1000
    greater = 0x1100
    object  = 0x2000
}
<#------------------------------------------------------------------
  TODO: #24 Change the OrgType enum system to a set of flags
------------------------------------------------------------------#>
enum OrgType {
    unknown   = [OrgBaseType]::base + 0x0000

    # Generic types
    orgdata   = [OrgBaseType]::base + 0x0002

    region    = [OrgBaseType]::base + 0x0003
    plaintext = [OrgBaseType]::base + 0x0007

    # 'Greater Elements' are made up of (only) elements
    headline           = [OrgBaseType]::greater + 0x0001
    section            = [OrgBaseType]::greater + 0x0002
    propertydrawer     = [OrgBaseType]::greater + 0x0003
    footnotedefinition = [OrgBaseType]::greater + 0x0004
    inlinetask         = [OrgBaseType]::greater + 0x0005
    plainlist          = [OrgBaseType]::greater + 0x0006
    item               = [OrgBaseType]::greater + 0x0007
    drawer             = [OrgBaseType]::greater + 0x0008
    table              = [OrgBaseType]::greater + 0x0009
    centerblock        = [OrgBaseType]::greater + 0x000A
    quoteblock         = [OrgBaseType]::greater + 0x000B
    dynamicblock       = [OrgBaseType]::greater + 0x000C
    specialblock       = [OrgBaseType]::greater + 0x000D
    firstsection       = [OrgBaseType]::greater + 0x000E

    # orgmode Elements
    planning         = [OrgBaseType]::element + 0x0001
    babelcall        = [OrgBaseType]::element + 0x0002
    fixedwidth       = [OrgBaseType]::element + 0x0003
    clock            = [OrgBaseType]::element + 0x0004
    comment          = [OrgBaseType]::element + 0x0005
    horizontalrule   = [OrgBaseType]::element + 0x0006
    diarysexp        = [OrgBaseType]::element + 0x0007
    keyword          = [OrgBaseType]::element + 0x0008
    latexenvironment = [OrgBaseType]::element + 0x0009
    nodeproperty     = [OrgBaseType]::element + 0x000A
    tablerow         = [OrgBaseType]::element + 0x000B
    paragraph        = [OrgBaseType]::element + 0x000C
    commentblock     = [OrgBaseType]::element + 0x000D
    srcblock         = [OrgBaseType]::element + 0x000E
    exampleblock     = [OrgBaseType]::element + 0x000F
    exportblock      = [OrgBaseType]::element + 0x0010
    verseblock       = [OrgBaseType]::element + 0x0011

    #orgmode Objects
    bold              = [OrgBaseType]::object + 0x0001
    citation          = [OrgBaseType]::object + 0x0002
    citationreference = [OrgBaseType]::object + 0x0003
    code              = [OrgBaseType]::object + 0x0004
    entity            = [OrgBaseType]::object + 0x0005
    exportsnippet     = [OrgBaseType]::object + 0x0006
    footnotereference = [OrgBaseType]::object + 0x0007
    inlinebabelcall   = [OrgBaseType]::object + 0x0008
    inlinesrcblock    = [OrgBaseType]::object + 0x0009
    italic            = [OrgBaseType]::object + 0x000A
    linebreak         = [OrgBaseType]::object + 0x000B
    latexfragment     = [OrgBaseType]::object + 0x000C
    link              = [OrgBaseType]::object + 0x000D
    macro             = [OrgBaseType]::object + 0x000E
    radiotarget       = [OrgBaseType]::object + 0x000F
    statisticscookie  = [OrgBaseType]::object + 0x0010
    strikethrough     = [OrgBaseType]::object + 0x0011
    subscript         = [OrgBaseType]::object + 0x0012
    superscript       = [OrgBaseType]::object + 0x0013
    tablecell         = [OrgBaseType]::object + 0x0014
    target            = [OrgBaseType]::object + 0x0015
    timestamp         = [OrgBaseType]::object + 0x0016
    underline         = [OrgBaseType]::object + 0x0017
    verbatim          = [OrgBaseType]::object + 0x0018

}
