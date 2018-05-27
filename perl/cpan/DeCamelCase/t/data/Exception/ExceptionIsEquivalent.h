/// \file
/// \brief The ExceptionIsEquivalent class header.

#ifndef EXCEPTION_IS_EQUIVALENT_H
#define EXCEPTION_IS_EQUIVALENT_H

#include <boost/exception/all.hpp>

/// \brief A simple predicate to establish whether a boost::exception is equivalent to this one
///       (can be cast to this one's type and same what() string).
///
/// The motivation for this class is to be used as the last argument in BOOST_CHECK_EXCEPTION()
///
/// Note: don't try to create a ExceptionIsEquivalent with a temporary exceptionToCompareTo because it will have been destroyed
///       by the time the operator() is called.

template <class T> class ExceptionIsEquivalent {
	const T &exceptionToCompareTo;

public:
	/// \brief Default constructor for ExceptionIsEquivalent.
	explicit ExceptionIsEquivalent(const T &argExceptionToCompareTo
	                               ) : exceptionToCompareTo(argExceptionToCompareTo) {
	}

	/// \brief Virtual empty destructor for ExceptionIsEquivalent.
	virtual ~ExceptionIsEquivalent() {
	}

	/// Function call operator (operator()) to compare the two boost::exception objects
	bool operator()(const boost::exception &argExceptionToCompare ///< The boost::exception that is to be compared
	                ) const {
		try {
			const T &exceptionToCompare = dynamic_cast<const T &>(argExceptionToCompare);
			const std::string exceptionToCompareToWhatString(exceptionToCompareTo.what());
			const std::string exceptionToCompareWhatString(exceptionToCompare.what());
			if (exceptionToCompareToWhatString != exceptionToCompareWhatString) {
//				std::cerr << "The diagnostic informations of the two exceptions don't match" << std::endl;
//				std::cerr << exceptionToCompareToWhatString << std::endl;
//				std::cerr << exceptionToCompareWhatString << std::endl;
				return false;
			}

//			std::cerr << "The two exceptions are equivalent" << std::endl;
			return true;
		}
		catch(const std::bad_cast &) {
			return false;
		}
	}
};

#endif
