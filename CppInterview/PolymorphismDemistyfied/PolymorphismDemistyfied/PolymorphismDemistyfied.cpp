// PolymorphismDemistyfied.cpp :  
//@author igbt6  03-07-2013
//@brief Simple implemenation of polymorphism concept (vtables) in C language
//@note: http://www.state-machine.com/doc/AN_OOP_in_C.pdf
//@note: http://www.eventhelix.com/RealtimeMantra/basics/ComparingCPPAndCPerformance2.htm

#include "stdafx.h"
#include <math.h>
#include <iostream>


#define CPP_IMPLEMENTATION

#ifdef CPP_IMPLEMENTATION
class Shape {

public:
	struct Coordinates
	{
		int x;
		int y;
	};

	enum class Color
	{
		BLACK,
		BLUE,
		WHITE
	};

public:
	Shape() :m_coordinates{ 10,10 }, m_outline(Color::BLACK), m_fill(Color::WHITE)
	{
	}
	virtual double area() const = 0;
	virtual double perimeter() const = 0;

private:
	Coordinates m_coordinates;
	Color m_outline, m_fill;

};

class Circle : public Shape {
public:
	Circle(double radius):m_radius(radius)
	{
	}
	virtual double area() const
	{
		return PI * (m_radius * m_radius);
	}
	virtual double perimeter() const
	{
		return 2 * PI * m_radius;
	}
private:
	double m_radius;
	const double PI = 3.14;
};


class Rectangle : public Shape {
public:
	Rectangle(double height, double width) : m_height(height),m_width(width)
	{
	}
	virtual double area() const
	{
		return  m_height * m_width;
	}
	virtual double perimeter() const
	{
		return 2 * m_height + 2 * m_width;
	}
private:
	double m_height, m_width;
};

class Square : public Rectangle {
public:
	Square(double height):Rectangle(height, height),m_height(height)
	{
	}
	virtual double area() const
	{
		return  m_height * m_height;
	}
	virtual double perimeter() const
	{
		return 4 * m_height;
	}
private:
	double m_height;
};

int main()
{
	Shape *shape = new Circle(10);

	Circle circle(10);
	Rectangle rectangle(10, 10);

	std::cout<<"Circle area = "<<shape->area()<<std::endl; // should return ~6
	std::cout << "Circle perimeter = " << shape->perimeter() << std::endl; //should return ~314

	shape = &rectangle;
	std::cout << "Rectangle area = " << shape->area() << std::endl; // should return 100
	std::cout << "Rectangle perimeter = " << shape->perimeter() << std::endl; //should return 40

	int t;
	std::cin >> t;
	return 0;
}

#else //C_IMPLEMENTATION

const double PI = 3.14;

struct Coordinates
{
	int x;
	int y;
};

enum Color
{
	BLACK,
	BLUE,
	WHITE
};
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//declarations
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------------------
//SHAPE
typedef struct Shape Shape;
typedef struct Shape_vtbl Shape_vtbl;

struct Shape_vtbl {
	double(*area)(Shape const *s);
	double(*perimeter)(Shape const *s);
};

struct Shape {
	Shape_vtbl *vptr;
	Coordinates m_coordinates;
	Color m_outline, m_fill;
};

void shape_ctor(Shape *s, Coordinates coordinates, Color o, Color f);
double shape_area(Shape const *s);
double shape_perimeter(Shape const *s);
//----------------------------------------------------------------------------------
//CIRCLE
typedef struct Circle Circle;
typedef struct Circle_vtbl Circle_vtbl;

struct Circle_vtbl {
	double(*area)(Circle const *s);
	double(*perimeter)(Circle const *s);
};

struct Circle {
	Shape base;
	double m_radius;
};

void circle_ctor(Circle *c, double radius, Coordinates coordinates, Color outline, Color fill);
//----------------------------------------------------------------------------------
//RECTANGLE
typedef struct Rectangle Rectangle;
typedef struct Rectangle_vtbl Rectangle_vtbl;

struct Rectangle_vtbl {
	double(*area)(Rectangle const *s);
	double(*perimeter)(Rectangle const *s);
};

struct Rectangle {
	Shape base;
	double m_height, m_width;
};

void rectangle_ctor(Rectangle *r, double height, double width, Coordinates coordinates, Color outline, Color fill);
//----------------------------------------------------------------------------------


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//definitions
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------------------------------------------------------------
//SHAPE
static Shape_vtbl theShapeVtbl = 
{
	nullptr, /* purely-virtual function should never be called */
	nullptr
};
void shape_ctor(Shape *s, Coordinates coordinates, Color outline, Color fill)
{
	s->vptr = &theShapeVtbl;
	s->m_coordinates = coordinates;
	s->m_outline = outline;
	s->m_fill = fill;
}
double shape_area(Shape const *s)
{
	return (*s->vptr->area)(s);
}

double shape_perimeter(Shape const *s)
{
	return (*s->vptr->perimeter)(s);
}
//----------------------------------------------------------------------------------
//CIRCLE
double circle_area(Circle const *c)
{
	return PI * (c->m_radius * c->m_radius);
}
 double circle_perimeter(Circle const* c)
{
	return 2 * PI * c->m_radius;
}
static Circle_vtbl theCircleVtbl =
{
	circle_area,
	circle_perimeter
};
void circle_ctor(Circle *c, double radius, Coordinates coordinates, Color outline, Color fill)
{
	shape_ctor(&c->base, coordinates, outline, fill);
	c->base.vptr = (Shape_vtbl*)&theCircleVtbl;
	c->m_radius = radius;
}
//----------------------------------------------------------------------------------
//Rectangle
double rectangle_area(Rectangle const * r)
{
	return (2 * r->m_height) + (2 * r-> m_width);
}
double rectangle_perimeter(Rectangle const* r)
{
	return r->m_height * r->m_width;
}
static Rectangle_vtbl theRectangleVtbl =
{
	rectangle_area,
	rectangle_perimeter
};

void rectangle_ctor(Rectangle *r, double height, double width, Coordinates coordinates, Color outline, Color fill)
{
	shape_ctor(&r->base, coordinates, outline, fill);
	r->base.vptr = (Shape_vtbl*)&theRectangleVtbl;
	r->m_height = height;
	r->m_width = width;
}

//----------------------------------------------------------------------------------

int main()
{

	Circle circle;
	Rectangle rectangle;
	circle_ctor(&circle, 10, Coordinates{1, 2}, BLACK, BLUE);
	rectangle_ctor(&rectangle, 10, 10, Coordinates{ 1, 2 }, BLACK, BLUE);

	printf("Circle area = %3.2f\n", shape_area((const Shape*)&circle)); // should return ~6
	printf("Circle perimeter = %3.2f\n", shape_perimeter((const Shape*)&circle)); //should return ~314

	printf("Rectangle area = %3.2f\n", shape_area((const Shape*)&rectangle)); // should return 100
	printf("Rectangle perimeter = %3.2f\n", shape_perimeter((const Shape*)&rectangle)); //should return 40

	while (1);
	return 0;
}
#endif