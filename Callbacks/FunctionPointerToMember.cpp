#include <iostream>
#include <cstring>
using namespace std;



template <typename F>
class Callback;


/** Callback class based on template specialization
 *
 * @Note Synchronization level: Not protected
 */
template <typename R, typename A0>
class Callback<R(A0)> {
public:
    /** Create a Callback with a static function
     *  @param func Static function to attach
     */
    Callback(R (*func)(A0) = 0) {
        attach(func);
    }

    /** Create a Callback with a member function
     *  @param obj  Pointer to object to invoke member function on
     *  @param func Member function to attach
     */
    template<typename T>
    Callback(T *obj, R (T::*func)(A0)) {
        attach(obj, func);
    }


    /** Attach a static function
     *  @param func Static function to attach
     */
    void attach(R (*func)(A0)) {
        struct local {
            static R _thunk(void*, const void *func, A0 a0) {
                return (*static_cast<R (*const *)(A0)>(func))(
                        a0);
            }
        };

        memset(&_func, 0, sizeof _func);
        memcpy(&_func, &func, sizeof func);
        _obj = 0;
        _thunk = func ? &local::_thunk : 0;
    }



    /** Attach a member function
     *  @param obj  Pointer to object to invoke member function on
     *  @param func Member function to attach
     */
    template<typename T>
    void attach(T *obj, R (T::*func)(A0)) {
        struct local {
            static R _thunk(void *obj, const void *func, A0 a0) {
                return (((T*)obj)->*
                        (*static_cast<R (T::*const *)(A0)>(func)))(
                        a0);
            }
        };

        memset(&_func, 0, sizeof _func);
        memcpy(&_func, &func, sizeof func);
        _obj = (void*)obj;
        _thunk = &local::_thunk;
    }



    /** Call the attached function
     */
    R call(A0 a0) const {
        return _thunk(_obj, &_func, a0);
    }

    /** Call the attached function
     */
    R operator()(A0 a0) const {
        return call(a0);
    }

    /** Test if function has been attached
     */
    operator bool() const {
        return _thunk;
    }

    /** Test for equality
     */
    friend bool operator==(const Callback &l, const Callback &r) {
        return memcmp(&l, &r, sizeof(Callback)) == 0;
    }

    /** Test for inequality
     */
    friend bool operator!=(const Callback &l, const Callback &r) {
        return !(l == r);
    }

    /** Static thunk for passing as C-style function
     *  @param func Callback to call passed as void pointer
     */
    static R thunk(void *func, A0 a0) {
        return static_cast<Callback<R(A0)>*>(func)->call(
                a0);
    }

private:
    // Stored as pointer to function and pointer to optional object
    // Function pointer is stored as union of possible function types
    // to garuntee proper size and alignment
    struct _class;
    union {
        void (*_staticfunc)();
        void (*_boundfunc)(_class *);
        void (_class::*_methodfunc)();
    } _func;

    void *_obj;

    // Thunk registered on attach to dispatch calls
    R (*_thunk)(void*, const void*, A0);
};

class LCD
{
public:	
	LCD()
	{
		
	};
	
	void penIrqCallback(int pin)
	{
		m_status = pin;
		std::cout<<"m_status set to: "<<m_status<<std::endl;
	}
	
private:
	int m_status;
};

int main() {
	LCD lcd;
	Callback<void(int)> cb(&lcd,&LCD::penIrqCallback);
	cb.call(10);
	return 0;
}