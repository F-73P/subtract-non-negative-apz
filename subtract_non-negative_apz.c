//v1.00
//subtracts two non-negative arbitrary precision integers 

//includes

#include <stdint.h>
#include "apz.h"

//global variables

uint32_t limbs; //sign and number of limbs of difference

uint32_t m;
uint32_t n;
uint32_t * u;
uint32_t * v;

//assembly prototypes
extern uint32_t subtract_apz(uint32_t, uint32_t *, uint32_t, uint32_t *);

int main (void) {
    m = one[0];                                    
    u = &one[1];    
    
    n = three[0];
    v = &three[1];    
    
    limbs = subtract_apz(m, u, n, v);    
        
    while (1); 
}
