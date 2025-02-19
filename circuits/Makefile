.SILENT:

CIRCUIT_WORKSPACE_ROOT ?= .

# CIRCUITS

circuit@check :; nargo check --workspace

circuit@test :; nargo test --workspace --show-output

circuit@build :; nargo build --workspace

circuit@execute :; nargo execute --workspace

circuit@compile :; nargo compile --workspace

# OWNERSHIP CIRCUIT

circuit@a+prove :; \
	bb prove \
	-b ${CIRCUIT_WORKSPACE_ROOT}/target/a.json \
	-w ${CIRCUIT_WORKSPACE_ROOT}/target/a.gz \
	-o ${CIRCUIT_WORKSPACE_ROOT}/target/a_proof -v

circuit@a+genvk :; \
	bb write_vk \
	-b ${CIRCUIT_WORKSPACE_ROOT}/target/a.json \
	-o ${CIRCUIT_WORKSPACE_ROOT}/target/a_vk -v

circuit@a+verify :; \
	bb verify \
	-k ${CIRCUIT_WORKSPACE_ROOT}/target/a_vk \
	-p ${CIRCUIT_WORKSPACE_ROOT}/target/a_proof -v

circuit@a+vk :; cat ${CIRCUIT_WORKSPACE_ROOT}/target/a_vk | od -An -v -t x1 | tr -d " \n"

circuit@a+proof :; tail -c +33 ${CIRCUIT_WORKSPACE_ROOT}/target/a_proof | od -An -v -t x1 | tr -d " \n"

circuit@a+contract :; \
	bb contract \
	-k ${CIRCUIT_WORKSPACE_ROOT}/target/a_vk \
	-o ${CIRCUIT_WORKSPACE_ROOT}/target/AVerifier.sol -v

circuit@a+all :; \
	make circuit@check && \
	make circuit@execute && \
	make circuit@compile && \
	make circuit@build && \
	make circuit@test && \
	make circuit@a+genvk && \
	make circuit@a+prove && \
	make circuit@a+verify && \
	make circuit@a+contract 

# TRUST CIRCUIT

circuit@b+prove :; \
	bb prove \
	-b ${CIRCUIT_WORKSPACE_ROOT}/target/b.json \
	-w ${CIRCUIT_WORKSPACE_ROOT}/target/b.gz \
	-o ${CIRCUIT_WORKSPACE_ROOT}/target/b_proof -v

circuit@b+genvk :; \
	bb write_vk \
	-b ${CIRCUIT_WORKSPACE_ROOT}/target/b.json \
	-o ${CIRCUIT_WORKSPACE_ROOT}/target/b_vk -v

circuit@b+verify :; \
	bb verify \
	-k ${CIRCUIT_WORKSPACE_ROOT}/target/b_vk \
	-p ${CIRCUIT_WORKSPACE_ROOT}/target/b_proof -v

circuit@b+vk :; cat ${CIRCUIT_WORKSPACE_ROOT}/target/b_vk | od -An -v -t x1 | tr -d " \n"

circuit@b+proof :; tail -c +33 ${CIRCUIT_WORKSPACE_ROOT}/target/b_proof | od -An -v -t x1 | tr -d " \n"

circuit@b+contract :; \
	bb contract \
	-k ${CIRCUIT_WORKSPACE_ROOT}/target/b_vk \
	-o ${CIRCUIT_WORKSPACE_ROOT}/target/BVerifier.sol -v

circuit@b+all :; \
	make circuit@check && \
	make circuit@execute && \
	make circuit@compile && \
	make circuit@build && \
	make circuit@test && \
	make circuit@b+genvk && \
	make circuit@b+prove && \
	make circuit@b+verify && \
	make circuit@b+contract

## ALL

circuit@all :; \
	make circuit@check && \
	make circuit@execute && \
	make circuit@compile && \
	make circuit@build && \
	make circuit@test && \
	make circuit@a+genvk && \
	make circuit@a+prove && \
	make circuit@a+verify && \
	make circuit@a+contract && \
	make circuit@b+genvk && \
	make circuit@b+prove && \
	make circuit@b+verify && \
	make circuit@b+contract

