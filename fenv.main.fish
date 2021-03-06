#The MIT License (MIT)

# Copyright (c) 2015 Derek Willian Stavis

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


function fenv.main
  set PROGRAM $argv
  set DIVIDER (fenv.parse.divider)
  set OLD_ENV (bash -c 'env')

  if not set PROGRAM_EXECUTION (bash -c "$PROGRAM; echo; echo '$DIVIDER'; env")
    return
  end

  if not contains -- (fenv.parse.divider) $PROGRAM_EXECUTION
    echo "Foreign environment found and error! Aborting to avoid damage!"
    return
  end

  set PROGRAM_OUTPUT (fenv.parse.before $PROGRAM_EXECUTION)
  set NEW_ENV (fenv.parse.after $PROGRAM_EXECUTION)

  set ENVIRONMENT_DIFF (fenv.parse.diff "$OLD_ENV $DIVIDER $NEW_ENV")

  fenv.apply $ENVIRONMENT_DIFF

  printf "%s\n" $PROGRAM_OUTPUT
end
