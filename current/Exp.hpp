#ifndef EXP_HPP_
#define EXP_HPP_

struct expresionstruct {
  string str ;
  vector<int> trues ;
  vector<int> falses ;
};
typedef struct expresionstruct expresionstruct;

struct sentencestruct {
  vector<int> skips;
  vector<int> exits;
};
typedef struct sentencestruct sentencestruct;

#endif /* EXP_HPP_ */
