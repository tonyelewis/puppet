/// \file
/// \brief The main test file that defines the test module "Tonys Master Test Suite"

#define BOOST_TEST_MODULE Tonys Master Test Suite
#define BOOST_AUTO_TEST_MAIN

#include <boost/test/unit_test.hpp>
#include <boost/test/unit_test_monitor.hpp>

// #include <boost/log/trivial.hpp>
// #include <boost/log/filters.hpp>
#include <boost/pool/detail/singleton.hpp>

#include "Evaluator/Cuda/CudaResource/CudaResourceSet/CudaResourceSetDealer.h"
#include "Evolution/RunVisitor/Timer/Timer.h"

using namespace boost;
using namespace boost::details::pool;
// using namespace boost::log;
// using namespace boost::log::filters;
// using namespace boost::log::trivial;
using namespace boost::unit_test;
using namespace std;

void BoostExceptionTranslator(const boost::exception &e) {
	cerr << "The execution_monitor caught a boost::exception and passed it to the BoostExceptionTranslator :\n" << diagnostic_information(e) << "\n" << endl;
	throw;
}

class PrepareForTestGlobalFixture {
public:
	PrepareForTestGlobalFixture() {
		unit_test_monitor.register_exception_translator<boost::exception>(&BoostExceptionTranslator);
		try {
			Timer timer;
			singleton_default<CudaResourceSetDealer>::instance().ensureThreadIsRegistered(timer);
			cudaGetLastError(); // Ensure that any previous errors are cleared
// 			core::get()->set_filter(
// 				attr<severity_level>("Severity") >= error
// 			);
		}
		catch (const boost::exception &e) {
			cerr << "In PrepareForTestGlobalFixture::PrepareForTestGlobalFixture(), caught a boost::exception:\n" << diagnostic_information(e) << "\n" << endl;
			throw;
		}
		catch (const std::exception &e) {
			cerr << "In PrepareForTestGlobalFixture::PrepareForTestGlobalFixture(), caught a std::exception:\n" << e.what() << endl;
			throw;
		}
		catch (...) {
			cerr << "In PrepareForTestGlobalFixture::PrepareForTestGlobalFixture(), caught an unrecognised exception" << endl;
			throw;
		}
	}
	virtual ~PrepareForTestGlobalFixture() {
	}
};

BOOST_GLOBAL_FIXTURE(PrepareForTestGlobalFixture)
