// @flow

import type {Search} from './typedefs/search.js'

const RegexSearch = require('./searchers/regex-search')
const StringSearch = require('./searchers/string-search')
const TextStreamAccumulator = require('text-stream-accumulator')
const debug = require('debug')('text-stream-search')

class TextStreamSearch {
  _accumulator: TextStreamAccumulator
  _searches: Array<Search>

  constructor (stream: stream$Readable) {
    stream.on('data', this._onStreamData.bind(this))

    this._searches = []

    // the output captured so far
    this._accumulator = new TextStreamAccumulator(stream)
  }

  // Returns the full text received from the stream so far
  fullText (): string {
    return this._accumulator.toString()
  }

  reset () {
    this._accumulator.reset()
  }

  // Returns a promise that resolves when the given text shows up in the observed stream
  async waitForText (query: string, timeout?: number): Promise<void> {
    debug(`adding subscription for '${query}'`)
    return new Promise(async (resolve, reject) => {
      const search = new StringSearch({
        accumulator: this._accumulator,
        query,
        resolve,
        reject,
        timeout})
      this._searches.push(search)
      await this._checkSearches()
    })
  }

  // Calls the given handler when the given text shows up in the output
  waitForRegex (query: RegExp, timeout?: number): Promise<void> {
    debug(`adding text search for: ${query.toString()}`)
    return new Promise((resolve, reject) => {
      const search = new RegexSearch({
        accumulator: this._accumulator,
        resolve,
        reject,
        regex: query,
        timeout })
      this._searches.push(search)
      this._checkSearches()
    })
  }

  // Called when new text arrives
  _onStreamData (data: string) {
    debug(`receiving text: '${data}'`)

    // need to wait for the next tick to give the accumulator time to update
    process.nextTick(() => {
      this._checkSearches()
    })
  }

  // Looks for new matches in the received text.
  // Called each time the text or search terms change.
  async _checkSearches () {
    debug(`checking ${this._searches.length} subscriptions`)
    const text = this.fullText()
    for (let search of this._searches) {
      await search.check(text)
    }
  }
}

module.exports = TextStreamSearch
