---
external help file: PSLegalNotice-help.xml
Module Name: PSLegalNotice
online version:
schema: 2.0.0
---

# Set-LegalNotice

## SYNOPSIS
Configure pre-logon message in Windows using the legal notice screen

## SYNTAX

### Online (Default)
```
Set-LegalNotice -Caption <String> -Text <String> [-ComputerName <String[]>] [<CommonParameters>]
```

### File
```
Set-LegalNotice -Caption <String> -Text <String> [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION
Configures the legal notice to display a pre-logon message that requires the user to press OK to continue.

This function can be used to enable the message directly or generate a reg-file to be deployed using ex.
Group Policy.

## EXAMPLES

### EXAMPLE 1
```
Set-LegalNotice -Caption "Important Title" -Text "Do you really need this computer?" -Path .\MyLegalNotice.reg
```

Generates a reg-file that can be deployed to present the message and title specified before the user sees the logon screen.

## PARAMETERS

### -Caption
Caption/Title for the legal notice

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
Text for the legal notice

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName
Computers to apply legal otice on

```yaml
Type: String[]
Parameter Sets: Online
Aliases:

Required: False
Position: Named
Default value: @($env:COMPUTERNAME)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Desired path for legal notice reg-file for offline usage

```yaml
Type: String
Parameter Sets: File
Aliases:

Required: False
Position: Named
Default value: .\LegalNotice.reg
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Frode Flaten
Date created: 26.12.2018
Version: 0.1.0

## RELATED LINKS
