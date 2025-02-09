package org.worldfinder.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RequestVO {
    private String rq_name, rq_address, rq_tel, rq_category, rq_url;
}
