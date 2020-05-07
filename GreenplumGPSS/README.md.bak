## Greenplum Stream Server(GPSS)
대용량 kafka Stream 메시지를 Greenplum에 적재하기 위한 Greenplum database connector.

## Greenplum Stream Server 주요기능
1. 다양한 유형의 Stream 데이터 적재
   - Json, csv, avro, binary, delimited(plain text)

2.데이터 병렬 적재
   - 개별 세그먼트 인스턴스에서 병렬 데이터 적재

3. 다양한 옵션 지원
   - MAX_ROW : 한번에 처리하는 Max row 수 설정
    - Default : 0
   - MINIMAL_INTERVAL: POLL 최소시간 설정
    - 최소 시간: 0.1 초, Default: 1초

## 사용 용도
1. 센서 데이터와 같은 이벤트성의 스트림 메시지 고속 적재 (100만 TPS)
2. CDC 솔루션 연동으로 대용량 DB Sync 작업

## Source 설명
1. gpss_gp
   - gpss를 수행하기 위한 Greenplum 쪽에서의 스크립트
2. gpss_kafka
   - gpss를 수행하기 위하여 kafka 쪽에서의 스크립트   

