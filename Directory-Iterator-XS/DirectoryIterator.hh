#include <string>
#include <vector>
#include <sys/types.h>
#include <dirent.h>

class DirectoryIterator
{
private:
  std::vector<std::string> dirs_;
  DIR * dh_;
  std::string file_;
  std::string dir_;
  
  bool scan();
  
public:
  DirectoryIterator( std::string const & dir ) 
  {
    dh_ = 0;
    dirs_.push_back(dir);
  }
  ~DirectoryIterator() 
  {
    if (dh_) closedir(dh_);
  }

  bool next();
 
  std::string get() const
  {
    return file_;
  }
  
  void prune() 
  {
    if (dh_) closedir(dh_);
    dh_ = 0;
  }
  
};

  
  
