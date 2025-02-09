package org.worldfinder.security;

import org.worldfinder.security.domain.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.worldfinder.domain.UserVO;
import org.worldfinder.mapper.UserMapper;

@Log4j
public class CustomUserDetailService implements UserDetailsService{
	
	@Setter(onMethod_= @Autowired )
	private UserMapper mapper;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.warn("load user by username : " + username  );
		
		UserVO vo = mapper.getUser(username);
		
		log.warn("member mapper : " + vo);
		
		return vo == null ? null : new CustomUser(vo);
	}
}
