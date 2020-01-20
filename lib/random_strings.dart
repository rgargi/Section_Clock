import 'dart:math';

class RandomStrings {
  String getRandomAnimation() {
    final _animationList = const [
      'EyesBlinkSlow',
      'EyesBlinkFast',
      'EyesUpDown',
      'Body',
      'BodyEyesMove',
      'BodyEyesMoveBlink',
      'BodyEyesBlinkSlow',
      'BodyEyesMoveBlinkFast',
    ];
    return _animationList[Random().nextInt(_animationList.length)];
  }

  String getRandomString() {
    final _random = Random();
    final _output = _names[_random.nextInt(_names.length)] +
        ' ' +
        _activity[_random.nextInt(_activity.length)];
    return _output;
  }

  static const List<String> _names = const [
    'the witch',
    'the wizard',
    'the bear',
    'the unicorn',
    'the cat',
    'the goose',
    'the pig',
    'the dog',
    'the cow',
    'the toad',
    'the mole',
    'the rat',
    'the badger',
    'the rabbit',
    'the koala',
  ];

  static const List<String> _activity = const [
    'is home',
    'is doing a silly dance',
    'is cooking a huge meal',
    'is running away',
    'has stolen an orange',
    'is baking a cake',
    'is eating burnt toast',
    'is eating doughnuts',
    'is sneaking out',
    'is sleeping',
    'is stealing apples',
    'is gardening',
    'is smelling flowers',
    'is reading a book',
    'is knitting',
    'is going to the library',
    'is listening to music',
    'is yelling at the T.V.',
    'is watching a movie',
    'is drinking water',
    'is looking at the sky',
    'is riding a bicycle',
    'is walking in the park',
    'is working hard',
    'is eating bananas',
    'has won the lottery',
    'is taking a break',
    'is trying to paint',
    'is casting a spell',
    'is flying a kite',
    'is flying on a broomstick',
    'is flying a plane',
    'is jumping in puddles',
    'is singing in the shower',
    'is very hungry',
  ];
}
