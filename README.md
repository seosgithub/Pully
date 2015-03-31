![pully: A command line interface for building a pull request bot](https://raw.githubusercontent.com/sotownsend/pully/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/pully.svg)](http://badge.fury.io/rb/pully)
[![Build Status](https://travis-ci.org/sotownsend/Pully.svg?branch=master)](https://travis-ci.org/sotownsend/Pully)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/pully/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/pully/blob/master/LICENSE)

# What is this?

A work in progress

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
