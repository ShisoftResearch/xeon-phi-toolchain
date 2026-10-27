/* Ordinary scalar C expressions exercise the new default DAG lowering. */
float dag_add_value_f32(float a,float b){return a+b;}
float dag_sub_value_f32(float a,float b){return a-b;}
float dag_mul_value_f32(float a,float b){return a*b;}
double dag_add_value_f64(double a,double b){return a+b;}
double dag_sub_value_f64(double a,double b){return a-b;}
double dag_mul_value_f64(double a,double b){return a*b;}
float dag_fma_value_f32(float a,float b,float c){return __builtin_elementwise_fma(a,b,c);}
double dag_fma_value_f64(double a,double b,double c){return __builtin_elementwise_fma(a,b,c);}
