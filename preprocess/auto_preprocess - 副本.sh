echo "Preprocessing the raw instance..."
echo "Building data analysis tool..."
cd ./step3_data_analysis
make
./bin/dataAnalysis ./bin ../../result ../../result
make remove
echo "First step of encoded Instance done."
echo "Building sequential features..."
cd ..
python3 ./step3_VAE_preprocess.py
echo "Preprocessing done."
