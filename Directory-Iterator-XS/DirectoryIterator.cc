#include "DirectoryIterator.hh"
#include <cstdio>
#include <cstring>
#include <sys/stat.h>

bool DirectoryIterator::scan () 
{
  struct dirent entry;
  struct dirent *de;
  while (readdir_r(dh_,&entry,&de) == 0) 
    {
      if (de == 0)
	break;
      
      if (de->d_name[0] == '.')
	continue;

#ifdef _DIRENT_HAVE_D_TYPE
      switch (de->d_type) 
	{
	case DT_DIR:
	  dirs_.push_back( dir_ + "/" + de->d_name );
	  break;
	case DT_REG:
	  {
	    file_ = dir_ + "/" + de->d_name;
	    return true;
	  }
	  
	case DT_UNKNOWN:
#endif
	  {
	    std::string path = dir_ + "/" + de->d_name;
	    struct stat buf;
	    stat(path.c_str(), &buf);
	    if (S_ISDIR(buf.st_mode)) 
	      {
		dirs_.push_back( path );
	      }
	    else if (S_ISREG(buf.st_mode)) 
	      {
		file_ = path;
		return true;
	      }
	  }
	  
#ifdef _DIRENT_HAVE_D_TYPE
	}
#endif
    }
  return false;
}

bool DirectoryIterator::next () 
{
  if (dh_) 
    {
      if ( scan() )
	return true;
      else
	{
	  closedir( dh_ );
	  dh_ = 0;
	}
      
    }
  while( dirs_.size() ) 
    {
      dir_ = dirs_.back();
      dirs_.pop_back();
      dh_ = opendir(dir_.c_str());
      if (dh_ == NULL)
	{
	  perror(dir_.c_str());
	}
      else
	{
	  if ( scan() ) return true;
	}
    }
  return false;
  
}

