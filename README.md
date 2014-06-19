
![Pquery Logo](http://res.cloudinary.com/gatec21/image/upload/c_scale,w_271/v1403196836/pQuery_l0bq3z.png) 
    
    powerShell Web automation simplified! Inspired by jQuery's ease of use.


*pQuery is a work in progress. Forks/Pulls Welcome.* 

--- 



This module is meant to create a variable that we can use jQuery-like syntax to do jQuery-like
manipulations on a website.

## CORE

#### Find members attached to $pQuery variable 
    $pQuery | GM

--- 


#### Navigate to the site specified
*This should be the first function that you run.*

    $pQuery.Navigate("http://github.com/misterGF")

--- 

## USAGE
*Types can be button, div, form, textField, link or radioButton.*

---

#### Selecting!
    
    $pQuery.Select("button") //By Type
    
    $pQuery.Select("#button") //By ID
    
    $pQuery.Select(".button") //By Class


--- 


#### Getting Text!
    $pQuery.getText("button") //By Type
    
    $pQuery.getText("#button") //By ID
    
    $pQuery.getText(".button") //By Class

--- 

#### Setting Text!
*Set the text value based on your selector*

    $pQuery.setText("button","My Modified Text") //By Type
    
    $pQuery.setText("#button","My Modified Text") //By ID
    
    $pQuery.setText(".button","My Modified Text") //By Class

--- 

#### Clicking!
*Currently Supporting buttons and links.*

    $pQuery.click("#greenBtn") //By ID
    
    $pQuery.click(".buttons") //By Class

--- 

#### Submit!
*Submit a form.*

    $pQuery.submit("#myForm") //By ID
    
    $pQuery.submit(".forms") //By Class

--- 
