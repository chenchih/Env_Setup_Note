# Theme Setting amro
This is a step of how to step this theme from beginner, reference from youtube channel
##  Prerequisite
please first know how to setup `ohmyposh` and related `package/module`.
The theme I am using is `amro` from documentation theme and modify it. 
[OhmyPosh Link](https://ohmyposh.dev/)

## Step to add theme
### Step1: create a duplicate of amro.omp.json
Please go to [theme](https://ohmyposh.dev/docs/themes) download and modify your own perference theme

### Step2 Create Session- username
> `segment style`: `plain| diamond|powerline`

- add hostname can reference session on documentation
```
// before
{
    "foreground": "#45F1C2",
	"style": "plain",
	"template": "\ueb99 {{ .UserName }} on",
    "type": "session"
},
```

Change the  template option as below: 
`"template": "\ueb99 {{ .UserName }} \uf108 {{.HostName}}"`


### Step3 shorten folder to ..
You can go to the Path in documentation to see setting

style: `agnoster` ==> `../Foldername`
style: `agnoster_short` ==> `../../Foldername`


```
  {
          "foreground": "#0CA0D8",
          "properties": {
            "folder_separator_icon": "/",
            "style": "full"
          },
          "style": "plain",
          "template": " \uf07b {{ .Path }} ",
          "type": "path"
        } 
```
change the style to `"style": "agnoster"`

### Step4: adding another block for new line to type command (optional)
if you don't want to type command in newline, then false newline. 
The default of it is true
> `true`: newline
> `false`: same line

```
      "alignment": "left",
      "newline": false, 
      "segments": [
        {
          "foreground": "#cd5e42",
          "style": "plain",
          "template": "\ue3bf ",
          "type": "root"
        },
```


### Step5 Battery segment 
please go to battery section in documentation, and copy the code. 
Remove `powerline_symbol` else wil show with arrow background
replace background to foreground to remove the background color
```
	{
		  "type": "battery",
		  "style": "plain",
		  "foreground": "#193549",
		  "foreground": "#ffeb3b",
		  "foreground_templates": [
			"{{if eq \"Charging\" .State.String}}#40c4ff{{end}}",
			"{{if eq \"Discharging\" .State.String}}#ff5722{{end}}",
			"{{if eq \"Full\" .State.String}}#4caf50{{end}}"
		  ],
		  "template": " {{ if not .Error }}{{ .Icon }}{{ .Percentage }}{{ end }} ",
		  "properties": {
			"discharging_icon": " ",
			"charging_icon": " ",
			"charged_icon": " "
		  }
		}
```

### Step6 adding specfic logo icon like youtube 
In this part please refer the `command` in documentation, if no one create it
In the top one create a new segment `{},`
```
 "alignment": "left",
      "segments": [
	{
	  "type": "command",
	  "style": "diamond",
	  "leading_diamond":"\ue0b6",
	  "trailing_diamond":"\ue0b4 ",
	  "background":"#FFFFFF",
	  "foreground":"#ff0000",
	  "properties": {
	  "shell":"bash",
	 "command": "echo ' Youtube ' "
	  },
	  "template": "\uf16a {{ .Output }} "
	},
	  ........
	  ]
```

## How to change theme or run theme

- edit your profile: `notepad $profile`
- add your theme : 
```
#theme same location as theme
$omp_config = Join-Path $PSScriptRoot ".\theme.json"

# default location
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\themename.json" | Invoke-Expression

#full path
#oh-my-posh init pwsh --config "C:\theme.json" | Invoke-Expression
```
- apply your theme in same session: `. $profile` [option1]
- open new terminal [option2]
