import 'dart:math';

class MathFacts {
  final int _numAddition;
  final int _numSubtraction;
  final int _numMultiplication;
  final int _numDivision;
  final int _summandMin;
  final int _summandMax;
  final int _additionMax;
  final int _multiplicandMin;
  final int _multiplicandMax;
  final int _productMax;
  Iterable<Problem> _problems;
  Iterator<Problem> get problems => _problems.iterator;


  MathFacts({numAddition,
    numSubtraction,
    numMultiplication,
    numDivision,
    summandMin,
    summandMax,
    additionMax,
    multiplicandMin,
    multiplicandMax,
    productMax}) : _numAddition = numAddition,
        _numSubtraction = numSubtraction,
        _numMultiplication = numMultiplication,
        _numDivision = numDivision,
        _summandMin = summandMin,
        _summandMax = summandMax,
        _additionMax = additionMax,
        _multiplicandMin = multiplicandMin,
        _multiplicandMax = multiplicandMax,
        _productMax = productMax {
    _problems = generateAddition().followedBy(
        generateSubtraction().followedBy(
            generateMultiplication().followedBy(
            generateDivision())));
  }

  Iterable<Problem> generateAddition() {
    return generateSumOperands()
        .take(_numAddition)
        .map((o) => Problem(o, o.o1 + o.o2, '\u002B'));
  }

  Iterable<Problem> generateSubtraction() {
    return generateSumOperands()
        .take(_numSubtraction)
        .map((o) => Problem(Operands(o.o1 + o.o2, o.o1), o.o2, '\u002D'));
  }

  List<Operands> generateSumOperands() {
    return generateOperands(_summandMin, _summandMin, _summandMax, _additionMax, (x, y) => x + y);
  }

  Iterable<Problem> generateMultiplication() {
    return generateProductOperands(_multiplicandMin)
        .take(_numMultiplication)
        .map((o) => Problem(o, o.o1 * o.o2, '\u00D7'));
  }

  Iterable<Problem> generateDivision() {
    return generateProductOperands(max(1, _multiplicandMin))
        .take(_numDivision)
        .map((o) => Problem(Operands(o.o1 * o.o2, o.o1), o.o2, '\u00F7'));
  }

  List<Operands> generateProductOperands(int leftOperandMin) {
    return generateOperands(leftOperandMin, _multiplicandMin, _multiplicandMax, _productMax, (x, y) => x * y);
  }

  List<Operands> generateOperands(
      int leftOperandMin,
      int rightOperandMin,
      int operandMax,
      int resultMax,
      Function operator) {

    Iterable<int> seed = List<int>.generate(operandMax + 1, (i) => i);

    Iterable<Operands> operands = seed
        .skip(leftOperandMin)
        .map((i) {
          return seed.skip(rightOperandMin).map((ii) {
            return Operands(i, ii);
          }).where((o) => operator(o.o1, o.o2) <= resultMax);
        })
        .where((l) => l.length > 0)
        .expand((e) => e);

    List<Operands> shuffledOperands = operands.toList();
    shuffledOperands.shuffle();

    return shuffledOperands;
  }

  int get numAddition => _numAddition;
  int get numSubtraction => _numSubtraction;
  int get numMultiplication => _numMultiplication;
  int get numDivision => _numDivision;
  int get summandMin => _summandMin;
  int get summandMax => _summandMax;
  int get additionMax => _additionMax;
  int get multiplicandMin => _multiplicandMin;
  int get multiplicandMax => _multiplicandMax;
  int get productMax => _productMax;
}

class Operands {
  final int o1;
  final int o2;

  Operands(this.o1, this.o2);
}

class Problem {
  final Operands operands;
  final int answer;
  final String operator;

  Problem(this.operands, this.answer, this.operator);

  @override
  String toString() {
    return '${operands.o1}${operator}${operands.o2}=';
  }
}
