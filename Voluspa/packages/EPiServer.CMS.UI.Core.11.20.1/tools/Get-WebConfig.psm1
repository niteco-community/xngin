function Get-WebConfig
{
	param ($projectPath)

	# Construct the path to the web.config based on the project path
	$webConfigPath = Join-Path $projectPath "web.config"

	# Do an early exit returning null if the web.config file doesn't exist
	if (!(Test-Path $webConfigPath))
	{
		return $null
	}

	# Load the web.config as an XmlDocument
	[xml] $config = Get-Content $webConfigPath

	# Expand all the nodes that have their configuration in another file
	$config.SelectNodes("//*[@configSource]") | ForEach-Object {
		$configFragmentPath = Join-Path $projectPath $_.GetAttribute("configSource")
		if (Test-Path $configFragmentPath)
		{
			# Set the contents of the referenced file as the contents of the referencing element
			$_.InnerXml = ([xml](Get-Content $configFragmentPath)).FirstChild.InnerXml
			$_.RemoveAttribute("configSource")
		}
	}

	return $config
}

Export-ModuleMember -Function Get-WebConfig
# SIG # Begin signature block
# MIIY1QYJKoZIhvcNAQcCoIIYxjCCGMICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU1+EiwkvMbcvaz8al7NIVfQc9
# OWqgghP9MIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggVnMIIET6ADAgECAhEAmC+SaSXEmwKb5aP3fjOjVTANBgkqhkiG9w0BAQsFADB8
# MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
# VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAiBgNVBAMT
# G1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQTAeFw0xOTA1MjIwMDAwMDBaFw0y
# MjA1MjEyMzU5NTlaMIG1MQswCQYDVQQGEwJTRTEOMAwGA1UEEQwFMTExNTYxDzAN
# BgNVBAgMBlN3ZWRlbjESMBAGA1UEBwwJU3RvY2tob2xtMRowGAYDVQQJDBFSZWdl
# cmluZ3NnYXRhbiA2NzERMA8GA1UEEgwIQm94IDcwMDcxFTATBgNVBAoMDEVwaXNl
# cnZlciBBQjEUMBIGA1UECwwLRW5naW5lZXJpbmcxFTATBgNVBAMMDEVwaXNlcnZl
# ciBBQjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALMg0HiSm99PJyVg
# buJFKNjRyi98VFKF4lTVA4GXfXgixyErz+ISaHcXrjxEW1CkH55+Vh+LDjBIMqJ2
# mOC+2d/Dh9OwZINayxOxV+gsqGH7F+7o//+EAWztkRH9Etw2IBedwlTeZvZitKew
# 6gYWZwMq7wM5Ndp7oaXw8E4MXviOY6Lof390xWWy3BhWRu9I37JhU4vkrnxg4cPZ
# 8sZYb0OEw/n0mvJ2Y2wjyRUQYZXtUHyAe2c5lfmDpdFkFf7QEPB9Erkm19MvF6Rv
# Av9hkaeQbNnFAKbJcp57ewpDdEMzR+CrLkwjSZhX5HM39/Aq/O58e4fCfSIotBYS
# nDZcjrcCAwEAAaOCAagwggGkMB8GA1UdIwQYMBaAFA7hOqhTOjHVir7Bu61nGgOF
# rTQOMB0GA1UdDgQWBBT8FQmibCssGc1dLqmLA0Jk40EuJDAOBgNVHQ8BAf8EBAMC
# B4AwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhC
# AQEEBAMCBBAwQAYDVR0gBDkwNzA1BgwrBgEEAbIxAQIBAwIwJTAjBggrBgEFBQcC
# ARYXaHR0cHM6Ly9zZWN0aWdvLmNvbS9DUFMwQwYDVR0fBDwwOjA4oDagNIYyaHR0
# cDovL2NybC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ29kZVNpZ25pbmdDQS5jcmww
# cwYIKwYBBQUHAQEEZzBlMD4GCCsGAQUFBzAChjJodHRwOi8vY3J0LnNlY3RpZ28u
# Y29tL1NlY3RpZ29SU0FDb2RlU2lnbmluZ0NBLmNydDAjBggrBgEFBQcwAYYXaHR0
# cDovL29jc3Auc2VjdGlnby5jb20wIAYDVR0RBBkwF4EVc3VwcG9ydEBlcGlzZXJ2
# ZXIuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQCEvy8b9Y9uMcMSgC6H4qSrY0WetAMr
# QwTIea4KhaNDA/6C5hwfDv9HyOupMkBFgOUx2nxvH0MPy1yAC6EH2wtk+VCIbIYA
# hDPKLMdJ2s8UqCjbIAFKfCCh1im+VtUkQnFDWKNt+fLfKk9CfAd2lhS0NnUEmSzj
# 8/z4QwRO06asyL2i0VjdicUQTvRVEEoVqABvUisChgJMyp+yRHi5SbXDoSfiaIV/
# Hx+JILrr2nBAQ0Cj5KXHW0DnBAFyGqXTC62iFKz2ToNG250Dk+FWX1zBbQShc9ne
# muHX/HYmYWEg8M/9YorIYwDDEFNFjupbDPP67cA7vauuXqsuy2TcdXo9MIIF9TCC
# A92gAwIBAgIQHaJIMG+bJhjQguCWfTPTajANBgkqhkiG9w0BAQwFADCBiDELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBD
# aXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVT
# RVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTgxMTAyMDAw
# MDAwWhcNMzAxMjMxMjM1OTU5WjB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
# YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0
# aWdvIExpbWl0ZWQxJDAiBgNVBAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBD
# QTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAIYijTKFehifSfCWL2MI
# Hi3cfJ8Uz+MmtiVmKUCGVEZ0MWLFEO2yhyemmcuVMMBW9aR1xqkOUGKlUZEQauBL
# Yq798PgYrKf/7i4zIPoMGYmobHutAMNhodxpZW0fbieW15dRhqb0J+V8aouVHltg
# 1X7XFpKcAC9o95ftanK+ODtj3o+/bkxBXRIgCFnoOc2P0tbPBrRXBbZOoT5Xax+Y
# vMRi1hsLjcdmG0qfnYHEckC14l/vC0X/o84Xpi1VsLewvFRqnbyNVlPG8Lp5UEks
# 9wO5/i9lNfIi6iwHr0bZ+UYc3Ix8cSjz/qfGFN1VkW6KEQ3fBiSVfQ+noXw62oY1
# YdMCAwEAAaOCAWQwggFgMB8GA1UdIwQYMBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bL
# MB0GA1UdDgQWBBQO4TqoUzox1Yq+wbutZxoDha00DjAOBgNVHQ8BAf8EBAMCAYYw
# EgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAwYIKwYBBQUH
# AwgwEQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9j
# cmwudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9y
# aXR5LmNybDB2BggrBgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQu
# dXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEF
# BQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOC
# AgEATWNQ7Uc0SmGk295qKoyb8QAAHh1iezrXMsL2s+Bjs/thAIiaG20QBwRPvrjq
# iXgi6w9G7PNGXkBGiRL0C3danCpBOvzW9Ovn9xWVM8Ohgyi33i/klPeFM4MtSkBI
# v5rCT0qxjyT0s4E307dksKYjalloUkJf/wTr4XRleQj1qZPea3FAmZa6ePG5yOLD
# CBaxq2NayBWAbXReSnV+pbjDbLXP30p5h1zHQE1jNfYw08+1Cg4LBH+gS667o6XQ
# hACTPlNdNKUANWlsvp8gJRANGftQkGG+OY96jk32nw4e/gdREmaDJhlIlc5KycF/
# 8zoFm/lv34h/wCOe0h5DekUxwZxNqfBZslkZ6GqNKQQCd3xLS81wvjqyVVp4Pry7
# bwMQJXcVNIr5NsxDkuS6T/FikyglVyn7URnHoSVAaoRXxrKdsbwcCtp8Z359Luko
# TBh+xHsxQXGaSynsCz1XUNLK3f2eBVHlRHjdAd6xdZgNVCT98E7j4viDvXK6yz06
# 7vBeF5Jobchh+abxKgoLpbn0nu6YMgWFnuv5gynTxix9vTp3Los3QqBqgu07SqqU
# EKThDfgXxbZaeTMYkuO1dfih6Y4KJR7kHvGfWocj/5+kUZ77OYARzdu1xKeogG/l
# U9Tg46LC0lsa+jImLWpXcBw8pFguo/NbSwfcMlnzh6cabVgxggRCMIIEPgIBATCB
# kTB8MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxJDAiBgNV
# BAMTG1NlY3RpZ28gUlNBIENvZGUgU2lnbmluZyBDQQIRAJgvkmklxJsCm+Wj934z
# o1UwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFKnOZ6DAs1upfnSOUlZNZum9wcZ8MA0GCSqGSIb3
# DQEBAQUABIIBAKSMigKrmtfsg2vqBCFM0Ggmy8+EFObP/uyw6K2CfWQpoOASSj+D
# qNYSdIG7gYp13WH3ABbfOcBxVM4bR5MxFb6Nz948XkUy/HMEmppVbcjxMJelaDpm
# qe7QCEWT8QOtHxOflEzPrSmJ+O52Fl2j7fbQcSjBeFZTFJ+m437+IsJUjkY3/nJp
# ovomthwukmDZ67CUHrn3O3SL/COo3kDe5HKpT9P+t9mA3IpIEu+Xhb4a463fUgVb
# rrdsYSB2P21+5ffE1YQI8cz/TXBgddQ5i3W5r95EqexO1iqOEWn8zIMpFkrq9m8C
# sbAdoXOJZNRa/W+4CtgAMMPidWqRR+CoQbKhggILMIICBwYJKoZIhvcNAQkGMYIB
# +DCCAfQCAQEwcjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29y
# cG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2Vydmlj
# ZXMgQ0EgLSBHMgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMCGgUAoF0wGAYJKoZI
# hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTkwNTI4MDY0MzQw
# WjAjBgkqhkiG9w0BCQQxFgQUEUL8/uQroVKDKvEPk/Jg6JHJBtowDQYJKoZIhvcN
# AQEBBQAEggEAJP9gihnqVqUt+2R6gg8/RbL6QfjzKt1k9WyXk6U3Rq4OjQs9sD3D
# 0XqzsPcGBohAR2RGfoL6+fWKUPbE0Pj/i1Dz135BaCYO9sf3DZ1HQQgTyuvkFuat
# YnBvvOfA9Eu6lJV2SfnkpMYvBYU9P95azmU1X8dIpr6nk9DuEwnYU7oBSrqt/xAs
# 5whLMSzsq3HZkpg/n8Hkl+kHUEhWmwRgyWs77ifVcqlRDSv0zf74osdmQh/jz0xP
# GushmyixDA/Znt2vyXykgtX8EBdclmEkkFgewxOtUswPwLaDfA2j1RzeZqX9BqTv
# Zt9XvWWYW9oOTAcHL+Fn/LDLYHfEdFN3fg==
# SIG # End signature block