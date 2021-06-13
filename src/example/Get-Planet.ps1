    #Requires -Version 5 
    function Get-Planet ([string]$Name='*'){
        $planets = @(
            @{ Name = 'Mercury' }
            @{ Name = 'Venus'   }
            @{ Name = 'Earth'   }
            @{ Name = 'Mars'    }
            @{ Name = 'Jupiter' }
            @{ Name = 'Saturn'  }
            @{ Name = 'Uranus'  }
            @{ Name = 'Neptune' }
        ) | foreach { [PSCustomObject]$_ }

        $planets | where { $_.Name -like $Name }
    }