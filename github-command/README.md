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

### 2. git Add (adding into staging>

- git add cuurrent and sub-directory: `git add .`

- git add one file: `git add <filename>`

- git add -A 'file' : 
  
  

## 3. Commit save to local

commit your message:     `commit -m <message>`

use 

## 4.  Remote Tool

- Push `git push <branch>`

- Pull  (get update branch) `git pull`

- Fetch 

- git clone (download git repository) `git clone https://xxxx.git`



### 5. log and status

see git commit status with commit id : `$git log`

see git commit in one line : `$git log --oneline`

see git status: `git status`

4. 

---

 

## Advance  Seting

### 1. Branch Adding and Showing

- show branch: ` $git branch`
- Create branch: `$git branch <namebranch>`
- delete branch: ` $git branch -d <branch>`
- Switch branch: 
  - create and switch branch: `$git checkout -b <branch>`
  - create branch only: `$git checkout <branch>`
- Merge branch: `$git merge <commit>`

After Creating master need to push like this:

```
$git add -A 
#create draft branch
$git checkout draft
$git commit -m "adding github comamnd"
#push origin draft
$git push origin draft
```



### 2. Conflict  Branch

### 


