/// \file
/// \brief The ExceptionIsEquivalentTest class.

#include <boost/test/auto_unit_test.hpp>
//#include <boost/test/included/unit_test.hpp>

//#include <boost/exception/all.hpp>

#include "Exception/ExceptionIsEquivalent.h"
#include "Exception/InvalidArgumentException.h"
#include "Exception/OutOfRangeException.h"

//using namespace boost;
using namespace std;

const string DEFAULT_EXCEPTION_STRING = "defaultExceptionString";
const string OTHER_EXCEPTION_STRING = "otherExceptionString";

BOOST_AUTO_TEST_SUITE(ExceptionIsEquivalentTestSuite)

BOOST_AUTO_TEST_CASE(TypeCheck) {
	const OutOfRangeException outOfRangeException1(DEFAULT_EXCEPTION_STRING);
	const OutOfRangeException outOfRangeException2(DEFAULT_EXCEPTION_STRING);
	ExceptionIsEquivalent<OutOfRangeException> equivalentToOutOfRangeException1(outOfRangeException1);

	const InvalidArgumentException invalidArgumentException1(DEFAULT_EXCEPTION_STRING);
	const InvalidArgumentException invalidArgumentException2(DEFAULT_EXCEPTION_STRING);
	ExceptionIsEquivalent<InvalidArgumentException> equivalentToInvalidArgumentException1(invalidArgumentException1);

	BOOST_CHECK(equivalentToOutOfRangeException1(outOfRangeException1));
	BOOST_CHECK(equivalentToOutOfRangeException1(outOfRangeException2));
	BOOST_CHECK(!equivalentToOutOfRangeException1(invalidArgumentException1));
	BOOST_CHECK(!equivalentToOutOfRangeException1(invalidArgumentException2));

	BOOST_CHECK(equivalentToInvalidArgumentException1(invalidArgumentException1));
	BOOST_CHECK(equivalentToInvalidArgumentException1(invalidArgumentException2));
	BOOST_CHECK(!equivalentToInvalidArgumentException1(outOfRangeException1));
	BOOST_CHECK(!equivalentToInvalidArgumentException1(outOfRangeException2));
}

BOOST_AUTO_TEST_CASE(StringCheck) {
	const InvalidArgumentException exceptionWithDefaultString(DEFAULT_EXCEPTION_STRING);
	const InvalidArgumentException exceptionWithOtherString(OTHER_EXCEPTION_STRING);
	ExceptionIsEquivalent<InvalidArgumentException> equivalentToExceptionWithDefaultString(exceptionWithDefaultString);
	ExceptionIsEquivalent<InvalidArgumentException> equivalentToExceptionWithOtherString(exceptionWithOtherString);

	BOOST_CHECK(equivalentToExceptionWithDefaultString(exceptionWithDefaultString));
	BOOST_CHECK(!equivalentToExceptionWithDefaultString(exceptionWithOtherString));
	BOOST_CHECK(!equivalentToExceptionWithOtherString(exceptionWithDefaultString));
	BOOST_CHECK(equivalentToExceptionWithOtherString(exceptionWithOtherString));

}

BOOST_AUTO_TEST_SUITE_END()

