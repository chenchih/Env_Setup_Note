# GitHub related Note and Command

## Setup Environment

### Topology

working directory --- staging --- local repository ----- remote respository

<img title="" src="img/gitflow.PNG" alt="title" width="441">

### Tool download

| Name        | url                               |
| ----------- | --------------------------------- |
| github bash | https://www.git-scm.com/downloads |
| sourcetree  | https://www.sourcetreeapp.com/    |

### Setup config File (`.gitconfig`)

After install git it will generate `.gitconfig`  file, which store git configure setting . Store location:

> Windows：C:\Users\username\
> MacOs：~/.gitconfig

- **Show your configure setting**: use command: `git config` and add `--list` parameter like this: 
  
  - `git config --list` will show all configure setting

- **edit your configuration** add username, and email address
  In order to publish any code we need to have username and email.

You can edit configure as below:

```
    $ git config --global user.name "username"
    $ git config --global user.email <email-address>
    $ git config --global color.ui auto

    #add specific editor
    #git config --global core.editor emacs
    #git config --global core.editor "nano -w"
```

- Alias Git command 

## Basic git command

Basic Step and common step are as below:

```
＃Step1: git init 
＃Step 2: touch file and edit file
#Step3: git add .
#Step4: git commit -m "message to commit"
#Step5: git push 
```

### git Init

Initialized empty Git repository in your local repository.  Create working directory, there're **two ways**  you can do:

You can 

> Download repository remotely using git clone, need to create file in github

   or

> Create `.git init` in local and push to remote repository 

| command           | description                                                                                |
| ----------------- | ------------------------------------------------------------------------------------------ |
| git init(local)   | initialize an existing directory as a Git repository.                                      |
| git clone(remote) | retrieve an entire repository from a hosted location via URL.  Download from remote server |

please go to github and first create your repository project name

- Run command in local: `git init`,to generate `.git` file. Step as below: 

```
  #create project example: tutorial
  $ mkdir <directoryName>
  $ cd <directoryName>
  #inital git will generate .git
  $ git init
```

### git status

`git status` show status of new file is added or modify. If new file is been modify will occur `Untracked files`, so we need to add into staging 

> git status 

### git add: Staging your file

you can use adding specfic file: `git add <filename>` or add whole directory `git add .`

- git add command as below, there are couple of command you can use:

> git add filename.xxx
> 
> git add .  #current directory. Stage new/modify/delete files or directory  
> git add -A #Stage new/modify files or directory

Example Step:    

```
    #create a file 
    $ touch test.txt
    # will show git status will occur unstage
    $ git status
    # adding file into staging 
    $ git add . 
    $ git status will occur stage
```

### git commit: save in local repository

Commit this command isave in local repository  

- commit your file using -m for message 
  `$ git commit -m "first commit"`
  or skip staging
  `$ git commit -am "first commit"`

- check log to see commit detail
  `git --log ` or `git --log oneline`

### git log : show commit log

git log will show all your history commit log 

- check log to see commit history  detail

> `git --log` 

 or

>  `git --log oneline`

### git push: push into remote repository

In this step it will push your file to github server.  Github uses default branch is origin, you can change also change to other name.  `$ git push master #or origin`

- push new repository to remote(first time)
  
  ```
  $git remote add origin https://github.com/<username>/repository.git   
  git branch -M main
  git push -u origin main 
  ```

 After running first command : `git remote add origin`, You can go inside and open `.git/config` if success bundle it will occur like below:

```
    [remote "origin"]
     url = https://github.com/<username>/test.git 
```

- update your local repository to remote 

> $git push -u origin master

  or

> $git push 

`-u` : will use default master branch. It will use the last push branch.  So if you use -u next time your can use push master is ok. 

`orgin` : github uses default branch ogigin, you can change also change to other name if you like. 

 Note you can go to `.git` directory and open `configure` to see is it bundle



### git clone : download  repository from remote

  You can use git clone to download repository from remote to local.

  Example:　`git clone https://github.com/<username>/repository.git`

### Other command

- git diff
  
  - `git diff`: diff of what is changed but not staged
  
  - `git diff --staged`: diff of what is staged but not yet commited





## Advance  Seting

### Branch

- show listing your branch: ` $git branch`

- Create branch: `$git branch <branch name>`

- Switch branch: 

- create and switch branch: `$git checkout -b <branch>`

- create branch only: `$git checkout <branch>`

- delete branch: ` $git branch -d <branch>`

- Merge branch: `$git merge <branch name>`

**Example:**
After Creating master need to push like this:

```
$git add -A 
#create draft branch
$git checkout draft
$git commit -m "adding github comamnd"
#push origin draft
$git push origin draft
```

### Conflict Branch

### Reset/ checkout/Fetch recover commit

### rebase:

- git -rebase:
  
  apply any commits of current branch ahead of specified one

# Reference:

- https://code.yidas.com/git-commands/
- https://www.maxlist.xyz/2020/05/03/git-reset-checkout/
- https://w3c.hexschool.com/git/fd426d5a
- https://june.monster/git-github-checkout-reset-revert/