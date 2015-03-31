![pully: A ruby library for managing GitHub pull requests](https://raw.githubusercontent.com/sotownsend/pully/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/pully.svg)](http://badge.fury.io/rb/pully)
[![Build Status](https://travis-ci.org/sotownsend/Pully.svg?branch=master)](https://travis-ci.org/sotownsend/Pully)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/pully/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/pully/blob/master/LICENSE)

# What is this?
Pully is a ruby library for managing GitHub pull requests; purpose built for our continuous integration & deployment infrastructure at [Fittr®](http://www.fittr.com).

# Selling points
1.  It's easy to use
2.  It has full code coverage on tests involving GitHub's API
3.  While it uses the pull request interface on GitHub, **it does not use the big green button** to perform a merge.

# Basic usage
```ruby
require 'pully'

#Create a new pully object, each pully object targets (1) repository.
pully = Pully.new(user:"github_username", pass:"github_password", repo:"my_repository")

#Create a new pull request to merge 'my_branch' into 'master' with the title 'My pull request' and the message 'Hey XXX...'
pull_number = pully.create_pull_request(from:"my_branch", to:"master", subject:"My pull request", message:"Hey XXXX, can you merge this for me?")

#Comment on that pull request
pully.write_comment_to_pull_request(pull_number, "Test Comment")

#Get all comments
comments = pully.comments_for_pull_request(pull_number)

#Get the SHA of the 'from' branch of a certain pull request
pully.sha_for_pull_request(pull_number)

#Set the status of a pull request to pending (Other options include 'error', 'failed', and 'success')
pully.set_pull_request_status(pull_number, "pending")

#Set the status of a pull request to ready
pully.set_pull_request_status(pull_number, "success")

#Merge the request (Will NOT use GitHub's pull request merge, will merge commits into history as-is)
pully.merge_pull_request(pull_number)
```

# Organization Repositories
If your repositories are not owner by you, i.e. they are owned by an organization or another user who has granted you permissions, you will need to
pass the `owner` field for the other individual or organization.

```ruby
#Create a new pully object, each pully object targets (1) repository in an organization.
pully = Pully.new(user:"github_username", pass:"github_password", repo:"my_repository", owner:"my_organization")

```

## Requirements

- Ruby 2.1 or Higher

## Communication

- If you **found a bug**, submit a pull request.
- If you **have a feature request**, submit a pull request.
- If you **want to contribute**, submit a pull request.

## Installation

Run `sudo gem install pully`

## Known issues

1. GitHub does not register commits immediately after a push is received. Things like `sha_for_pull_request` will return old values if you don't wait
   several seconds
2. GitHub's status API for pull requests returns 'pending' even if the UI says 'success'. We account for this bug, but if it is fixed in the future,
   then our specs will catch it

---

## FAQ

### When should I use pully?

When you want to automate GitHub pull requests.  Pully provides the necessary facilities for you to authenticate and control GitHub pull requests in
any way you wish.  Duplicate the functionality of many popular CI solutions.

### What's Fittr?

Fittr is a SaaS company that focuses on providing personalized workouts and health information to individuals and corporations through phenomenal interfaces and algorithmic data-collection and processing.

* * *

### Creator

- [Seo Townsend](http://github.com/sotownsend) ([@seotownsend](https://twitter.com/seotownsend))

## License

pully is released under the MIT license. See LICENSE for details.
