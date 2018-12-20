class tuple{
     public:
          int x, y;
          tuple();
          tuple(int a, int b) {x=a;y=b;}
          friend tuple* operator+ (const tuple &op1, const tuple &op2)
          {
               return new tuple(op1.x+op2.x, op1.x+op2.y);
          }
          friend tuple* operator- (const tuple &op1, const tuple &op2)
          {
               return new tuple(op1.x-op2.x, op1.x-op2.y);
          }
          friend tuple* operator* (const tuple &op1, const tuple &op2)
          {
               return new tuple(op1.x*op2.x, op1.x*op2.y);
          }
          friend tuple* operator/ (const tuple &op1, const tuple &op2)
          {
               return new tuple(op1.x/op2.x, op1.x/op2.y);
          }
};