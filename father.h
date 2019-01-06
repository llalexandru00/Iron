class tup{
     public:
          int x, y;
          tup();
          tup(int a, int b) {x=a;y=b;}
          friend tup* operator+ (const tup &op1, const tup &op2)
          {
               return new tup(op1.x+op2.x, op1.x+op2.y);
          }
          friend tup* operator- (const tup &op1, const tup &op2)
          {
               return new tup(op1.x-op2.x, op1.x-op2.y);
          }
          friend tup* operator* (const tup &op1, const tup &op2)
          {
               return new tup(op1.x*op2.x, op1.x*op2.y);
          }
          friend tup* operator/ (const tup &op1, const tup &op2)
          {
               return new tup(op1.x/op2.x, op1.x/op2.y);
          }
};