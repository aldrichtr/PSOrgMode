@{
    #---------------------------------------------------------------------------
    #region Module Info

    ModuleVersion = '0.1.0'
    Description = 'Convert objects to and from org-mode'
    GUID = 'c551afdf-80cf-469a-9ace-f6423a10952a'
    HelpInfoURI = ''

    #endregion Module Info
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Module Components

    RootModule = 'PSOrgMode.psm1'
    ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    NestedModules = @()

    ModuleList = ''
    FileList = @()
    #endregion Module Components
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Public Interface

    # CmdletsToExport = @()
    FunctionsToExport = '*'
    VariablesToExport = '*'
    AliasesToExport = '*'
    # DSCResourcesToExport = @()
    # DefaultCommandPrefix = ''

    #endregion Public Interface
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Requirements

    # CompatiblePSEditions = @()
    # PowerShellVersion = '5.0'
    # PowershellHostName = ''
    # PowershellHestVersion = ''
    # RequiredModules = ''
    RequiredAssemblies = @( '../assemblies/OrgMode.dll')
    # ProcessorArchitecture = ''
    # DotNetFrameworkVersion = ''
    # CLRVersion = ''

    #endregion Requirements
    #---------------------------------------------------------------------------

    #---------------------------------------------------------------------------
    #region Author

    Author = 'Tim Aldrich'
    CompanyName = 'aldrichtr'
    Copyright = '(c) 2021 Tim Aldrich. All rights reserved.'

    #endregion Author
    #---------------------------------------------------------------------------

    PrivateData = @{
        PSData = @{
        #---------------------------------------------------------------------------
        #region Project

        Tags = @('Parsing', 'OrgMode')
        LicenseUri = 'https://github.com/aldrichtr/PSOrgMode/LICENSE'
        ProjectUri = 'https://github.com/aldrichtr/PSOrgMode'
        IconUri = ''
        # PreRelease = ''
        # RequireLicenseAcceptance = ''
        # ExternalModuleDependencies = @()
        # ReleaseNotes = ''

        #endregion Project
        #---------------------------------------------------------------------------

        } # end PSData
    } # end PrivateData
} # end hashtable
