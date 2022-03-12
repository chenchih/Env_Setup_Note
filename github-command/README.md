# GitHub related Note and Command

## Begin Start

### 1. Create configure username and passwd

```
$ git config --global user.name "username"
$ git config --global user.email <email-address>
$ git config --global color.ui auto
```

Check configure setting: `$ git config --list # show all setting`

### 2. Init git: create folder

``` 
$ mkdir tutorial
$ cd tutorial
$ git init
#will generate .init file
```

---



## Common Used

### 1. Creating file

```
$ git add myfile.txt
$ git commit -m "first commit"
$ git push master #or origin
```

### 2. git Add

- git add cuurrent and sub-directory: `git add .`

- git add -A 'file' :

## 3. Remote Tool

- Push `git push <branch>`

- Pull  (get update branch) `git pull`

- Fetch 

- git clone (download git repository) `git clone https://xxxx.git`

---

 

## Advance  Seting

### 1. Branch Adding and Showing

- show branch: ` $git branch`
- Create branch: `$git branch <namebranch>`
- delete branch: ` git branch -d <branch>`
- Switch branch: `$git checkout -b <branch>`
- Merge branch: `$git merge <commit>`

### 2. Conflict  Branch

### 


