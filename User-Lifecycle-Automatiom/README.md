# User Lifecycle Automation(Onboarding & Offboarding)
This project demonstrates a production-style user lifecycle automation workflow using PowerShell and Microsoft Graph. It includes two scripts that automate the most common identity management tasks in modern IT environments:

## Overview
This script automates the onboarding process for new employees using Microsoft Graph PowerShell. 

## Core Functions
- Connects to Microsoft Graph
- Creates a new Azure AD user
- Generates a temporary password
- Assignes a Microsoft 365 License
- Adds the user to Azure AD groups
- Exports an onboarding summary (CSV)

## Requirements
- PowerShell 5.1 or 7+
- Microsoft Graph PowerShell SDK
- Azure AD permissions:
    - User.ReadWrite.All
    - Group.ReadWrite.All
    - Directory.ReadWrite.All
