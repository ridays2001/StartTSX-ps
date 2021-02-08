# No Longer Valid
This script may not work anymore. The dependencies have been updated and a lot of changes have been made to the original create-react-app tool.
----

# StartTSX-PS
This is a powershell script to automate the creation of a TSX project using a single command.
This command will create the TSX project, update dependencies, update README file, remove git references, and copy the setup files to the project folder.

### Installation Instructions:
+ Clone this repo to your computer.
+ If you prefer to use a custom prettier config, then update it in the `./setup-files/.prettierrc` file.
+ Update the `$setup_files` variable in `StartTSX.ps1` file to match the exact path to the `./setup-files/` folder in this repo.
+ Open PowerShell and type `code $Profile`. (Assuming that you're using VS Code. You can use whatever editor you want).
![Image](/img/SS_Profile.png)
+ Your powershell profile settings will open.
+ Then add this line to it `. path/to/folder/StartTSX.ps1`. (Replace the path with exact path to the `StartTSX.ps1` file in this repo).
+ Save the file and close all your powershell windows.
+ Start a new Powershell window and test it out by `tsx <your-project-name>`.
![Image](/img/SS_TSX.png)

### Common Problems:
+ **The system cannot find the file specified.** | **Your powershell profile file doesn't exist.** This problem is usually for those who haven't customized anything in your powershell before. You need to type `$profile` in your powershell > navigate to the directory > create a new file named `Microsoft.PowerShell_profile.ps1`. There you go! Now you have it.
+ **📂❌ Cannot find setup files folder.** This problem arises when you didn't change the `$setup_files` variable in the `StartTSX.ps1` file, or if you added an extra slash at the end of the path.
+ **The term 'tsx' is not recognized as the name of a cmdlet, function, script file, or operable program.** You need to load the script once your powershell starts. For this, we need to add that `. path/to/script.ps1` line to your powershell profile.
