// @flow

import type {RejectFunction} from '../typedefs/reject-function.js'
import type {ResolveFunction} from '../typedefs/resolve-function.js'
import type {Search} from '../typedefs/search.js'
import type TextStreamAccumulator from 'text-stream-accumulator'

const BaseSearch = require('./base-search')
const debug = require('debug')('text-stream-search:string-search')

// Calls the given handler exactly one time
// when text matches the given string
class StringSearch extends BaseSearch implements Search {
  searchText: string
  constructor (args: {query: string, accumulator: TextStreamAccumulator, resolve: ResolveFunction, reject: RejectFunction, timeout?: number}) {
    super(args)
    this.searchText = args.query
  }

  // Returns the display name for debug / error messages
  getDisplayName (): string {
    return `string '${this.searchText}'`
  }

  // Returns whether the given text contains the search text this search is looking for
  matches (text: string): boolean {
    const result = text.includes(this.searchText)
    if (result) {
      debug(`search for '${this.searchText}' found a match in '${text}'`)
    } else {
      debug(`no match in '${text}'`)
    }
    return result
  }
}

module.exports = StringSearch
