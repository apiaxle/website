---
layout: docs
title: Signing requests
description: How to sign requests for extra security.
permalink: /docs/signing-requests
---

At the cost of a small performance hit, ApiAxle supports the signing
of requests. Here's how to use and set them up:

## What makes up a signed request

There are three parts which make up a signing key:

* **Shared secret** - this string is supplied on the provisioning of
  the key and will never be revealed in a HTTP request. You would pass
  this to the function that generates the HMAC sig.
* **Epoch** - the UNIX epoch (seconds since 1970-01-01). ApiAxle will
  allow for a six second (3 either way) clock drift.
* **Api key** - the standard key associated with the API.

## Enabling signing for an API key

The signing functionality actually lives with a key, not the API. This
means, when you provision a key via the command-line you do the
following:

    $ ./bin/new-key.coffee --for-api=facebook 1234 --shared-secret=bob-the-builder
    
Now the key `1234` must always carry with it a signed parameter, if it
doesn't then ApiAxle will throw an error and close the door on the
request.

## Signing a request as a client

To sign a request you'll need to replicate the following pseudo code
in whatever your language of choice is:

    date = epoch()
    api_key = "1234"
    shared_secret = "bob-the-builder"
    
    # assuming + is your string concatenation operator
    signature = hmac-sha1( shared_secret, date + api_key )
    
    # now call your end-point with the two query params
    http.GET "facebook.api.localhost?api_sig=$signature&api_key=$api_key"

You can pass the signature in as query parameters named either
`api_sig` or `apiaxle_sig`.

[HMAC-SHA1](http://en.wikipedia.org/wiki/Hash-based_message_authentication_code)
is a way of generating a authentication code that isn't susceptible to
hash length extension attacks. Common implementations and examples:

* [node.js](http://nodejs.org/api/crypto.html#crypto_crypto_createhmac_algorithm_key)
* [python](http://docs.python.org/library/hmac.html#module-hmac)
* [php](http://php.net/manual/en/function.hash-hmac.php)
* [perl](http://search.cpan.org/~mshelor/Digest-SHA-5.72/lib/Digest/SHA.pm)

### Code Examples
  * [PHP](#example_php)
  * [Python 2](#example_python2)
  * [Python 3](#example_python3)
  * [VB.NET](#example_vbnet)
  * [VBA](#example_vba)
  * [Perl](#example_perl)
  * [C#.NET](#example_cs)
  * [Java](#example_java)
  * [JavaScript (NodeJS)](#example_nodejs)
  * [Powershell](#example_powershell)


<a name='example_php'></a>

#### [PHP](http://www.php.net/) Example:

Use the following code, or use the [forevermatt/calc-api-sig](https://packagist.org/packages/forevermatt/calc-api-sig) package via [composer](https://getcomposer.org/).

```php
<?php
$key = 'somerandomkey';       // insert Key Value received from API Developer Portal
$secret = 'somerandomsecret'; // insert Key Secret received from API Developer Portal
$api_sig = hash_hmac('sha1', time().$key, $secret);
```
 
<a name='example_python2'></a>

#### [Python 2](http://docs.python.org/2/) Example:

```python
import hmac
from hashlib import sha1
from time import time
 
key = 'somerandomekey'      # insert Key Value received from API Developer Portal
secret = 'somerandomsecret' # insert Key Secret received from API Developer Portal
curr_time = str(int(time()))
h1 = hmac.new(secret, curr_time+key, sha1)
 
api_sig = h1.hexdigest()
```
 
<a name='example_python3'></a>

#### [Python 3](http://docs.python.org/3/) Example:

```python
import hmac
from hashlib import sha1
from time import time
 
key = 'somerandomkey'       # insert Key Value received from API Developer Portal
secret = 'somerandomsecret' # insert Key Secret received from API Developer Portal
curr_time = str(int(time()))
concat = curr_time+key
# hmac expects byte, python 3.x requires explicit convertion
concatB = (concat).encode('utf-8')
secretB = secret.encode('utf-8')
h1 = hmac.new(secretB, concatB, sha1)
# h1 is byte, so convert to hex
api_sig = h1.hexdigest()
```
 
<a name='example_vbnet'></a>

#### [VB.NET](http://msdn.microsoft.com/en-us/vstudio/hh388573) Example:

```vbnet
Dim api_sig As String = ""
Dim key = "somerandomkey"       ' insert Key Value received from API Developer Portal
Dim secret = "somerandomsecret" ' insert Key Secret received from API Developer Portal
Dim uTime As Integer = (DateTime.UtcNow - New DateTime(1970, 1, 1, 0, 0, 0)).TotalSeconds    'timestamp is Integer
Using myhmac As New HMACSHA1(System.Text.Encoding.UTF8.GetBytes(secret))    'strings must be converted to byte
    Dim hashValue As Byte() = myhmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(String.Concat(uTime.ToString, key)))
    Dim i As Integer
    For i = 0 To (hashValue.Length - 1)
        'byte converted to hex string, abcdef must be lower case,
        'hex numbers below 10 (decimal 16) must be left-padded with a 0.
        api_sig = api_sig + String.Format("{0:x2}", hashValue(i))
    Next i
End Using
```
 
<a name='example_vba'></a>

#### [VBA](http://en.wikipedia.org/wiki/Visual_Basic_for_Applications) Example:

```vbnet
'type declarations for function Local2GMT
Private Type SYSTEMTIME
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type
 
Private Type TIME_ZONE_INFORMATION
    Bias As Long
    StandardName(31) As Integer
    StandardDate As SYSTEMTIME
    StandardBias As Long
    DaylightName(31) As Integer
    DaylightDate As SYSTEMTIME
    DaylightBias As Long
End Type
 
Private Declare Function GetTimeZoneInformation Lib "kernel32" _
               (lpTimeZoneInformation As TIME_ZONE_INFORMATION) As Long
 
Public Function Local2GMT(dtLocalDate As Date) As Date
    Local2GMT = DateAdd("s", -GetLocalToGMTDifference(), dtLocalDate)
End Function
 
Public Function GetApiSig()
    'generates api_sig
    Dim asc As Object
    Dim enc As Object
    Dim key
    Dim secret
    
    Dim SharedSecretKey() As Byte
    Dim uTime As Long
    Dim bytes() As Byte
    Dim api_sig As String
    Dim i As Integer
    
    Set asc = CreateObject("System.Text.UTF8Encoding")
    Set enc = CreateObject("System.Security.Cryptography.HMACSHA1")
    
    key = "somerandomkey"       'insert Key Value received from API Developer Portal
    secret = "somerandomsecret" 'insert Key Secret received from API Developer Portal
    uTime = (Local2GMT(Now) - DateTime.DateValue("01/01/1970")) * 86400
    
    SharedSecretKey = asc.Getbytes_4(uTime & key)
    enc.key = asc.Getbytes_4(secret)
    bytes() = enc.ComputeHash_2(SharedSecretKey)
    
    api_sig = ""
    For i = 0 To 19
        If bytes(i) < 16 Then api_sig = api_sig & "0"
        api_sig = api_sig & LCase(Hex(bytes(i)))
    Next i
    
    GetApiSig = api_sig     'return api_sig to calling procedure
    Set asc = Nothing
    Set enc = Nothing
End Function
```
 
<a name='example_perl'></a>

#### [Perl](http://perl.org/) Example:

```perl
#!/usr/bin/perl
 
use Digest::HMAC_SHA1;
 
my $key = 'yourAPIkey';
my $secret = 'yourAPIsecret';
my $curr_time = int(time());
my $h1 = Digest::HMAC_SHA1->new($secret);
$h1->add($curr_time . $key);
 
my $api_sig = $h1->hexdigest;
```
 
<a name='example_cs'></a>

#### [C#.NET](http://en.wikipedia.org/wiki/C_Sharp_(programming_language)) Example: 

```csharp
public class ApiSigHelper
{
    public void CalculateApiSig(string key, string secret)
    {
        Int64 unixTimestamp = (Int64)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc))).TotalSeconds;
 
        return Encode(unixTimestamp.ToString() + key, secret);
    }
 
    private string Encode(string message, string secret)
    {
        ASCIIEncoding encoding = new ASCIIEncoding();
        byte[] secretBytes = encoding.GetBytes(secret);
 
        HMACSHA1 hmacsha1 = new HMACSHA1(secretBytes);
           
        byte[] messageBytes = encoding.GetBytes(message);
        byte[] hashmessage = hmacsha1.ComputeHash(messageBytes);
 
        return ByteToString(hashmessage);
    }
 
    private string ByteToString(byte[] buff)
    {
        string sbinary = "";
 
        for (int i = 0; i < buff.Length; i++)
            sbinary += buff[i].ToString("x2"); // hex format
 
        return sbinary;
    }
}
```
 
<a name='example_java'></a>

#### [Java](https://www.java.com) Example: 

```java
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Hex;
 
public class CalculateSignatureSnipplet
{
    public static void main(String[] args)
    {
        String key = "<INSERT KEY>";
        String secret = "<SECRET KEY>";
        calculateSignature(key, secret);
    }
 
    /**
     * Calculates the signature
     *
     * @param key
     * @param secret
     * @return
     */
    public static String calculateSignature(String key, String secret)
    {
        String hmac_sha1 = "HmacSHA1";
        try
        {
            long time = System.currentTimeMillis() / 1000;
            key = Long.toString(time) + key;
 
            SecretKeySpec signingKey = new SecretKeySpec(secret.getBytes(), hmac_sha1);
            Mac mac = Mac.getInstance(hmac_sha1);
            mac.init(signingKey);
 
            byte[] rawHmac = mac.doFinal(key.getBytes());
            byte[] hexBytes = new Hex().encode(rawHmac);
 
            return new String(hexBytes, "UTF-8");
        }
        catch (NoSuchAlgorithmException ex)
        {
            System.err.print("Couldn't find algorithm for: " + hmac_sha1 + " " + ex);
        }
        catch (InvalidKeyException ex)
        {
             System.err.print("Invalid key: " + ex);
        }
        catch (UnsupportedEncodingException ex)
        {
             System.err.print("Unsupported Encoding Exception: " + ex);
        }
        return null;
    }
}
```
 
<a name='example_nodejs'></a>

#### [JavaScript (NodeJS)](https://nodejs.org/) Example: 

Note: This has been tested using NodeJS 0.10.36.

```javascript
var crypto = require('crypto');

var apiKey = ...; // insert Key Value received from API Developer Portal.
var sharedSecret = ...; // insert Key Secret received from API Developer Portal.

var unixTimestamp = Math.floor(Date.now() / 1000);
var hmac = crypto.createHmac('sha1', sharedSecret);
var signature = hmac.update(unixTimestamp + apiKey).digest('hex');
```

<a name='example_powershell'></a>

#### [Powershell](https://msdn.microsoft.com/en-us/powershell/mt173057.aspx) Example: 

```posh
[Reflection.Assembly]::LoadWithPartialName("System.Security") 
[Reflection.Assembly]::LoadWithPartialName("System.Net") 
   
$key = "<INSERT KEY>"; 
$secret = "<INSERT SECRET>"; 

$UnixTimeStamp = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds  
$signature_key = ($UnixTimeStamp -as [string]) + $key;
  
$hmacsha1 = new-object System.Security.Cryptography.HMACSHA1;
$hmacsha1.Key = [System.Text.Encoding]::ASCII.GetBytes($secret); 
$signature = [System.Convert]::ToBase64String($hmacsha1.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($signature_key))) 
$signature_bin = [System.Convert]::FromBase64String($signature); 

ForEach ( $Byte In $signature_bin) { 
   $signature_hex = "$signature_hex" + [Convert]::ToString($Byte,16).PadLeft(2,"0") 
 } 
```
