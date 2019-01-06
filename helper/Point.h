

using namespace std;

class Point{
     public:
          int x, y;
          Point();
          Point(int a, int b) {x=a;y=b;}
          friend Point* operator+ (const Point &op1, const Point &op2)
          {
               return new Point(op1.x+op2.x, op1.x+op2.y);
          }
          friend Point* operator- (const Point &op1, const Point &op2)
          {
               return new Point(op1.x-op2.x, op1.x-op2.y);
          }
          friend Point* operator* (const Point &op1, const Point &op2)
          {
               return new Point(op1.x*op2.x, op1.x*op2.y);
          }
          friend Point* operator/ (const Point &op1, const Point &op2)
          {
               return new Point(op1.x/op2.x, op1.x/op2.y);
          }
          int toInt()
          {
              return x;
          }
};