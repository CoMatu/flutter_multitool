## 0.0.1

* Initial release

## 0.0.2

* Added licence

## 0.0.3
* Added text utilites:
    - ```getNoun``` (for determine the correct declension of a word)
    - ```parseLink``` (for parsing link from string)
* Added custom InputFormatter for TextField:
    - ```UpperCaseTextFormatter```

## 0.0.4
* Added extensions for DateTime

## 0.0.5
* Added FireWorks and Dots Loader widgets

## 0.0.6
* Added DecimalTextInputFormatter for some digits input only

## 0.0.7
* Fixed DecimalTextInputFormatter for some digits input only
  
## 0.0.8
* Added ThousandsSeparatorInputFormatter

## 0.0.9
* Added AnimatedSelectorWidget

## 0.1.0
Added class **Either**, wich used to represent a value that has any one of the two specified types:
```
Either<Error, String> fetchData() {
  try {
    const result = 'Good result';
    return const Either.right(result);
  } catch (e) {
    return Either.left(Error());
  }
}
```
