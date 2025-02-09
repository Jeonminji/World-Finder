package org.worldfinder.service;


import javax.servlet.http.HttpSession;

import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.worldfinder.domain.UserVO;
import org.worldfinder.mapper.UserMapper;

import lombok.extern.log4j.Log4j;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Log4j
@Service
public class UserServiceImpl implements UserService {
	@Autowired
	private UserMapper usermapper;

	@Setter(onMethod_= @Autowired )
	private PasswordEncoder pwencoder;

	
	@Override
	public int userJoin(UserVO vo){
		log.info("userJoin...." + vo);

		vo.setU_pw(pwencoder.encode(vo.getU_pw()));

		return usermapper.userJoin(vo);
	}
	
	// 아이디 중복체크
	@Override
	public int checkId(String u_writer) throws Exception {
		return usermapper.checkId(u_writer);
	}

	// 로그인 체크
	@Override
	public int loginCheck(UserVO vo) {
		return usermapper.loginCheck(vo);
	}


	@Override
	public void logout(HttpSession session) {
		session.invalidate();
	}
	
	// 아이디찾기
	@Override
	public String findId(UserVO vo) {
		String result = "";
		List<String> vos = usermapper.findId(vo);
		if (vos.size() > 0) {
			for (String sum :
					vos) {
				result += sum + ",";
			}
			result = result.substring(0,result.length()-1);
		}

		return result;
	}

	@Override
	public Map<String,Boolean> findPw(UserVO vo) {
		Map<String,Boolean> result = new HashMap<>();
		result.put("result",false);

		if (usermapper.findPw(vo) != null){
			result.put("result",true);
		}
		return result;
	}

	// 비밀번호 변경
	@Override
	public Map<String,Boolean> changePw(UserVO vo) {
		Map<String,Boolean> result = new HashMap<>();
		result.put("result",false);
		vo.setU_pw(pwencoder.encode(vo.getU_pw()));


		if (usermapper.changePw(vo) > 0){
			result.put("result",true);
		}
		return result;
	}

	@Override
	public Map<String,Boolean> userModify(UserVO vo) {
		Map<String,Boolean> result = new HashMap<>();
		result.put("result",false);

		if (usermapper.userModify(vo) > 0){
			result.put("result",true);
		}
		return result;
	}

	@Override
	public UserVO getUser(String u_writer) {
		return usermapper.getUser(u_writer);
	}


}
		
	

