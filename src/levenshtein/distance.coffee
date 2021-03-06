distance = (algorithm) ->
  algorithm = 'standard' unless algorithm in [
    'standard'
    'transposition'
    'merge_and_split'
  ]

  f = (u, t) ->
    if t < u.length
      u[t+1..]
    else
      ''

  # Source: http://www.fmi.uni-sofia.bg/fmi/logic/theses/mitankin-en.pdf
  switch algorithm

    # Calculates the Levenshtein distance between words v and w, using the
    # following primitive operations: deletion, insertion, and substitution.
    when 'standard' then do (; distance) ->
      memoized_distance = {}
      distance = (v, w) ->
        key =
          if v.localeCompare(w) < 0
            v + '\0' + w
          else
            w + '\0' + v

        if (value = memoized_distance[key]) isnt `undefined`
          value
        else
          if v is ''
            memoized_distance[key] = w.length
          else if w is ''
            memoized_distance[key] = v.length
          else # v.length > 0 and w.length > 0
            a = v[0]; s = v[1..]
            b = w[0]; t = w[1..]

            # Discard identical characters
            while a is b and s.length > 0 and t.length > 0
              a = s[0]; v = s; s = s[1..]
              b = t[0]; w = t; t = t[1..]

            # s.length is 0 or t.length is 0
            return memoized_distance[key] = s.length || t.length if a is b

            p = distance(s,w)
            return memoized_distance[key] = 1 if p is 0
            min = p

            p = distance(v,t)
            return memoized_distance[key] = 1 if p is 0
            min = p if p < min

            p = distance(s,t)
            return memoized_distance[key] = 1 if p is 0
            min = p if p < min

            return memoized_distance[key] = 1 + min

    # Calculates the Levenshtein distance between words v and w, using the
    # following primitive operations: deletion, insertion, substitution, and
    # transposition.
    when 'transposition' then do (; distance) ->
      memoized_distance = {}
      distance = (v, w) ->
        key =
          if v.localeCompare(w) < 0
            v + '\0' + w
          else
            w + '\0' + v

        if (value = memoized_distance[key]) isnt `undefined`
          value
        else
          if v is ''
            memoized_distance[key] = w.length
          else if w is ''
            memoized_distance[key] = v.length
          else # v.length > 0 and w.length > 0
            a = v[0]; x = v[1..]
            b = w[0]; y = w[1..]

            # Discard identical characters
            while a is b and x.length > 0 and y.length > 0
              a = x[0]; v = x; x = x[1..]
              b = y[0]; w = y; y = y[1..]

            # x.length is 0 or y.length is 0
            return memoized_distance[key] = x.length || y.length if a is b

            p = distance(x,w)
            return memoized_distance[key] = 1 if p is 0
            min = p

            p = distance(v,y)
            return memoized_distance[key] = 1 if p is 0
            min = p if p < min

            p = distance(x,y)
            return memoized_distance[key] = 1 if p is 0
            min = p if p < min

            a1 = x[0]  # prefix character of x
            b1 = y[0]  # prefix character of y
            if a is b1 and a1 is b
              p = distance(f(v,1), f(w,1))
              return memoized_distance[key] = 1 if p is 0
              min = p if p < min

            return memoized_distance[key] = 1 + min

    # Calculates the Levenshtein distance between words v and w, using the
    # following primitive operations: deletion, insertion, substitution,
    # merge, and split.
    when 'merge_and_split' then do (; distance) ->
      memoized_distance = {}
      distance = (v, w) ->
        key =
          if v.localeCompare(w) < 0
            v + '\0' + w
          else
            w + '\0' + v

        if (value = memoized_distance[key]) isnt `undefined`
          value
        else
          if v is ''
            memoized_distance[key] = w.length
          else if w is ''
            memoized_distance[key] = v.length
          else # v.length > 0 and w.length > 0
            a = v[0]; x = v[1..]
            b = w[0]; y = w[1..]

            # Discard identical characters
            while a is b and x.length > 0 and y.length > 0
              a = x[0]; v = x; x = x[1..]
              b = y[0]; w = y; y = y[1..]

            # x.length is 0 or y.length is 0
            return memoized_distance[key] = x.length || y.length if a is b

            p = distance(x,w)
            return memoized_distance[key] = 1 if p is 0
            min = p

            p = distance(v,y)
            return memoized_distance[key] = 1 if p is 0
            min = p if p < min

            p = distance(x,y)
            return memoized_distance[key] = 1 if p is 0
            min = p if p < min

            if w.length > 1
              p = distance(x, f(w,1))
              return memoized_distance[key] = 1 if p is 0
              min = p if p < min

            if v.length > 1
              p = distance(f(v,1), y)
              return memoized_distance[key] = 1 if p is 0
              min = p if p < min

            return memoized_distance[key] = 1 + min

global =
  if typeof exports is 'object'
    exports
  else if typeof window is 'object'
    window
  else
    this

global['levenshtein'] ||= {}
global['levenshtein']['distance'] = distance

