// @flow

import type {RejectFunction} from '../typedefs/reject-function.js'
import type {ResolveFunction} from '../typedefs/resolve-function.js'
import type {Search} from '../typedefs/search.js'
import type TextStreamAccumulator from 'text-stream-accumulator'

const debug = require('debug')('text-stream-search')
const delay = require('delay')

// calls the given handler exactly one time
// when text matches the given string
class BaseSearch implements Search {
  accumulator: TextStreamAccumulator
  resolve: ResolveFunction
  reject: RejectFunction

  constructor (args: {accumulator: TextStreamAccumulator, resolve: ResolveFunction, reject: RejectFunction, timeout?: number}) {
    this.accumulator = args.accumulator
    this.resolve = args.resolve
    this.reject = args.reject
    if (args.timeout != null) setTimeout(this._onTimeout.bind(this), args.timeout)
  }

  // checks for matches
  //
  // Disables after the first match,
  // subsequent calls are ignored
  async check (text: string) {
    if (this.matches(text)) await this._foundMatch(text)
  }

  getDisplayName (): string {
    throw new Error('implement in subclass')
  }

  matches (text: string): boolean {
    throw new Error('implement in subclass')
  }

  // called when a match is found
  async _foundMatch (text: string) {
    debug(`found match for ${this.getDisplayName()}`)
    await delay(1)
    this.resolve()
  }

  // called after a given timeout
  _onTimeout () {
    const errorMessage = `Expected '${this.accumulator.toString()}' to include ${this.getDisplayName()}`
    debug(`Timeout: rejecting with error message '${errorMessage}'`)
    this.reject(new Error(errorMessage))
  }
}

module.exports = BaseSearch
