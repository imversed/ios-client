#!/bin/bash

# be ensure that you have already installed `protoc` `swift-protobuf` `grpc-swift`
# you can install them with `brew install protoc swift-protobuf grpc-swift`

cd ../

PROTOBUF_PATH=${PWD}/Sources/Protobuf

echo "Removing contents of ${PROTOBUF_PATH}"
rm -r ${PROTOBUF_PATH}

echo "Creating grpc and swift protobuf directories"
mkdir -p ${PROTOBUF_PATH}/grpc
mkdir -p ${PROTOBUF_PATH}/swift

echo "Compiling..."

proto_dirs=$(find ./proto -path -prune -o -name '*.proto' -print0 | xargs -0 -n1 dirname | sort | uniq)
for dir in $proto_dirs; do
  protoc \
    --proto_path=proto \
    --plugin=/opt/homebrew/bin/protoc-gen-swift \
    --swift_opt=FileNaming=PathToUnderscores \
    --swift_out=${PROTOBUF_PATH}/swift \
    --plugin=/opt/homebrew/bin/protoc-gen-swift \
    --grpc-swift_opt=FileNaming=PathToUnderscores \
    --grpc-swift_out=${PROTOBUF_PATH}/grpc \
    $(find "${dir}" -maxdepth 1 -name '*.proto')
done

echo "Done"