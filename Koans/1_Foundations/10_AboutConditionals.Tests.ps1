<#
    Conditionals and Branching

    Conditionals operate with language keywords like if, else, and switch, and utilise
    boolean statements to determine program control flow.

    Due to how PowerShell handles output, its conditional statements can return output
    data, as is usually seen in functional programming languages.
#>
Describe 'Conditionals' {
    Describe 'If/Else' {
        It 'is used to alter which code should be executed based on input' {
            function Assert-IsEven ($Number) {
                if ($Number % 2 -eq 0) {
                    # Values or objects dropped to output on conditionals will still
                    # be used as output for the function.
                    'EVEN'
                }
                else {
                    'ODD'
                }
            }

            Assert-IsEven -Number 2 | Should -Be '__'
            Assert-IsEven -Number __ | Should -Be 'ODD'
        }
        It 'can be used alone' {
            function Set-Number ($Number) {
                if ($Number -gt 5) {
                    $Number * 10
                }
                # What happens if the conditional completely skips the if statement?
            }
            Set-Number -Number 4 | Should -Be __
            Set-Number -Number __ | Should -Be 70
        }
        It 'can be used to select a value for a variable' {
            function Get-Thing {
                return (Get-ChildItem -Path $env:TEMP | Select-Object -Skip 3).Length
            }
            $Thing = Get-Thing
            $Result = if ($Thing.Length -gt 5) {
                # The item dropped to output is stored in the assigned variable
                $Thing
            }
            else {
                # but depending on the outcome of the conditional, either could end up stored!
                "$Thing is less than 5"
            }
            $Result | Should -Be __
        }
        It 'can also apply a condition to an else' {
            #
        }
    }
    Describe 'Switch' {
        # Switches often replace stacks of if/elseif/../else conditionals
        # If you have more than an if/else, you might find a switch useful.
        It 'is used to create multiple possible branches' {
            $Folders = 4..9 | ForEach-Object {"$_" * $_}

            switch ($Folders.Count) {
                1 {
                    # Switch statements assign the current value being tested to $_
                    $Amount = 'one' + $_
                    break
                }
                5 {
                    $Amount = 'five'
                    # Usually we break out of the switch after one case matches
                    break
                }
                default {
                    # The default branch is taken when no other cases match
                    $Amount = "other $_"
                    break
                }
            }

            $Amount | Should -Be '__'
        }
        It 'can also be used to conditionally assign values' {
            $Case = __
            $Variable = switch ($Case) {
                45 {
                    'hello!'
                    break
                }
                47 {
                    4.5
                    break
                }
                57 {
                    -1
                    break
                }
            }

            $Variable | Should -Be -1
            $Variable | Should -BeOfType [__]
        }
        It 'can go through multiple branches' {
            # Omitting the break statement allows one condition to match several cases
            $Values = switch ('Condition') {
                # As with most PowerShell string matching logic, switches are not case sensitive
                'CONDITION' {
                    1
                }
                'condition' {
                    2
                }
            }
            $Values | Should -Be __
        }
        It 'will process each element of arrays' {
            $Array = __

            $Result = switch ($Array) {
                $null {
                    '-2'
                    # Without either a continue or a break here, anything that gets here will
                    # also match the default case!
                }
                4 {
                    $_ * $_
                    <#
                        The continue keyword is like break, except it only skips the rest
                        of the switch for the current value and goes back to test all the
                        other input values.

                        If there is only a single input value, it functions like break.
                    #>
                    continue
                }
                7 {
                    '14'
                    # Using break in an array-input situation means all the rest of
                    # the items don't get tested in the switch. Be careful!
                    break
                }
                default {
                    '-1'
                }
            }

            $Result | Should -Be 16
        }
        It 'accepts wildcard conditions' {
            $Condition = __
            # ... but only if you ask nicely, that is!
            $Result = switch -Wildcard ($Condition) {
                # Wildcarded switches work with ? for single character and * for multiple characters
                'Harm*' {
                    $_ -replace '(.)', '$1,a,'
                }
            }

            $Result | Should -Be '__'
        }
        It 'accepts regex conditions' {
            # Enter a regex string that matches the pattern to pass the test.
            $Value = '__'
            $Pattern = "a.*z.n"

            # If you need a regex refresher, check out https://regexr.com/
            # Remember that unless specified, it doesn't need to match the entire string!

            switch -Regex ($Value) {
                $Pattern {
                    $Result = $true
                }
            }
            $Result | Should -BeTrue
        }
        It 'allows use of conditional expressions' {
            $TestValue = __

            # Unlike many other languages, PowerShell allows you to customise switches immensely
            # through the use of script blocks to create dynamic conditions
            switch ($TestValue) {
                # Condition blocks need a boolean outcome, or it will be coerced to boolean
                {$_ -gt 7} {
                    # Only one of these test cases needs to pass!
                    $_ | Should -Be 9
                }
                {$_ -is [decimal]} {
                    $_ | Should -Be 1.5
                }
                {$_.Length -gt 4} {
                    $_ | Should -BeOfType [string]
                }
            }
        }
    }
}