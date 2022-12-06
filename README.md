# GitHub Tools

Various utilities for automating work with [GitHub](https://github.com/).

## Creating repository

- `-x 'TOKEN'`  
  GitHub user token.
- `-o 'OWNER'`  
  The organization name. The name is not case sensitive.
- `-r 'REPO_1;REPO_2;REPO_3'`  
  The name of the repository (array).
- `-d 'DESCRIPTION'`  
  A short description of the repository.
- `-s 'https://example.org/'`  
  Repository site URL.
- `-l 'mit'`  
  Open source license template. For example, "mit" or "mpl-2.0".
- `-p`  
  Whether the repository is private.
- `-i`  
  Enable issues for this repository.
- `-j`  
  Enable projects for this repository.
  NOTE: If you're creating a repository in an organization that has disabled repository projects, the API returns an error.
- `-w`  
  Enable the wiki for this repository.
- `-u`  
  Create an initial commit with empty README.

## Removing repository

- `-x 'TOKEN'`  
  GitHub user token.
- `-o 'OWNER'`  
  Repository owner (organization).
- `-r 'REPO_1;REPO_2;REPO_3'`  
  Repository name array.

## Updating topics

- `-x 'TOKEN'`  
  GitHub user token.
- `-o 'OWNER'`  
  Repository owner (organization).
- `-r 'REPO_1;REPO_2;REPO_3'`  
  Repository name array.
- `-t 'TOPIC_1;TOPIC_2;TOPIC_3'`  
  Topic name array.

## Transfer repository

- `-x 'TOKEN'`  
  GitHub user token.
- `-o 'OWNER_OLD'`  
  OLD repository owner (organization).
- `-n 'OWNER_NEW'`  
  NEW repository owner (organization).
- `-r 'REPO_1;REPO_2;REPO_3'`  
  Repository name array.

## Updating repository

- `-x 'TOKEN'`  
  GitHub user token.
- `-o 'OWNER'`  
  Repository owner (organization).
- `-r 'REPO_1;REPO_2;REPO_3'`  
  Repository name array.
- `-d 'DESCRIPTION'`  
  Repository description.
- `-s 'https://example.org/'`  
  Repository site URL.
- `-p`  
  Is private repository.
- `-i`  
  Has issues.
- `-j`  
  Has projects.
- `-w`  
  Has WIKI.
