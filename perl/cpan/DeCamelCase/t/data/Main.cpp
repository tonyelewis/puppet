#include <boost/exception/diagnostic_information.hpp>
// #include <boost/log/trivial.hpp>
// #include <boost/log/filters.hpp>

#include "ProgramOptions/ProgramOptions.h"

#include <iostream>

using namespace boost;
// using namespace boost::log;
// using namespace boost::log::filters;
// using namespace boost::log::trivial;

using namespace std;

const string BOOST_LOG_SEVERITY_STRING("Severity");

int main(int argc, char * argv[] ) {
	try {
		srand ( time(NULL) );
		srand ( time(NULL) );

// 		core::get()->set_filter(
// 			attr<severity_level>(BOOST_LOG_SEVERITY_STRING) >= info
// 		);

		ProgramOptions programOptions;
		programOptions.processProgramOptions(argc, argv);
	}
	catch (const boost::exception &e) {
		cerr << "In main caught a boost::exception:\n" << diagnostic_information(e) << "\n" << endl;
	}
	catch (const std::exception &e) {
		cerr << "Caught a std::exception:\n" << e.what() << endl;
	}
	catch (...) {
		cerr << "Caught an unrecognised exception" << endl;
	}
	return 0;
}
