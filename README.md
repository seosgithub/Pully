![pully: A command line interface for building a pull request bot](https://raw.githubusercontent.com/sotownsend/pully/master/logo.png)

[![Gem Version](https://badge.fury.io/rb/pully.svg)](http://badge.fury.io/rb/pully)
[![Build Status](https://travis-ci.org/sotownsend/Pully.svg?branch=master)](https://travis-ci.org/sotownsend/Pully)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sotownsend/pully/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/sotownsend/pully/blob/master/LICENSE)

# What is this?

A work in progress

# Pully Modules
A concept borrowed from [Rails engines](http://guides.rubyonrails.org/engines.html), Pully modules both serve as your project files, all library modules, and gemified instances.  That is, a project you create is automatically modular and can be imported in another pully module/project.

# Compilation
Pully does not rely on ruby for the final produced `application.js` file.  The output file is pure javascript and written in javascript (not transcoded).  Ruby only serves as a compilation assistant.

# Task
The task is the base unit in pully, similar to a rack module except that rack is a stack and pully is a party.  Based on concepts borrowed from XNU®, FreeBSD®, and GNU HURD®; tasks are combined in pully to produce behavior by many tasks inter-cooperating.  Efficiency has been provided through virtualizing the task communication so that no message passing takes place inside pully and all modules are combined into an efficient monolithic module.

### Task Facilities
Tasks are able to
 - send and receive events from a global or internal source.
 - set interval and timeout timers.
 - store temporary data in it's own heap '$__'

### Default modules
This pully project contains the 'micro-task-kernel', the 'ui', and the 'operations' modules.

## Requirements

- Mac OS X 10.9+ (Untested)
- Ruby 2.1 or Higher

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

Run `sudo gem install pully`

---

## FAQ

### When should I use pully?

Todo

### What's Fittr?

Fittr is a SaaS company that focuses on providing personalized workouts and health information to individuals and corporations through phenomenal interfaces and algorithmic data-collection and processing.

* * *

### Creator

- [Seo Townsend](http://github.com/sotownsend) ([@seotownsend](https://twitter.com/seotownsend))

## License

pully is released under the MIT license. See LICENSE for details.
