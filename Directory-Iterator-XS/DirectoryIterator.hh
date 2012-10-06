#include <string>
#include <vector>
#include <sys/types.h>
#include <dirent.h>

class DirectoryIterator
{
private:
  std::vector<std::string> dirs_;
  bool show_dotfiles_;
  
  DIR * dh_;
  std::string file_;
  std::string dir_;
  static const std::string separator_;
  
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
 
  void show_dotfiles(bool arg) 
  {
    show_dotfiles_ = arg? true : false;
  }
  
  std::string get() const
  {
    return dir_ + separator_ + file_;
  }

  void prune();
  
};

  
  
